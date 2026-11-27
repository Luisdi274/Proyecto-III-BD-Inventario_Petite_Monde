SET search_path TO PETIT_MONDE,public;

INSERT INTO categorias (nombre, descripcion) VALUES
('Electronica','Equipos de cómputo, monitores y periféricos tecnológicos'),
('Muebles', 'Mobiliario ergonómico y equipamiento de oficina'),             
('Accesorios', 'Cables, adaptadores y complementos de escritorio');

INSERT INTO subcategorias(id_categoria) VALUES
(1,'Monitores'),
(1,'Periféricos'),
(2,'Oficina'),
(3, 'Oficina'),
(3,'Periféricos'),
(3, 'Cables');

INSERT INTO proveedores (nombre_proveedor,contacto_nombre_para_proveedor,telefono_proveedor,pais_proveedor) VALUES
('Tech Supplies Co.', 'Carlos Ruiz', '+506 8888-1111', 'Costa Rica'),  
('Muebles & Confort', 'Ana Gómez',   '+506 8888-2222', 'Costa Rica'),  
('Importadora Global','Luis Mora',   '+506 8888-3333', 'Costa Rica');

INSERT INTO almacenes(nombre_almacenm,ubicacion,almacen_esta_activo) VALUES
('Almacén Central', 'Cartago, Costa Rica', TRUE),   
('Bodega Norte',    'San José, Costa Rica', TRUE);  


INSERT INTO productos(sku,nombre_producto,id_subcategoria,id_proveedor,costo_unitario,precio_venta) VALUES
('ELE-101', 'Monitor Gamer 27" 144Hz',      1, 1, 200.00, 280.00), 
('ELE-102', 'Teclado Mecánico RGB',         2, 1,  45.00,  65.00), 
('OFF-201', 'Silla Ergonómica Ejecutiva',   3, 2, 130.00, 195.00), 
('OFF-202', 'Escritorio Ajustable de Pie',  3, 2, 240.00, 350.00), -- ID 4 (Para probar estado Agotado)
('ACC-301', 'Mousepad XL Antideslizante',   4, 3,   8.00,  15.00), 
('ACC-302', 'Cable HDMI 2.1 2m',            5, 3,   4.00,   8.00), 
('ELE-105', 'Cable DisplayPort 1.4',        5, 1,  12.00,  25.00); 


INSERT INTO inventario_en_almacen(id_producto,id_almacen,stock_actual,stock_minimo,stock_optimo) VALUES
(1, 1, 20,  5, 30),  
(2, 1,  8, 10, 25),  
(3, 1, 15,  3, 20),  
(4, 1,  0,  2, 10),  -- OFF-202: Agotado (0 unidades -> prueba manejo de ceros/nulos)
(7, 1, 35, 10, 40),  

(1, 2,  4,  5, 15), 
(5, 2, 50, 15, 60),  
(6, 2,  8, 12, 40),  
(7, 2, 18,  5, 25); 


INSERT INTO movimientos_en_inventario(id_producto,id_almacen,tipo_movimiento,cantidad,fecha_movimiento,observaciones) VALUES
(1, 1, 'ENTRADA', 30, '2026-01-05 09:00:00', 'Abastecimiento inicial Q1'),
(1, 1, 'SALIDA',  25, '2026-01-20 14:30:00', 'Despacho corporativo'),      
(1, 1, 'SALIDA',  20, '2026-02-18 11:15:00', 'Venta mostrador Cartago'),  
(2, 1, 'ENTRADA', 40, '2026-01-08 10:00:00', 'Abastecimiento inicial Q1'),
(2, 1, 'SALIDA',  18, '2026-02-10 16:00:00', 'Venta retail'),              
(2, 1, 'SALIDA',  10, '2026-03-12 13:45:00', 'Venta retail'),              
(7, 1, 'ENTRADA', 40, '2026-01-10 08:30:00', 'Abastecimiento cables'),
(7, 1, 'SALIDA',   3, '2026-03-05 15:20:00', 'Venta menor'),                
--aqui se usan ejemplos para almacen de San Jo´se para demostrar que hay independencia entre sedes
(5, 2, 'ENTRADA', 80, '2026-01-12 09:30:00', 'Ingreso Bodega Norte'),
(5, 2, 'SALIDA',  30, '2026-02-22 17:10:00', 'Despacho San José'),
(6, 2, 'ENTRADA', 50, '2026-01-15 10:45:00', 'Ingreso Bodega Norte'),
(6, 2, 'SALIDA',  42, '2026-03-18 12:05:00', 'Venta mayorista San José');