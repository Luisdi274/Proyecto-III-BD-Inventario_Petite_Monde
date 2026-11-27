DROP SCHEMA IF EXISTS PETIT_MONDE CASCADE;
CREATE SCHEMA PETIT_MONDE;
--siempre iniciamos eliminando en caso de existir para cuando se hagan pruebas y ejecutar desde cero

SET search_path TO PETIT_MONDE,public;
--nos ubicamos en el schema especifico para dinamismo


CREATE TABLE categoria(
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(110) NOT NULL UNIQUE,
    descripcion VARCHAR(240)
);
/*primera tabla basado en el Anexo 1, esto porque por logica deberian primero existir las categorias y subcategorias para despues
almacenar ahi los productos*/

CREATE TABLE subcategorias(
    id_subcategoria SERIAL PRIMARY KEY,
    nombre_subcategoria VARCHAR(110) NOT NULL UNIQUE,
    id_categoria INT
    --se pone esto, porque una subcategoria debe referencia una categoria
    CONSTRAINT fk_subcategoria FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT,
    --en caso de que se actualice el id del padre se hace en cascada, pero no se pueden borrar categorias que tengan hijos
    CONSTRAINT criterio_unicidad__nombre_subcategoria UNIQUE (id_categoria,nombre_categoria)
    -- esta restriccion permite que una subcategoria se pueda repetir en distintas categorias, pero no en la misma. Por eso es fk compuesta
);

CREATE TABLE proveedores(
    id_proveedor SERIAL PRIMARY KEY,
    nombre_proveedor NOT NULL UNIQUE,
    contacto_nombre VARCHAR(120) NOT NULL,
    --es a la persona principal a la que se contacta para hablar con proveedor
    telefono VARCHAR(35) NOT NULL,
    --aqui por el contexto, vamos a imponer que es un unico telefono de contacto
    --por eso mismo no se hace otra tabla, por no ser un atributo multivaluado
    pais VARCHAR(70) NOT NULL DEFAULT 'Costa Rica'
    --pais de origen del proveedor, lo ponemos por defecto en Costa Rica
);
--es logico que la tabla de proveedores se cree antes que los productos, pues ellos son quienes manejan esos productos y se debe saber eso

CREATE TABLE almacenes(
    id_almacen SERIAL PRIMARY KEY,
    nombre_almacen VARCHAR(110) NOT NULL UNIQUE,
    ubicacion VARCHAR(200) NOT NULL,
    almacen_esta_activo BOOLEAN NOT NULL DEFAULT TRUE
    --dejamos por defecto establecido que el almacen si opera
);

CREATE TABLE productos(
    id_producto SERIAL PRIMARY KEY,
    sku VARCHAR(30) NOT NULL UNIQUE,
    nombre_producto VARCHAR(140) NOT NULL,
    id_subcategoria INT NOT NULL,  
    --sirve como fk normalizada (enlace a jerarquia normalizada)
    id_proveedor INT NOT NULL,
    --ayuda a conectar con proveedor principal
    --es un codigo de negocio unico por cada unidad o tipo de producto con sus variaciones
    costo_unitario NUMERIC(12,2) NOT NULL CHECK (costo_unitario>=0),
    precio_venta NUMERIC(12,2) NOT NULL CHECK (precio_venta>=costo_unitario),
    /*Hay una regla de negocio que especifica que el precio de venta no puede ser menor
    al costo de compra unitario*/
    CONSTRAINT fk_producto_en_subcategoria FOREIGN KEY (id_subcategoria) REFERENCES subcategorias(id_subcategoria)
    ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_producto_con_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor) ON UPDATE CASCADE ON DELETE RESTRICT

);


--como producto<-->almacen es una relacion N:M, se debe hacer la tabla intermedia

CREATE TABLE inventario_en_almacen(
    id_inventario SERIAL primary KEY
    id_producto INT NOT NULL,
    id_almacen INT NOT NULL,

    --ahora debemos cumplir con 4 propiedades ACID
    --en este cao es para que una venta nunca permita que el inventario quede en valores negativos
    stock_actual INT NOT NULL DEFAULT 0 CHECK(stock_actual>=0),
    
    --una variable por si acaso para controlar el stock_minimo que debería haber
    stock_minimo INT NOT NULL DEFAULT 4 CHECK(stock_minimo >=0)
    --el enunciado menciona que la meta de inventario debe ser stock_optimo - stock_actual
    stock_optimo INT NOT NULL DEFAULT 20 CHECK (stock_optimo>=stock_minimo),
    ultimo_cambio_en_stock TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    --para seguir como cambian datos y mantener trazabilidad
    
    CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_inventario_almacen FOREIGN KEY(id_almacen) REFERENCES almacenes(id_almacen)
    ON UPDATE CASCADE ON DELETE RESTRICT,

    --ahora vamos a hacer una restriccion que diga que no pueden haber 2 filas duplicadas del mismo producto en el mismo almacen
    CONSTRAINT criterio_unicidad_producto_y_almacen UNIQUE (id_producto,id_almacen)


);


CREATE TABLE ventas(
    id_venta SERIAL PRIMARY KEY,  
    --se refiera numero de factura
    id_almacen INT NOT NULL,
    -- para fk y saber en que sucursal se da la venta
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    --se refiere a cuando se dio la venta
    usuario_registro VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
    --auditoría de quien registró venta
    total_venta NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (total_venta>=0),
    CONSTRAINT fk_venta_almacen FOREIGN KEY (id_almacen) REFERENCES almacenes(id_almacen) ON UPDATE cascade on DELETE RESTRICT

);

CREATE TABLE detalle_ventas(
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >0),
    --no se pueden ventas de 0 o negativas
    precio_unitario NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total_venta>=0),
    --ahora vamos a tener una columna calculada automáticamente para no tener inconsistencias

    subtotal NUMERIC(14,2) GENERATED ALWAYS AS (cantidad*precio_unitario) STORED,

    CONSTRAINT fk_detalle_de_venta FOREIGN KEY (id_venta)
    REFERENCES ventas(id_venta) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_detalle_producto FOREIGN KEY(id_producto) REFERENCES productos(id_producto) ON UPDATE CASCADE RESTRICT 

);

/*Ahora hacemos transferencias entre almacenes*/
CREATE TABLE transferencias(
    id_transferencia SERIAL PRIMARY KEY,
    id_almacen_origen INT NOT NULL,
    --sucursal que envia mercancia
    id_almacen_destino INT NOT NULL,
    --sucursal que recibe mercancia
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    --cantidad movida de mercancía
    fecha_transferencia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_responsable VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
    --control de ciclo de vida de la logística
    -- Ej: traslado de Cartago->San José
    estado VARCHAR(30) NOT NULL DEFAULT 'COMPLETADA'
        CHECK(estado IN('PENDIENTE','EN_TRANSITO','COMPLETADA','CANCELADA')),
    CONSTRAINT fk_transferencia_origen FOREIGN KEY (id_almacen_origen) REFERENCES almacenes(id_almacen),

    CONSTRAINT fk_transferencia_destino FOREIGN KEY (id_almacen_destino) REFERENCES almacenes(id_almacen),
    
    CONSTRAINT fk_transferencia_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    --regla lógica: no se puede transferir mercancía de un almacén hacia sí mismo
    CONSTRAINT revision_almacenes_distintos CHECK (id_almacen_origen <> id_almacen_destino)
);

CREATE TABLE movimientos_en_inventario(
    id_movimiento SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    --ese va a ser el producto afectado
    id_almacen INT NOT NULL,
    --almacen donde ocurrió el movimiento
    tipo_movimiento VARCHAR(30) NOT NULL CHECK(tipo_movimiento IN ('ENTRADA','SALIDA','TRANSFERENCIA_ENTRADA','TRANSFERENCIA_SALIDA')),
    cantidad INT NOT NULL CHECK(cantidad > 0),
    fecha_movimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_referencia INT,
    usuario_responsable VARCHAR(110) NOT NULL DEFAULT CURRENT_USER,
    observaciones VARCHAR(255),

    CONSTRAINT fk_movimientos_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),

    CONSTRAINT fk_movimiento_almacen FOREIGN KEY (id_almacen) REFERENCES almacenes(id_almacen)
    --esto se refiere a la persona que hizo el report

);


CREATE TABLE auditoria_reportes (
    id_auditoria SERIAL PRIMARY KEY,
    nombre_reporte VARCHAR(110) NOT NULL,
    --nombre del SP invocado
    parametros_usados TEXT,
    -- parametros de categoria y fecha consultados
    fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_ejecutor VARCHAR(110) NOT NULL DEFAULT CURRENT_USER
    --esto se refiere a la persona que hizo el reporte
);

/*AHORA VAMOS A HACER INDICES*/
CREATE INDEX idx_inventario_de_almacen ON inventario_en_almacen(id_almacen);
-- asi acelera la busqueda y aplica seguridad a nivel de fila

CREATE INDEX idx_mov_fecha_prod ON movimientos_en_inventario(fecha_movimiento,id_producto);
--Asi se acelera el reporte 2

CREATE INDEX idx_movimiento_almacen ON movimientos_en_inventario(id_almacen);
--acelera auditoría por sede