CREATE SCHEMA proyecto_final;
USE proyecto_final;

############################################################################# TABLAS ################################################################################

CREATE TABLE CLIENTES (
    ID_CLIENTE INT PRIMARY KEY AUTO_INCREMENT,
    NOMBRE VARCHAR(50) NOT NULL,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DEPARTAMENTOS (
    ID_DEPARTAMENTO INT PRIMARY KEY AUTO_INCREMENT,
    NOMBRE VARCHAR(30) NOT NULL
);

CREATE TABLE PUESTOS (
    ID_PUESTO INT PRIMARY KEY AUTO_INCREMENT,
    ID_DEPARTAMENTO INT,
    NOMBRE VARCHAR(30) NOT NULL,
    DESCRIPCION VARCHAR(50),
    FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTOS(ID_DEPARTAMENTO)
);

CREATE TABLE CAMPANIAS (
    ID_CAMPANIA INT PRIMARY KEY AUTO_INCREMENT,
    ID_CLIENTE INT,
    NOMBRE VARCHAR(50) NOT NULL,
    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES(ID_CLIENTE)
);

CREATE TABLE EMPLEADOS (
    LEGAJO INT PRIMARY KEY,
    ID_DEPARTAMENTO INT,
    ID_PUESTO INT,
    ID_CAMPANIA INT,
    NOMBRE VARCHAR(30) NOT NULL,
    APELLIDO VARCHAR(30) NOT NULL,
    EMAIL VARCHAR(40) UNIQUE,
    USUARIO VARCHAR(15) UNIQUE,
    PASS VARCHAR(65),
    FECHA_INGRESO DATETIME DEFAULT CURRENT_TIMESTAMP,
    FECHA_EGRESO DATETIME,
    MOTIVO_EGRESO VARCHAR(60),
    FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTOS(ID_DEPARTAMENTO),
    FOREIGN KEY (ID_PUESTO) REFERENCES PUESTOS(ID_PUESTO),
    FOREIGN KEY (ID_CAMPANIA) REFERENCES CAMPANIAS(ID_CAMPANIA)
);

CREATE TABLE ASIGNACION_EMPLEADOS_CAMPANIAS (
    ID_ASIGNACION INT PRIMARY KEY AUTO_INCREMENT,
    LEGAJO INT,
    ID_CAMPANIA INT,
    FOREIGN KEY (LEGAJO) REFERENCES EMPLEADOS(LEGAJO),
    FOREIGN KEY (ID_CAMPANIA) REFERENCES CAMPANIAS(ID_CAMPANIA)
);

CREATE TABLE EVENTOS (
    ID_EVENTO INT PRIMARY KEY AUTO_INCREMENT,
    NOMBRE VARCHAR(50) NOT NULL UNIQUE,
    TIPO_EVENTO VARCHAR(20) NOT NULL
);

CREATE TABLE VENTAS (
    ID_VENTA INT PRIMARY KEY AUTO_INCREMENT,
    ID_CAMPANIA INT,
    LEGAJO INT,
    FECHA DATETIME,
    FOREIGN KEY (ID_CAMPANIA) REFERENCES CAMPANIAS(ID_CAMPANIA),
    FOREIGN KEY (LEGAJO) REFERENCES EMPLEADOS(LEGAJO)
);

CREATE TABLE auditoria(
	id_log INT PRIMARY KEY AUTO_INCREMENT,
    entity VARCHAR(100),
    entity_id INT,
    insert_dt DATETIME,
    created_by VARCHAR(100),
    last_update_dt DATETIME,
    last_updated_by VARCHAR(100)
);


############################################################################# INSERTS ################################################################################

INSERT INTO CLIENTES (ID_CLIENTE, NOMBRE,CREATED_AT) VALUES
    (null, 'Galicia', '2019-01-01'),
    (null, 'Santander', '2020-06-24'),
    (null, 'BBVA', '2019-02-01'),
    (null, 'Sabadell', '2022-10-10'),
    (null, 'Bankia', '2022-06-04');
    

INSERT INTO campanias (ID_CAMPANIA, ID_CLIENTE, NOMBRE) VALUES
    (null, 1, 'Ventas seguros'),
    (null, 2, 'Ventas tarjetas'),
    (null, 1, 'Ventas prestamos'),
    (null, 3, 'Ventas seguros'),
    (null, 4, 'Fidelizacion');

INSERT INTO DEPARTAMENTOS (ID_DEPARTAMENTO, NOMBRE) VALUES
    (null, 'Supervicion'),
    (null, 'Ventas'),
    (null, 'Calidad'),
    (null, 'Sistemas'),
    (null, 'Administracion');

INSERT INTO PUESTOS (ID_PUESTO, ID_DEPARTAMENTO, NOMBRE, DESCRIPCION) VALUES
    (null, 2, 'Ejecutivo de ventas', 'Ejecutivo de ventas'),
    (null, 1, 'Supervisor', 'Supervisor de ventas'),
    (null, 3, 'Analista de calidad', 'Analista de calidad'),
    (null, 4, 'Soporte tecnico', 'Analista de soporte tecnico'),
    (null, 4, 'Programador', 'Programador');

INSERT INTO empleados (LEGAJO, ID_DEPARTAMENTO, ID_PUESTO, ID_CAMPANIA, NOMBRE, APELLIDO, EMAIL, USUARIO, PASS, FECHA_INGRESO, FECHA_EGRESO, MOTIVO_EGRESO) VALUES
    (23201, 2, 1, 1, 'Juan', 'Perez', 'jperez@gmail.com', 'jperez', 'pass123', '2023-02-15', null, null),
    (23305, 1, 1, 1, 'Pedro', 'Gomez', 'pgomez@gmail.com', 'pgomez', 'contrasenia15', '2023-08-01', null, null),
    (23145, 3, 1, 1, 'Maria', 'Garcia', 'mgarcia@hotmail.com', 'mgarcia', 'claveRara', '2023-01-15', null, null),
    (24001, 2, 1, 1, 'Jose', 'Rodriguez', 'jrodriguez@yahoo.com.ar', 'jrodriguez', 'clave27!', '2023-10-05', null, null),
    (21018, 4, 1, 1, 'Lucia', 'Fernandez', 'lfernandez@hotmail.com', 'lfernandez', 'agosto2021', '2021-04-02', '2021-08-02', 'Renuncia');

INSERT INTO ASIGNACION_EMPLEADOS_CAMPANIAS (ID_ASIGNACION, LEGAJO, ID_CAMPANIA) VALUES
    (null, 23201, 2),
    (null, 23305, 1),
    (null, 23145, 3),
    (null, 24001, 4),
    (null, 21018, 5);

INSERT INTO EVENTOS (ID_EVENTO, NOMBRE, TIPO_EVENTO) VALUES
    (null, 'Venta', 'Contacto positivo'),
    (null, 'Volver a llamar', 'Contacto positivo'),
    (null, 'Equivocado', 'Contacto no util'),
    (null, 'No contesta', 'Contacto no util'),
    (null, 'No le interesa', 'Contacto no util');

INSERT INTO VENTAS (ID_VENTA, ID_CAMPANIA, LEGAJO, FECHA) VALUES
    (null, 1, 23305, '2023-10-01'),
    (null, 1, 23305, '2023-10-06'),
    (null, 2, 23201, '2023-10-04'),
    (null, 4, 24001, '2023-10-11'),
    (null, 3, 23145, '2023-10-21');
    
############################################################################# VISTAS ################################################################################

CREATE VIEW ventas_empleados AS
	(SELECT V.LEGAJO, E.NOMBRE, E.APELLIDO, E.USUARIO, COUNT(V.ID_VENTA) AS cant_ventas
	FROM VENTAS V
	INNER JOIN EMPLEADOS E
	ON V.LEGAJO = E.LEGAJO
	GROUP BY V.LEGAJO
	ORDER BY cant_ventas
	DESC);
		
CREATE VIEW asignacion_campanias AS
	(SELECT A.ID_ASIGNACION, CL.NOMBRE AS cliente, E.LEGAJO, E.NOMBRE, E.APELLIDO, E.EMAIL, C.NOMBRE AS campania
	FROM ASIGNACION_EMPLEADOS_CAMPANIAS A
	INNER JOIN EMPLEADOS E
	ON A.LEGAJO = E.LEGAJO
	INNER JOIN CAMPANIAS C
	ON A.ID_CAMPANIA = C.ID_CAMPANIA
	INNER JOIN CLIENTES CL
	ON CL.ID_CLIENTE = C.ID_CLIENTE
	ORDER BY cliente, E.LEGAJO);
    
CREATE VIEW empleados_activos AS
	(SELECT LEGAJO, NOMBRE, APELLIDO, EMAIL, USUARIO
    FROM EMPLEADOS
    WHERE FECHA_EGRESO IS NULL);

CREATE VIEW empleados_por_departamento AS
	(SELECT COUNT(E.LEGAJO) AS cant_empleados, D.NOMBRE AS departamento
    FROM EMPLEADOS E
    INNER JOIN DEPARTAMENTOS D
    ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO
    GROUP BY D.ID_DEPARTAMENTO
    ORDER BY cant_empleados DESC);

CREATE VIEW campanias_por_clientes AS
	(SELECT COUNT(C.ID_CLIENTE) AS cant_campanias, CL.NOMBRE AS cliente
    FROM CLIENTES CL
    INNER JOIN CAMPANIAS C
    ON C.ID_CLIENTE = CL.ID_CLIENTE
    GROUP BY CL.NOMBRE);
    
############################################################################# FUNCIONES ################################################################################

DELIMITER $$
CREATE FUNCTION obtener_empleados_en_departamento(id_departamento INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE resultado VARCHAR(100);

    SELECT GROUP_CONCAT(CONCAT(E.LEGAJO, ' - ', E.NOMBRE, ' ', E.APELLIDO, ' (', E.EMAIL, ')') SEPARATOR '\n')
    INTO resultado
    FROM EMPLEADOS E
    WHERE E.ID_DEPARTAMENTO = id_departamento;

    RETURN resultado;
END $$

SELECT obtener_empleados_en_departamento(2) AS empleados_por_departamento;


DELIMITER $$
CREATE FUNCTION ventas_por_empleado(legajo INT)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE cantidadVentas INT DEFAULT 0;
    
	SELECT IFNULL(COUNT(*), 0) INTO cantidadVentas
	FROM VENTAS
	WHERE LEGAJO = legajo;

	RETURN cantidadVentas;
END;
$$

SELECT ventas_por_empleado(23145);

############################################################################# STORED PROCEDURES ################################################################################

DELIMITER $$
CREATE PROCEDURE ordenar_tabla (IN tabla VARCHAR(50), IN campo VARCHAR (50), IN orden VARCHAR(4)) # Se elige que tabla se va a ordenar, por que campo y si va a ser ASC o DESC
BEGIN
	SET @sql = CONCAT(
	'SELECT * FROM ', tabla,
    ' ORDER BY ', campo, ' ',
    orden);
    PREPARE runSQL FROM @sql;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END
$$

CALL ordenar_tabla ('campanias', 'nombre', 'ASC'); # Ejemplo

DELIMITER $$
CREATE PROCEDURE eliminar_venta (IN id_venta INT)  # Pasamos el id de la venta a eliminar
BEGIN
	SET @sql = CONCAT(
    'DELETE FROM ventas WHERE id_venta = ', id_venta);
    PREPARE runSQL FROM @sql;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END
$$

INSERT INTO VENTAS (ID_VENTA, ID_CAMPANIA, LEGAJO, FECHA) VALUES 
(6, 3, 23145, '2023-10-21'); # Hago el insert para la prueba

CALL eliminar_venta(6); # Elimino el registro

############################################################################# TRIGGERS  ################################################################################

# Al eliminar un cliente, se guarda un registro del id_cliente, cuando se elimino y quien realizo la accion.

CREATE TRIGGER tr_delete_clientes_aud
AFTER DELETE ON clientes
FOR EACH ROW
INSERT INTO auditoria(entity, entity_id, delete_dt, deleted_by)
VALUES('clientes', OLD.ID_CLIENTE, CURRENT_TIMESTAMP(), USER());

# Para evitar que se carguen ventas manualmente con una fecha futura, se setea la fecha de venta como current_date antes de la insercion.
DELIMITER $$
CREATE TRIGGER tr_check_venta_before_insert
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
	IF NEW.FECHA > CURRENT_DATE() THEN
		SET NEW.FECHA = CURRENT_DATE();
	END IF;
END
$$

############################################################################# INFORMES ################################################################################

SELECT C.ID_CAMPANIA, C.NOMBRE AS nombre_campania, CL.NOMBRE AS nombre_cliente, COUNT(V.ID_VENTA) AS total_ventas
FROM CAMPANIAS C
LEFT JOIN VENTAS V ON C.ID_CAMPANIA = V.ID_CAMPANIA
LEFT JOIN CLIENTES CL ON C.ID_CLIENTE = CL.ID_CLIENTE
GROUP BY C.ID_CAMPANIA
ORDER BY nombre_cliente, nombre_campania;