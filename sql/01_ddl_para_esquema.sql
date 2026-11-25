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
);
