
CREATE TABLE persona (
    ci INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    nombre VARCHAR(100) NOT NULL,
    paterno VARCHAR(100) NOT NULL,
    materno VARCHAR(100) NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')) NOT NULL, 
    celular VARCHAR(20),
    direccion VARCHAR(255),
    fechanaci DATE
);

CREATE TABLE cliente (
    ci_cliente INT NOT NULL,  -- Cambio a INT en lugar de SERIAL
    fechainicio DATE NOT NULL, 
    CONSTRAINT pk_cliente PRIMARY KEY (ci_cliente),
    CONSTRAINT fk_cliente_persona FOREIGN KEY (ci_cliente) REFERENCES persona(ci) ON DELETE CASCADE
);

CREATE TABLE administrador (
    ci_administrador INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    salario DECIMAL(10, 2) NOT NULL CHECK (salario >= 0), 
    CONSTRAINT fk_administrador_persona FOREIGN KEY (ci_administrador) 
        REFERENCES persona(ci) ON DELETE CASCADE
);

CREATE TABLE repartidor (
    ci_repartidor INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    nrolicencia VARCHAR(50) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL CHECK (salario >= 0), 
    CONSTRAINT fk_repartidor_persona FOREIGN KEY (ci_repartidor) REFERENCES persona(ci) ON DELETE CASCADE
);


CREATE TABLE proveedor (
    ci_proveedor INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    CONSTRAINT fk_proveedor_persona FOREIGN KEY (ci_proveedor) REFERENCES persona(ci) ON DELETE CASCADE
);

CREATE TABLE camion (
    placa VARCHAR(10) PRIMARY KEY, 
    anio INT NOT NULL CHECK (anio > 0),
    marca VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    ci_repartidor INT NOT NULL,
    CONSTRAINT fk_camion_repartidor FOREIGN KEY (ci_repartidor) REFERENCES repartidor(ci_repartidor) ON DELETE CASCADE
);

CREATE TABLE incidencia (
    id_incidencia INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    descripcion TEXT NOT NULL, 
    fecha DATE NOT NULL, 
    ci_repartidor INT NOT NULL,
    CONSTRAINT fk_incidencia_repartidor FOREIGN KEY (ci_repartidor) REFERENCES repartidor(ci_repartidor) ON DELETE CASCADE
);

CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    fecha_p DATE NOT NULL, 
    ci_cliente INT NOT NULL, 
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (ci_cliente) REFERENCES cliente(ci_cliente) ON DELETE CASCADE
);


CREATE TABLE se_le_asigna (
    ci_repartidor INT NOT NULL, 
    id_pedido INT NOT NULL, 
    CONSTRAINT pk_se_le_asigna PRIMARY KEY (ci_repartidor, id_pedido),
    CONSTRAINT fk_se_le_asigna_repartidor FOREIGN KEY (ci_repartidor) REFERENCES repartidor(ci_repartidor) ON DELETE CASCADE,
    CONSTRAINT fk_se_le_asigna_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

CREATE TABLE producto (
    id_producto INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    tamanio VARCHAR(50) NOT NULL
);


CREATE TABLE detalle_p (
    id_pedido INT NOT NULL, 
    id_producto INT NOT NULL, 
    cantidad INT NOT NULL CHECK (cantidad > 0), 
    p_unitario DECIMAL(10, 2) NOT NULL CHECK (p_unitario >= 0),
    descuentoP DECIMAL(5, 2) DEFAULT 0 CHECK (descuentoP >= 0), 
    CONSTRAINT pk_detalle_p PRIMARY KEY (id_pedido, id_producto),
    CONSTRAINT fk_detalle_p_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE, 
    CONSTRAINT fk_detalle_p_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);


CREATE TABLE tienda (
    id_tienda INT PRIMARY KEY,  -- Cambio a INT en lugar de SERIAL
    direccion VARCHAR(255) NOT NULL,
    ci_cliente INT NOT NULL, 
    CONSTRAINT fk_tienda_cliente FOREIGN KEY (ci_cliente) REFERENCES cliente(ci_cliente) ON DELETE CASCADE
);


CREATE TABLE compra (
    id_compra INT NOT NULL,
    ci_administrador INT NOT NULL, 
    ci_proveedor INT NOT NULL, 
    id_producto INT NOT NULL, 
    fechaCompra DATE NOT NULL, 
    fechaLlegada DATE NOT NULL, 
    cantidad INT NOT NULL CHECK (cantidad > 0),
    p_unitario DECIMAL(10, 2) NOT NULL CHECK (p_unitario >= 0), 
    CONSTRAINT pk_compra PRIMARY KEY (id_compra),
    CONSTRAINT fk_compra_administrador FOREIGN KEY (ci_administrador) REFERENCES administrador(ci_administrador) ON DELETE CASCADE,
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (ci_proveedor) REFERENCES proveedor(ci_proveedor) ON DELETE CASCADE,
    CONSTRAINT fk_compra_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);
-- Insertar datos en la tabla persona (20 registros)
INSERT INTO persona (ci, nombre, paterno, materno, sexo, celular, direccion, fechanaci) VALUES
(12345678, 'Juan', 'Perez', 'Gonzalez', 'M', '123456789', 'Av. Siempre Viva 123', '1985-03-15'),
(87654321, 'Ana', 'Lopez', 'Martínez', 'F', '987654321', 'Calle Falsa 456', '1990-07-25'),
(11223344, 'Carlos', 'Sanchez', 'Ramírez', 'M', '555123456', 'Boulevard Libertad 789', '1982-11-10'),
(22334455, 'Lucía', 'Gonzalez', 'Serrano', 'F', '222333444', 'Calle Nueva 12', '1992-05-20'),
(33445566, 'Pedro', 'Martínez', 'Alvarez', 'M', '333444555', 'Av. Los Alamos 34', '1988-06-10'),
(44556677, 'Marta', 'Ramírez', 'Gutierrez', 'F', '444555666', 'Calle Sol 56', '1995-08-15'),
(55667788, 'Jose', 'Morales', 'Fernandez', 'M', '555666777', 'Calle Luna 89', '1980-12-05'),
(66778899, 'Isabel', 'Fernandez', 'Mendoza', 'F', '666777888', 'Avenida Central 21', '1991-04-25'),
(77889900, 'Luis', 'Hernandez', 'Ortiz', 'M', '777888999', 'Calle Azul 42', '1984-09-18'),
(88990011, 'Elena', 'García', 'Vega', 'F', '888999000', 'Avenida Los Pinos 77', '1993-10-30'),
(99001122, 'Ricardo', 'Torres', 'Castro', 'M', '999000111', 'Av. La Paz 63', '1992-01-12'),
(10011001, 'Victoria', 'Díaz', 'Moreno', 'F', '101010101', 'Calle Estrella 45', '1989-02-09'),
(11122334, 'Miguel', 'Jimenez', 'Rivera', 'M', '111223344', 'Calle Principal 65', '1990-07-14'),
(12233445, 'Raquel', 'Cruz', 'Muñoz', 'F', '121212121', 'Avenida Libertad 24', '1983-11-11'),
(13344556, 'Fernando', 'Vazquez', 'García', 'M', '131313131', 'Av. La Esperanza 39', '1994-04-23'),
(14455667, 'Laura', 'Reyes', 'Salazar', 'F', '141414141', 'Calle Vista 59', '1986-06-17'),
(15566778, 'Andres', 'Gomez', 'Perez', 'M', '151515151', 'Avenida Mexico 80', '1987-08-03'),
(16677889, 'Susana', 'Alvarez', 'Torres', 'F', '161616161', 'Calle del Sol 29', '1994-09-28'),
(17788990, 'Raul', 'Ruiz', 'Serrano', 'M', '171717171', 'Av. Las Palmas 18', '1981-12-25');

-- Insertar datos en la tabla cliente (5 registros)
INSERT INTO cliente (ci_cliente, fechainicio) VALUES
(12345678, '2020-01-01'),
(87654321, '2021-02-15'),
(22334455, '2022-03-10'),
(33445566, '2023-06-25'),
(44556677, '2023-08-05');

-- Insertar datos en la tabla administrador (5 registros)
INSERT INTO administrador (ci_administrador, salario) VALUES
(11223344, 2500.00),
(22334455, 3000.00),
(33445566, 2700.00),
(44556677, 2200.00),
(55667788, 3500.00);

-- Insertar datos en la tabla repartidor (5 registros)
INSERT INTO repartidor (ci_repartidor, nrolicencia, salario) VALUES
(12345678, 'ABC123', 1500.00),
(87654321, 'XYZ789', 1600.00),
(22334455, 'DEF456', 1400.00),
(33445566, 'GHI789', 1450.00),
(44556677, 'JKL101', 1550.00);

-- Insertar datos en la tabla proveedor (5 registros)
INSERT INTO proveedor (ci_proveedor, correo, telefono) VALUES
(11223344, 'proveedor1@example.com', '123456789'),
(22334455, 'proveedor2@example.com', '987654321'),
(33445566, 'proveedor3@example.com', '555123456'),
(44556677, 'proveedor4@example.com', '666789012'),
(55667788, 'proveedor5@example.com', '777345678');

-- Insertar datos en la tabla camion (5 registros)
INSERT INTO camion (placa, anio, marca, color, ci_repartidor) VALUES
('ABC1234', 2015, 'Toyota', 'Rojo', 12345678),
('XYZ5678', 2018, 'Ford', 'Azul', 87654321),
('DEF9012', 2020, 'Chevrolet', 'Blanco', 22334455),
('GHI3456', 2019, 'Nissan', 'Negro', 33445566),
('JKL7890', 2021, 'Honda', 'Verde', 44556677);

-- Insertar datos en la tabla incidencia (5 registros)
INSERT INTO incidencia (id_incidencia, descripcion, fecha, ci_repartidor) VALUES
(1, 'Accidente en la ruta', '2024-03-10', 12345678),
(2, 'Retraso por mal tiempo', '2024-03-12', 87654321),
(3, 'Falta de combustible', '2024-03-15', 22334455),
(4, 'Problema en el vehículo', '2024-03-18', 33445566),
(5, 'Accidente menor', '2024-03-20', 44556677);

-- Insertar datos en la tabla pedido (5 registros)
INSERT INTO pedido (id_pedido, fecha_p, ci_cliente) VALUES
(1, '2024-05-01', 12345678),
(2, '2024-05-03', 87654321),
(3, '2024-05-05', 22334455),
(4, '2024-05-07', 33445566),
(5, '2024-05-09', 44556677);

-- Insertar datos en la tabla se_le_asigna (5 registros)
INSERT INTO se_le_asigna (ci_repartidor, id_pedido) VALUES
(12345678, 1),
(87654321, 2),
(22334455, 3),
(33445566, 4),
(44556677, 5);

-- Insertar datos en la tabla producto (5 registros)
INSERT INTO producto (id_producto, tamanio) VALUES
(1, 'Pequeño'),
(2, 'Mediano'),
(3, 'Grande'),
(4, 'Extra Grande'),
(5, 'Familiar');

-- Insertar datos en la tabla detalle_p (5 registros)
INSERT INTO detalle_p (id_pedido, id_producto, cantidad, p_unitario, descuentoP) VALUES
(1, 1, 2, 10.00, 5.00),
(2, 2, 1, 15.00, 10.00),
(3, 3, 3, 12.00, 0.00),
(4, 4, 2, 20.00, 5.00),
(5, 5, 1, 25.00, 10.00);

-- Insertar datos en la tabla tienda (5 registros)
INSERT INTO tienda (id_tienda, direccion, ci_cliente) VALUES
(1, 'Av. Central 100', 12345678),
(2, 'Calle Falsa 200', 87654321),
(3, 'Avenida Libertad 300', 22334455),
(4, 'Calle Sol 400', 33445566),
(5, 'Boulevard 500', 44556677);

-- Insertar datos en la tabla compra (5 registros)
INSERT INTO compra (id_compra,ci_administrador, ci_proveedor, id_producto, fechaCompra, fechaLlegada, cantidad, p_unitario) VALUES
(1001,11223344, 11223344, 1, '2024-01-10', '2024-01-15', 100, 25.50),
(1002,22334455, 22334455, 2, '2024-02-15', '2024-02-18', 50, 30.75),
(1003,33445566, 33445566, 3, '2024-03-05', '2024-03-08', 200, 20.00),
(1004,44556677, 44556677, 4, '2024-04-01', '2024-04-04', 75, 15.80),
(1005,55667788, 55667788, 5, '2024-05-20', '2024-05-22', 150, 22.50);


CREATE OR REPLACE FUNCTION cliente_antiguedad(xci_cliente INTEGER)
RETURNS INT AS $$
DECLARE
  fecha_inicio DATE;
  anios INT;
BEGIN
  anios := 0;
  SELECT FECHAINICIO INTO fecha_inicio
  FROM CLIENTE
  WHERE CI_CLIENTE = xci_cliente; 
  IF NOT FOUND THEN
    RETURN 0;
  END IF;
  SELECT EXTRACT(YEAR FROM AGE(fecha_inicio)) INTO anios;
  RETURN anios;
EXCEPTION WHEN OTHERS THEN
  RETURN 0;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION numitiendas(cix INTEGER) 
RETURNS INTEGER
AS
$$
DECLARE
    total INTEGER;  
BEGIN
    select count(*) into total
	from cliente
	join tienda on tienda.ci_cliente=cliente.ci_cliente
	where cliente.ci_cliente=cix;
    
    RETURN total;  
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION numpedidos(cix INTEGER) 
RETURNS INTEGER
AS
$$
DECLARE
    total INTEGER;  
BEGIN
    SELECT count(*) into total
	FROM CLIENTE c
	JOIN PEDIDO p on p.ci_cliente=c.ci_cliente
	where c.ci_cliente=cix;
    
    RETURN total;  
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION maxpedidos() 
RETURNS INTEGER
AS
$$
DECLARE
    total INTEGER;  
BEGIN
    select max(cantidad) into total
	from detalle_p;
    
    RETURN total;  
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION  proveedorx (cix integer)
RETURNS VARCHAR(50)
AS
$$
DECLARE
    proveedorx varchar(50); 
    mayor integer; 
BEGIN
    -- Obtener el id_producto que más veces ha sido pedido
    SELECT dp.id_producto INTO mayor
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    WHERE p.ci_cliente = cix
    GROUP BY dp.id_producto
    ORDER BY COUNT(dp.id_producto) DESC
    LIMIT 1; 

    select concat(persona.nombre,' ',persona.paterno,' ',persona.materno) into proveedorx
	from proveedor p
	join persona on persona.ci=p.ci_proveedor
	join compra c on c.ci_proveedor=p.ci_proveedor
	where c.id_producto=1
	limit 1;
   
    RETURN proveedorx;
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION numerorepartidores(cix INTEGER) 
RETURNS INTEGER
AS
$$
DECLARE
    suma INTEGER; 
    total INTEGER;
BEGIN
    SELECT count(DISTINCT se.ci_repartidor) INTO total
    FROM cliente c
    JOIN pedido p ON p.ci_cliente = c.ci_cliente
    JOIN se_le_asigna se ON se.id_pedido = p.id_pedido
    WHERE c.ci_cliente = cix;

    IF total IS NOT NULL AND total > 0 THEN
        RETURN total;
    ELSE
        RETURN 0; 
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION mediadescuentos(cix INTEGER) 
RETURNS INTEGER
AS
$$
DECLARE
    suma INTEGER; 
    total INTEGER;
BEGIN
    -- Sumar los descuentos para el cliente dado
    SELECT sum(dp.descuentoP) INTO suma
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    JOIN cliente c ON c.ci_cliente = p.ci_cliente
    WHERE c.ci_cliente = cix;

    -- Contar el número de pedidos para el cliente dado
    SELECT count(*) INTO total
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    JOIN cliente c ON c.ci_cliente = p.ci_cliente
    WHERE c.ci_cliente = cix;

    -- Verificar que total no sea 0 para evitar división por cero
    IF total > 0 THEN
        RETURN suma / total;
    ELSE
        RETURN 0; -- Puedes devolver otro valor o manejar el caso de otra manera si es necesario
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION numpedidos(cix INTEGER) 
RETURNS INTEGER
AS
$$
DECLARE
    total INTEGER;  
BEGIN
    SELECT count(*) into total
    FROM CLIENTE c
    JOIN PEDIDO p on p.ci_cliente=c.ci_cliente
    where c.ci_cliente=cix;
    
    RETURN total;  
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calcular_edad(fecha_nacimiento DATE)
RETURNS INTEGER AS
$$
DECLARE
    edad INTEGER;
BEGIN

    SELECT EXTRACT(YEAR FROM AGE(fecha_nacimiento)) INTO edad;
    
    RETURN edad;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION productomaspedido(cix integer)
RETURNS VARCHAR(20)
AS
$$
DECLARE
    producto varchar(20); 
    mayor integer; 
BEGIN
    -- Obtener el id_producto que más veces ha sido pedido
    SELECT dp.id_producto INTO mayor
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    WHERE p.ci_cliente = cix
    GROUP BY dp.id_producto
    ORDER BY COUNT(dp.id_producto) DESC
    LIMIT 1; 

    SELECT prod.tamanio INTO producto
    FROM producto prod
    WHERE prod.id_producto = mayor;

   
    RETURN producto;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION numitiendas(cix INTEGER) 
RETURNS INTEGER
AS
$$
DECLARE
    total INTEGER;  
BEGIN
    select count(*) into total
    from cliente
    join tienda on tienda.ci_cliente=cliente.ci_cliente
    where cliente.ci_cliente=cix;
    
    RETURN total;  
END;
$$ LANGUAGE plpgsql;



