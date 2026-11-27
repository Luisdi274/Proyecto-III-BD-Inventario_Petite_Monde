SET search_path TO PETIT_MONDE,public;

INSERT INTO categorias (nombre, descripcion) VALUES
('Electronica','Equipos de cómputo, monitores y periféricos tecnológicos'),
('Muebles', 'Mobiliario ergonómico y equipamiento de oficina'),             -- ID 2
('Accesorios', 'Cables, adaptadores y complementos de escritorio');

INSERT INTO subcategorias(id_categoria) VALUES
(1,'Monitores'),
(1,'Periféricos'),
(2,'Oficina'),
(3, 'Oficina'),
(3,'Periféricos'),
(3, 'Cables');