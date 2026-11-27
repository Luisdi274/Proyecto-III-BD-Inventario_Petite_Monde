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
