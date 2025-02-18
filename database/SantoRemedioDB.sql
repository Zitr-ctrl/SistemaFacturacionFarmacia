create database SantoRemedioDB;
use SantoRemedioDB;

select * from Usuario;

create table Pais(
	id_pais int primary key auto_increment,
	nombre varchar(100) not null
);

create table Ciudad(
	id_ciudad int primary key auto_increment,
    nombre varchar(100) not null,
    id_pais int,
    foreign key (id_pais) references Pais(id_pais)
);

create table Puesto(
	id_puesto int primary key auto_increment,
    nombre varchar(100) not null
);

create table Farmacia(
	id_farmacia int primary key auto_increment,
    nombre varchar(100) not null unique,
    telefono varchar(10) not null unique,
    ruc varchar(10) not null unique,
    id_ciudad int,
    foreign key (id_ciudad) references Ciudad(id_ciudad)
);

create table Usuario(
	id_usuario int primary key auto_increment,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    cedula varchar(10) not null unique,
    telefono varchar(10) not null unique,
    correo varchar(150) not null unique,
    contraseña varchar(150) not null,
    id_puesto int,
    id_farmacia int,
    id_ciudad int,
    foreign key (id_puesto) references Puesto(id_puesto),
    foreign key (id_farmacia) references Farmacia(id_farmacia),
    foreign key (id_ciudad) references Ciudad(id_ciudad)
);

create table Cliente(
	id_cliente int primary key auto_increment,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    cedula varchar(10) not null unique,
    telefono varchar(10) not null unique,
    email varchar(100) not null unique,
    id_ciudad int,
    foreign key (id_ciudad) references Ciudad(id_ciudad)
);

create table Proveedor(
	id_proveedor int primary key auto_increment,
    nombre varchar(150) not null,
    telefono varchar(10) not null unique,
    email varchar(60) not null unique,
    id_ciudad int,
    foreign key (id_ciudad) references Ciudad(id_ciudad)
);

create table Producto(
	id_producto int primary key auto_increment,
    descripcion varchar(60) not null,
    precio_venta decimal(10,2) not null,
    precio_compra decimal(10,2) not null,
    stock int not null,
    fecha_elaboracion date,
    fecha_vencimiento date
);

create table Inventario(
	id_inventario int primary key auto_increment,
    stock_inicial int not null,
    stock_actual int not null,
    fecha_actualizacion date not null,
    id_farmacia int,
    id_producto int,
    foreign key (id_farmacia) references Farmacia(id_farmacia),
    foreign key (id_producto) references Producto(id_producto)
);

create table Venta(
	id_venta int primary key auto_increment,
    fecha date not null,
    total decimal(10,2) not null,
    id_farmacia int,
    id_usuario int,
    id_cliente int,
    foreign key (id_farmacia) references Farmacia(id_farmacia),
    foreign key (id_usuario) references Usuario(id_usuario),
    foreign key (id_cliente) references Cliente(id_cliente)
);

create table DetalleVenta(
	id_detalle_venta int primary key auto_increment,
    cantidad int not null,
    precio_unitario decimal(10,2) not null,
    subtotal decimal(10,2) not null,
    id_venta int,
    id_producto int,
    foreign key (id_venta) references Venta(id_venta),
    foreign key (id_producto) references Producto(id_producto)
    
);

create table Compra(
	id_compra int primary key auto_increment,
    fecha date not null,
    total decimal(10,2) not null,
    id_proveedor int,
    id_usuario int,
    foreign key (id_proveedor) references Proveedor(id_proveedor),
    foreign key (id_usuario) references Usuario(id_usuario)
);

create table DetalleCompra(
	id_detalle_compra int primary key auto_increment,
    cantidad int,
    precio_unitario decimal(10,2) not null,
    subtotal decimal(10,2) not null,
    id_compra int,
    id_producto int,
    foreign key (id_producto) references Producto(id_producto),
    foreign key (id_compra) references Compra(id_compra)
);


CREATE TABLE Auditoria_Inventario (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_inventario INT,
    id_producto INT,
    accion VARCHAR(50),  -- Ejemplos: 'AJUSTE', 'VENTA', 'COMPRA'
    cantidad_cambio INT,  -- Cantidad que se sumó o restó
    stock_antes INT,
    stock_despues INT,
    fecha DATETIME NOT NULL,
    id_usuario INT,
    comentario TEXT,  -- Opcional: detalles adicionales del cambio
    FOREIGN KEY (id_inventario) REFERENCES Inventario(id_inventario),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Auditoria_Ventas (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT,
    accion VARCHAR(50),  -- Ejemplos: 'ANULACIÓN', 'MODIFICACIÓN'
    fecha DATETIME NOT NULL,
    id_usuario INT,
    detalles_cambio TEXT,  -- Descripción de los cambios realizados
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Auditoria_Compras (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT,
    accion VARCHAR(50),  -- Ejemplos: 'DEVOLUCIÓN', 'MODIFICACIÓN'
    fecha DATETIME NOT NULL,
    id_usuario INT,
    detalles_cambio TEXT,  -- Descripción de los cambios realizados
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Auditoria_Productos (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    campo_modificado VARCHAR(50),  -- Ejemplos: 'PRECIO_VENTA', 'STOCK'
    valor_anterior TEXT,
    valor_nuevo TEXT,
    fecha DATETIME NOT NULL,
    id_usuario INT,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Auditoria_Usuarios (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    campo_modificado VARCHAR(50),  -- Ejemplos: 'NOMBRE', 'PUESTO', 'TELEFONO'
    valor_anterior TEXT,
    valor_nuevo TEXT,
    fecha DATETIME NOT NULL,
    id_admin INT,  -- Usuario que realizó el cambio
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_admin) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Auditoria_Accesos (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    fecha_acceso DATETIME NOT NULL,
    tipo_acceso VARCHAR(50),  -- Ejemplos: 'INICIO SESIÓN', 'CIERRE SESIÓN'
    ip_acceso VARCHAR(45),  -- Dirección IP desde la cual se accedió
    detalles TEXT,  -- Descripción adicional si es necesario
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);



INSERT INTO Producto (descripcion, precio_venta, precio_compra, stock, fecha_elaboracion, fecha_vencimiento) VALUES
('Paracetamol 500mg', 2.50, 1.00, 100, '2024-01-01', '2025-01-01'),
('Ibuprofeno 400mg', 3.00, 1.20, 50, '2024-02-15', '2025-02-15'),
('Jarabe para la tos', 5.00, 2.50, 30, '2024-03-10', '2025-03-10'),
('Vitaminas C 1000mg', 8.00, 3.50, 20, '2024-04-05', '2025-04-05'),
('Amoxicilina 500mg', 4.50, 2.00, 60, '2024-05-20', '2025-05-20');
