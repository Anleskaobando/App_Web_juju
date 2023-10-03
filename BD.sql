CREATE DATABASE bd_juju;
USE bd_juju;

CREATE TABLE bitacora (
id_bitacora INT NOT NULL AUTO_INCREMENT,
transaccion VARCHAR(10) NOT NULL,
usuario VARCHAR(40) NOT NULL,
fecha DATETIME NOT NULL,
tabla VARCHAR(20) NOT NULL,
PRIMARY KEY (id_bitacora)
);

CREATE TABLE Cliente (
  Id_Cliente INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(20),
  Apellido VARCHAR(20),
  Direccion VARCHAR(50),
  Telefono VARCHAR(9),
  Correo VARCHAR(50)
);

CREATE TABLE Pedido (
  Id_Pedido INT AUTO_INCREMENT PRIMARY KEY,
  Fecha_Pedido DATE,
  Direccion VARCHAR(100),
  Estado_Pedido VARCHAR(50),
  Id_Cliente INT
);

CREATE TABLE Categorias (
  Id_Categoria INT AUTO_INCREMENT PRIMARY KEY,
  Nombre_Categoria VARCHAR(20)
);

CREATE TABLE Producto (
  Id_Producto INT AUTO_INCREMENT PRIMARY KEY,
  Nombre_Producto VARCHAR(50),
  Descripcion VARCHAR(100),
  Precio DECIMAL(12, 2),
  Id_Categoria INT
);

CREATE TABLE Detalle (
  Id_Detalle INT AUTO_INCREMENT PRIMARY KEY,
  Cantidad INT,
  Id_Producto INT,
  Id_Pedido INT
);

ALTER TABLE Producto
ADD CONSTRAINT fk_Producto_Categoria
FOREIGN KEY (Id_Categoria)
REFERENCES Categorias(Id_Categoria);

ALTER TABLE Detalle
ADD CONSTRAINT fk_Detalle_Producto
FOREIGN KEY (Id_Producto)
REFERENCES Producto(Id_Producto);

ALTER TABLE Detalle
ADD CONSTRAINT fk_Detalle_Pedido
FOREIGN KEY (Id_Pedido)
REFERENCES Pedido(Id_Pedido);

ALTER TABLE Pedido
ADD CONSTRAINT fk_Pedido_Cliente
FOREIGN KEY (Id_Cliente)
REFERENCES Cliente(Id_Cliente);


INSERT INTO Cliente (Nombre, Apellido, Direccion, Telefono, Correo)
VALUES ('Martha', 'Diaz', 'Hospital', '4589-4563', 'marthadiaz@gmail.com');

INSERT INTO Pedido (Fecha_Pedido, Direccion, Estado_Pedido)
VALUES ('2023-10-10', 'UNO', 'En Proceso');

INSERT INTO Categorias ( Nombre_Categoria)
VALUES ('Collar');


INSERT INTO Producto (Nombre_Producto, Descripcion, Precio)
VALUES ('Collar de Acero', 'Collar de acero inoxidable', '100');

INSERT INTO Detalle (Cantidad)
VALUES (10);


UPDATE Cliente
SET Nombre = 'Mary',
    Apellido = 'Lopez',
    Direccion = 'Mercado',
    Telefono = '8899-6323',
    Correo = 'marylopez@gmail.com'
    WHERE Id_Cliente ;
    
UPDATE Pedido
SET Fecha_Pedido = '2023-12-20',
    Direccion = 'PUMA',
    Estado_Pedido = 'Pendiente'
    WHERE Id_Pedido;
    
UPDATE Categorias
SET Nombre_Categoria = 'Pulsera'
    WHERE Id_Categoria = 2; 
    
UPDATE Producto 
SET Nombre_Producto = 'Pulsera de hilos',
    Descripcion = 'Pulsera con piedras y hilo rojo',
    Precio = '60'
    WHERE Id_Producto = 1;
    
UPDATE Detalle 
SET Cantidad = 5
WHERE Id_Detalle = 2;    


/*Creacion de rol*/

CREATE ROLE 'admin';

/*Asignacion de permiso rol*/

GRANT ALL ON bd_juju.* TO 'admin';

/*Crear usuario*/

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin123';

/*Asigno rol a usuario creado*/

GRANT 'admin' TO 'admin'@'localhost';

/*Reviso de permisos de usuario*/

SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'admin'@'localhost' USING 'admin';

SELECT CURRENT_ROLE();

SET DEFAULT ROLE ALL TO
'admin'@'localhost';

/*Trigger*/

CREATE TRIGGER TinsertCliente
AFTER INSERT ON Cliente
FOR EACH ROW 
INSERT INTO bitacora(transaccion, usuario, fecha, tabla)
VALUES('INSERT', current_user(), NOW(), 'Cliente');

CREATE TRIGGER TinsertPedido
AFTER INSERT ON Pedido
FOR EACH ROW 
INSERT INTO bitacora(transaccion, usuario, fecha, tabla)
VALUES('INSERT', current_user(), NOW(), 'Pedido');

CREATE TRIGGER TinsertCategorias
AFTER INSERT ON Categorias
FOR EACH ROW 
INSERT INTO bitacora(transaccion, usuario, fecha, tabla)
VALUES('INSERT', current_user(), NOW(), 'Categorias');

CREATE TRIGGER TinsertProducto
AFTER INSERT ON Producto
FOR EACH ROW 
INSERT INTO bitacora(transaccion, usuario, fecha, tabla)
VALUES('INSERT', current_user(), NOW(), 'Producto');

CREATE TRIGGER TinsertDetalle
AFTER INSERT ON Detalle
FOR EACH ROW 
INSERT INTO bitacora(transaccion, usuario, fecha, tabla)
VALUES('INSERT', current_user(), NOW(), 'Detalle');


SELECT * FROM bitacora

