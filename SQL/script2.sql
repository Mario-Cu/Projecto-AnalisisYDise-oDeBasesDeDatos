------------------BORRADO DE TABLAS EXISTENTES------------------------
DROP TABLE IF EXISTS RELACION;
DROP TABLE IF EXISTS ACCESO;
DROP TABLE IF EXISTS TUBULAR;
DROP TABLE IF EXISTS PLANMANTENIMIENTO;
DROP TABLE IF EXISTS GALERIASERVICIOS;
DROP TABLE IF EXISTS CONDUCCION_ELECTRICA;
DROP TABLE IF EXISTS DISTANCIA;
DROP TABLE IF EXISTS MULTA;
DROP TABLE IF EXISTS INSPECCION;
DROP TABLE IF EXISTS DEPOSITO;
DROP TABLE IF EXISTS CONDUCCION;
DROP TABLE IF EXISTS MEDIO;
DROP TABLE IF EXISTS OBRA_CONDUCCION;
DROP TABLE IF EXISTS OBRA_MEDIO;
DROP TABLE IF EXISTS OBRA;
DROP TABLE IF EXISTS PROYECTO;
DROP TABLE IF EXISTS PLAN;
DROP TABLE IF EXISTS INSTALACION;
DROP TABLE IF EXISTS LICENCIA_DECONEXION;
DROP TABLE IF EXISTS LICENCIA_DEOBRA;
DROP TABLE IF EXISTS LICENCIA_DEOCUPACION;
DROP TABLE IF EXISTS LICENCIA;


------------------CREACION DE TABLAS --------------------------

CREATE TABLE LICENCIA
(
    idLicencia integer NOT NULL,
    tipoLicencia varchar NOT NULL,
    claseLicencia varchar NOT NULL,
    titular varchar NOT NULL,
    tributosPublicos float NOT NULL,
    extinguida bit NOT NULL,
    PRIMARY KEY (idLicencia)
);


CREATE TABLE LICENCIA_DEOCUPACION
(
    idLicenciaOcupacion integer NOT NULL,
    caracter varchar NOT NULL,
    dominioComprendido varchar NOT NULL,
    emplazamiento varchar NOT NULL,
    dimensiones varchar NOT NULL,
    otras text,
    rutaCroquisSituacion varchar NOT NULL,
    porcionVia varchar NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion),
    FOREIGN KEY (idLicenciaOcupacion)
        REFERENCES LICENCIA
        ON DELETE CASCADE
);

CREATE TABLE LICENCIA_DEOBRA
(
    idLicenciaObra integer NOT NULL,
    claseLicenciaObras varchar NOT NULL,
    plazoInic Date NOT NULL,
    plazoFin Date NOT NULL,
    porcionVia varchar NOT NULL,
    acondicionamientoParaCoordinacion varchar,
    condicionesEspeciales varchar,
    tipoCala varchar,
    condicionesEjecucion text NOT NULL,
    horariosDeTrabajo varchar NOT NULL,
    modalidadesDeTrabajo varchar NOT NULL,
    PRIMARY KEY (idLicenciaObra),
    FOREIGN KEY (idLicenciaObra)
        REFERENCES LICENCIA
        ON DELETE CASCADE,
    CONSTRAINT fechasInconsistentes CHECK (plazoInic < plazoFin),
    CONSTRAINT fechasInicPreviaAFechaActual CHECK (plazoInic >= CURRENT_TIMESTAMP)
);

CREATE TABLE LICENCIA_DECONEXION
(
    idLicencia integer NOT NULL,
    claseConexion varchar NOT NULL,
    tipoCanalizacion varchar NOT NULL,
    emplazamiento varchar NOT NULL,
    dimensiones varchar NOT NULL,
    otras text,
    rutaCroquisSituacion varchar NOT NULL,
    rutaPlanoObra varchar NOT NULL,
    clasePavim varchar NOT NULL,
    superfPavim varchar NOT NULL,
    PRIMARY KEY (idLicencia),
    FOREIGN KEY (idLicencia)
        REFERENCES LICENCIA_DEOBRA
        ON DELETE CASCADE
);


CREATE TABLE INSTALACION
(
    idCodConducciones varchar  NOT NULL,
    titular varchar  NOT NULL,
    estadoEjecucion varchar  NOT NULL,
    PRIMARY KEY (idCodConducciones)
);

CREATE TABLE PLAN(
    cifEmpresaExplotadora varchar NOT NULL,
    estimacionNecesidades text,
    ubicacionCentroProductor varchar NOT NULL,
    ubicacionCentroDistribuidor varchar NOT NULL,
    lineaGeneralTransporte varchar NOT NULL,
    lineaGeneralDistribucion varchar NOT NULL,
    PRIMARY KEY (cifEmpresaExplotadora)
);

CREATE TABLE PROYECTO(
    idLicenciaObra integer NOT NULL,
    fechaSolicitud Date NOT NULL,
    cifEmpresaExplotadora varchar NOT NULL,
    motivoObra varchar NOT NULL,
    instalacionesDeObra varchar NOT NULL,
    modalidadDeObra varchar NOT NULL,
    expresionFinalidad varchar NOT NULL,
    emplazamientoObra varchar NOT NULL,
    dimensionesObra varchar NOT NULL,
    caracteristicasObra text,
    rutaPlanoDetallado varchar NOT NULL,
    restriccionCirculacion bit NOT NULL,
    materialesAEmplear text NOT NULL,
    equiposTrabajo varchar NOT NULL,
    maquinariaAEmplear text NOT NULL,
    fechaFinPrevisibleObra Date NOT NULL,
    calendarioEjecucion text NOT NULL,
    presupuesto float NOT NULL,

    PRIMARY KEY (idLicenciaObra, fechaSolicitud),
    FOREIGN KEY (idLicenciaObra) 
        REFERENCES LICENCIA_DEOBRA (idLicenciaObra)
        ON DELETE CASCADE, 
    FOREIGN KEY (cifEmpresaExplotadora) 
        REFERENCES PLAN (cifEmpresaExplotadora) 
        ON DELETE NO ACTION,
    CONSTRAINT fechasInconsistentes CHECK (fechaSolicitud < fechaFinPrevisibleObra),
    CONSTRAINT fechaSolicitudPreviaAFechaActual CHECK (fechaSolicitud >= CURRENT_TIMESTAMP),
    CONSTRAINT presupuestoNegativo CHECK (presupuesto >= 0)
);


CREATE TABLE OBRA
(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    fechaInic Date NOT NULL,
    fechaFin Date NOT NULL,
    tecnicoResponsable varchar NOT NULL,
    garantia Date NOT NULL,
    señalamientoFecha varchar NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra),
    FOREIGN KEY (idLicenciaOcupacion)
        REFERENCES LICENCIA_DEOCUPACION(idLicenciaOcupacion)
        ON DELETE CASCADE,
    FOREIGN KEY (idLicenciaObra)
        REFERENCES LICENCIA_DEOBRA(idLicenciaObra)
        ON DELETE CASCADE,
    CONSTRAINT fechasInconsistentes CHECK (fechaInic < fechaFin),
    CONSTRAINT fechasInicPreviaAFechaActual CHECK (fechaInic >= CURRENT_TIMESTAMP)
);

CREATE TABLE OBRA_CONDUCCION
(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    caracteristicas text,
    temporal bit NOT NULL,

    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA(idLicenciaOcupacion, idLicenciaObra)
        ON DELETE CASCADE
);


CREATE TABLE OBRA_MEDIO
(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    caracteristicas text,
    temporal bit NOT NULL,

    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA(idLicenciaOcupacion, idLicenciaObra)
        ON DELETE CASCADE
);


CREATE TABLE DEPOSITO(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    fechaCreacion Date NOT NULL,
    peticionario varchar NOT NULL,
    costeReposicion float NOT NULL,
    dañosYPerjuiciosOcasionados text NOT NULL,
    gastosPorDesviarTrafico float,
    plazoGarantia Date NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra, fechaCreacion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA(idLicenciaOcupacion, idLicenciaObra)
            ON DELETE CASCADE,
    CONSTRAINT fechasInconsistentes CHECK (plazoGarantia >= fechaCreacion),
    CONSTRAINT fechasCreacionPreviaAFechaActual CHECK (fechaCreacion >= CURRENT_TIMESTAMP),
    CONSTRAINT costeNegativo CHECK (costeReposicion >= 0)
);

CREATE TABLE INSPECCION(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    idInspeccion SERIAL NOT NULL,
    comprobacionEspacio bit NOT NULL,
    comprobacionTiempo bit NOT NULL,
    comprobacionConformidad bit NOT NULL,
    comprobacionConsInstalac bit NOT NULL,
    comprobacionFormaEjec bit NOT NULL,
    comprobacionReposicElem bit NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra, idInspeccion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA(idLicenciaOcupacion, idLicenciaObra)
          ON DELETE CASCADE
);


CREATE TABLE MULTA (
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    idInspeccion integer NOT NULL,
    idMulta SERIAL NOT NULL,
    tipoInfraccion varchar NOT NULL,
    importe float NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra, idInspeccion, idMulta),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra, idInspeccion)
        REFERENCES INSPECCION
            ON DELETE CASCADE
);



CREATE TABLE CONDUCCION
(
    ubicacion varchar  NOT NULL,
    iteracion SERIAL,
    dominioComprendido varchar  NOT NULL,
    enterrada bit NOT NULL,
    profundidadLibre float NOT NULL,
    tipo varchar  NOT NULL,
    profundidad float NOT NULL,
    proteccionEspecial bit NOT NULL,
    altura float NOT NULL,
    idLicenciaOcupacion integer,
    idLicenciaObra integer,
    PRIMARY KEY (ubicacion, iteracion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA_CONDUCCION(idLicenciaOcupacion, idLicenciaObra)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT profundidadLibreNeg CHECK (profundidadLibre >= 0),
    CONSTRAINT profundidadNeg CHECK (profundidad >= 0),
    CONSTRAINT alturaNeg CHECK (altura >= 0)

);

CREATE TABLE CONDUCCION_ELECTRICA
(
    ubicacion varchar  NOT NULL,
    iteracion integer,
    energiaTransportada float NOT NULL,
    PRIMARY KEY (ubicacion, iteracion),
    FOREIGN KEY (ubicacion, iteracion)
        REFERENCES CONDUCCION(ubicacion, iteracion)
         ON DELETE CASCADE,
    CONSTRAINT energNegativa CHECK (energiaTransportada >= 0)
);

CREATE TABLE DISTANCIA
(
    ubiConduccion1 varchar  NOT NULL,
    iteracion1 integer,
    ubiConduccion2 varchar NOT NULL,
    iteracion2 integer,
    distancia float NOT NULL,
    paralela bit NOT NULL,
    PRIMARY KEY (ubiConduccion1, ubiConduccion2, iteracion1, iteracion2),
    FOREIGN KEY(ubiConduccion1, iteracion1) 
        REFERENCES CONDUCCION
        ON DELETE CASCADE,
    FOREIGN KEY(ubiConduccion2, iteracion2)
        REFERENCES CONDUCCION
        ON DELETE CASCADE,
    CONSTRAINT distanciaNeg CHECK (distancia >= 0),
    CONSTRAINT distanciaParalelaInconsistente CHECK (distancia >= 0.8 AND paralela='1' OR paralela='0')
);


CREATE TABLE MEDIO
(
    ubicacion varchar  NOT NULL,
    iteracion SERIAL,
    tipo varchar  NOT NULL,
    idLicenciaOcupacion integer,
    idLicenciaObra integer,
    PRIMARY KEY (ubicacion, iteracion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA_MEDIO(idLicenciaOcupacion, idLicenciaObra)
        ON DELETE SET NULL
        ON UPDATE CASCADE

);

CREATE TABLE RELACION
(
    idInstalacion varchar  NOT NULL,
    ubiConduccion varchar NOT NULL,
    iteracionConduccion integer,
    ubiMedio varchar NOT NULL,
    iteracionMedio integer,
    codRelacion varchar NOT NULL,
    PRIMARY KEY (idInstalacion,ubiConduccion,iteracionConduccion, ubiMedio, iteracionMedio, codRelacion),
    FOREIGN KEY (idInstalacion)
        REFERENCES INSTALACION
        ON DELETE CASCADE,
    FOREIGN KEY (ubiConduccion,iteracionConduccion)
        REFERENCES CONDUCCION
        ON DELETE CASCADE,
    FOREIGN KEY (ubiMedio, iteracionMedio)
        REFERENCES MEDIO
        ON DELETE CASCADE
);

CREATE TABLE GALERIASERVICIOS
(
    ubicacion varchar  NOT NULL,
    iteracion integer,
    visitable bit NOT NULL,
    altaTension bit NOT NULL,
    dimensiones varchar  NOT NULL,
    PRIMARY KEY (ubicacion, iteracion),
    FOREIGN KEY (ubicacion, iteracion)
        REFERENCES MEDIO
        ON DELETE CASCADE
);

CREATE TABLE ACCESO
(
    ubicacionGaleria varchar  NOT NULL,
    iteracion integer,
    ubicacionAcceso varchar NOT NULL,
    tipo varchar NOT NULL,
    PRIMARY KEY (ubicacionGaleria, iteracion, ubicacionAcceso),
    FOREIGN KEY (ubicacionGaleria, iteracion)
        REFERENCES GALERIASERVICIOS
        ON DELETE CASCADE
);

CREATE TABLE PLANMANTENIMIENTO
(
    ubicacion varchar  NOT NULL,
    iteracion integer,
    cifEmpresaUsuaria varchar NOT NULL,
    operaciones varchar NOT NULL,
    rutinas varchar NOT NULL,
    controles varchar NOT NULL,
    PRIMARY KEY (ubicacion, iteracion, cifEmpresaUsuaria),
    FOREIGN KEY (ubicacion, iteracion)
        REFERENCES GALERIASERVICIOS
        ON DELETE CASCADE
);

CREATE TABLE TUBULAR
(
    ubicacion varchar  NOT NULL,
    iteracion integer,
    tipoTubular varchar NOT NULL,
    anchura float NOT NULL,
    dimensiones varchar  NOT NULL,
    PRIMARY KEY (ubicacion, iteracion),
    FOREIGN KEY (ubicacion, iteracion)
        REFERENCES MEDIO
        ON DELETE CASCADE,
    CONSTRAINT anchuraNeg CHECK (anchura >= 0)
);

------------------POBLADO DE TABLAS ------------------------

-- Poblado de la tabla LICENCIA
INSERT INTO LICENCIA (idLicencia, tipoLicencia, claseLicencia, titular, tributosPublicos, extinguida)
VALUES
(123, 'Ocupacion', 'Definitiva', 'JuanAntonio', 1500.50, '0'),
(456, 'Ocupacion', 'Definitiva', 'JoseBalles', 2200.75, '0'),
(321, 'Ocupacion', 'Definitiva', 'Juan', 1000.50, '0'),

(789, 'Obra', 'Definitiva', 'MartaCazo', 1800.25, '0'),
(987, 'Obra', 'Definitiva', 'Marta', 1000.25, '0'),

(1234, 'Conexion', 'Provisional', 'LuisDaniel', 1600.25, '0'),
(5678, 'Conexion', 'Transitoria', 'RamonEmpiro', 1200.25, '1');

-- Poblado de la tabla LICENCIA_DEOCUPACION
INSERT INTO LICENCIA_DEOCUPACION (idLicenciaOcupacion, caracter, dominioComprendido, emplazamiento, dimensiones, otras, rutaCroquisSituacion, porcionVia)
VALUES
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '123'), (SELECT claseLicencia FROM LICENCIA WHERE idLicencia = '123'), 'Suelo', 'Calle 2 Mayo', '300x500x50', 'Caracteristicas extras que escribe el funcionario', 'C:\Documents\Proyectos\croquis.pdf', 'Desde el portal 6 al 10'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '321'), (SELECT claseLicencia FROM LICENCIA WHERE idLicencia = '321'), 'Suelo', 'Calle 3 Mayo', '500x500x50', 'Caracteristicas extras que escribe el funcionario', 'C:\Documents\Proyectos\croquis3.pdf', 'Desde el portal 1 al 3'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '456'), (SELECT claseLicencia FROM LICENCIA WHERE idLicencia = '456'), 'Subsuelo', 'Calle Antillas', '100x100x50', NULL , 'C:\Documents\Proyectos\croquis2.pdf', 'Toda la via');

-- Poblado de la tabla LICENCIA_DEOBRA
INSERT INTO LICENCIA_DEOBRA (idLicenciaObra, claseLicenciaObras, plazoInic, plazoFin, porcionVia, acondicionamientoParaCoordinacion, condicionesEspeciales, tipoCala, condicionesEjecucion, horariosDeTrabajo, modalidadesDeTrabajo)
VALUES
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '789'), 'Instalacion de conducciones', '2024-01-01', '2024-02-01', 'Toda la via', 'Acondicionamiento1', 'Condiciones1', 'TipoCala1', 'CondicionesEjecucion1', 'Horarios1', 'Modalidades1'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '987'), 'Instalacion de conducciones', '2024-01-02', '2024-02-02', 'Toda la via', NULL, 'Condiciones2', 'TipoCala1', 'CondicionesEjecucion1', 'Horarios4', 'Modalidades2'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '1234'), 'Conexion', '2024-02-01', '2024-03-01', 'Toda la via', NULL, NULL, 'TipoCala2', 'CondicionesEjecucion11', 'Horarios2', 'Modalidades12'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '5678'), 'Conexion', '2024-03-01', '2024-04-01', 'Toda la via', 'Acondicionamiento3', NULL, 'TipoCala3', 'CondicionesEjecucion12', 'Horarios3', 'Modalidades13');

-- Poblado de la tabla LICENCIA_DECONEXION
INSERT INTO LICENCIA_DECONEXION (idLicencia, claseConexion, tipoCanalizacion, emplazamiento, dimensiones, otras, rutaCroquisSituacion, rutaPlanoObra, clasePavim, superfPavim)
VALUES
((SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '1234'), 'Clase1', 'Por calzada', 'Plaza Mayor', '200x100x30', 'Otras caracteristicas', 'C:\Documents\Proyectos\croquis.pdf', 'C:\Documents\Proyectos\plano.pdf', 'ClasePavim1', '200x100'),
((SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '5678'), 'Clase2', 'Por calzada', 'Plaza Barcelona', '30x30x100', NULL, 'C:\Documents\Proyectos\croquis2.pdf', 'C:\Documents\Proyectos\plano2.pdf', 'ClasePavim2', '30x30');

-- Poblado de la tabla INSTALACION
INSERT INTO INSTALACION (idCodConducciones, titular, estadoEjecucion)
VALUES
('Ubi1-Ubi2-Ubi3', 'Luis_TitularInstalacion1', 'En ejecución'),
('Ubi6-Ubi7-Ubi4-Ubi5', 'Roberto_TitularInstalacion2', 'Completada');

-- Poblado de la tabla PLAN para la primera instalación
INSERT INTO PLAN (cifEmpresaExplotadora, estimacionNecesidades, ubicacionCentroProductor, ubicacionCentroDistribuidor, lineaGeneralTransporte, lineaGeneralDistribucion)
VALUES
('J92455278', 'Estimacion de necesidades que se puede introducir', 'UbicacionProductor1', 'UbicacionDistribuidor1', 'LineaTransporte1', 'LineaDistribucion1'),
('J25813494', NULL, 'UbicacionProductor2', 'UbicacionDistribuidor2', 'LineaTransporte2', 'LineaDistribucion2'),
('S3920079E', NULL, 'UbicacionProductor3', 'UbicacionDistribuidor3', 'LineaTransporte3', 'LineaDistribucion3');

-- Poblado de la tabla PROYECTO referente a la LICENCIA_DEOBRA y al PLAN
INSERT INTO PROYECTO (idLicenciaObra, fechaSolicitud, cifEmpresaExplotadora, motivoObra, instalacionesDeObra, modalidadDeObra, expresionFinalidad, emplazamientoObra, dimensionesObra, caracteristicasObra, rutaPlanoDetallado, restriccionCirculacion, materialesAEmplear, equiposTrabajo, maquinariaAEmplear, fechaFinPrevisibleObra, calendarioEjecucion, presupuesto)
VALUES
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '789'), '2024-01-15', 'J92455278', 'Caida de materiales sobre la via', 'Instalacion electrica', 'ModalidadObra1', 'ExpresionFinalidad1', 'Calle 2 Mayo', '100x100x100', 'CaracteristicasObra1', 'C:\Documents\Proyectos\plano1.pdf', '0', 'Materiales1', 'EquiposTrabajo1', 'Maquinaria1', '2024-11-28', 'Introduccion del calendario', 15000.95),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '1234'), '2024-02-15', 'J25813494', 'Introduccion cable fibra', 'Instalacion de internet', 'ModalidadObra2', 'ExpresionFinalidad2', 'Calle Antillas', '20x20x20', NULL, 'C:\Documents\Proyectos\plano2.pdf', '1', 'Materiales1', 'EquiposTrabajo2', 'Maquinaria2', '2024-12-30', 'Introduccion de otro calendario', 20000),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '987'), '2024-02-15', 'J25813494', 'Construir Galeria', 'Instalacion de galeria', 'ModalidadObra4', 'ExpresionFinalidad4', 'Calle Antillas', '50x50x20', NULL, 'C:\Documents\Proyectos\plano4.pdf', '1', 'Materiales2', 'EquiposTrabajo2', 'Maquinaria4', '2024-12-30', 'Introduccion de otro calendario', 20000),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '5678'), '2024-03-15', 'S3920079E', 'Cambio de tuberias', 'Instalacion agua', 'ModalidadObra3', 'ExpresionFinalidad3', 'Calle Antillas', '10x10x10', 'CaracteristicasObra1', 'C:\Documents\Proyectos\plano3.pdf', '1', 'Materiales1', 'EquiposTrabajo3', 'Maquinaria3', '2024-10-27', 'Introduccion de otro calendario mas', 30500.50);


-- Poblado de la tabla OBRA referente a LICENCIA_DEOCUPACION y LICENCIA_DEOBRA
INSERT INTO OBRA (idLicenciaOcupacion, idLicenciaObra, fechaInic, fechaFin, tecnicoResponsable, garantia, señalamientoFecha)
VALUES
((SELECT idLicenciaOcupacion FROM LICENCIA_DEOCUPACION WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '789'), '2024-02-01', '2024-12-31', 'Monolo', '2025-12-31', 'SeñalamientoFecha1'),
((SELECT idLicenciaOcupacion FROM LICENCIA_DEOCUPACION WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '5678'), '2024-02-02', '2024-12-30', 'NoMonolo', '2025-12-31', 'SeñalamientoFecha3'),
((SELECT idLicenciaOcupacion FROM LICENCIA_DEOCUPACION WHERE idLicenciaOcupacion = '321'), (SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '987'), '2024-02-03', '2024-12-29', 'NoMonolo', '2025-12-31', 'SeñalamientoFecha4'),
((SELECT idLicenciaOcupacion FROM LICENCIA_DEOCUPACION WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '1234'), '2024-02-13', '2024-12-19', 'Monolo', '2025-12-31', 'SeñalamientoFecha2');

-- Poblado de la tabla OBRA_CONDUCCION
INSERT INTO OBRA_CONDUCCION (idLicenciaOcupacion, idLicenciaObra, caracteristicas, temporal)
VALUES
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '789'), 'Caracteristicas1', '1'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '321'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '987'), 'Caracteristicas3', '0'),
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '5678'), 'Caracteristicas2', '0');

-- Poblado de la tabla OBRA_MEDIO
INSERT INTO OBRA_MEDIO (idLicenciaOcupacion, idLicenciaObra, caracteristicas, temporal)
VALUES
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '1234'), 'Caracteristicas10', '0');


-- Poblado de la tabla DEPOSITO referente a OBRA
INSERT INTO DEPOSITO (idLicenciaOcupacion, idLicenciaObra, fechaCreacion, peticionario, costeReposicion, dañosYPerjuiciosOcasionados, gastosPorDesviarTrafico, plazoGarantia)
VALUES
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '789'), '2024-05-01', 'Peticionaria1', 5000.0, 'Daños y Perjuicios1', NULL , '2024-09-01'),
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '789'), '2024-08-01', 'Peticionaria1', 5000.0, 'Daños y Perjuicios1', NULL , '2024-09-01'),
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '5678'), '2024-05-01', 'Peticionaria3', 5000.0, 'Daños y Perjuicios1', NULL , '2024-09-01'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '321'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '987'), '2024-05-01', 'Peticionaria4', 5000.0, 'Daños y Perjuicios1', NULL , '2024-09-01'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '1234'),'2024-05-01', 'Peticionaria2', 6000.0, 'Daños y Perjuicios2', 500.0, '2024-09-01');

-- Poblado de la tabla INSPECCION referente a OBRA
INSERT INTO INSPECCION (idLicenciaOcupacion, idLicenciaObra, comprobacionEspacio, comprobacionTiempo, comprobacionConformidad, comprobacionConsInstalac, comprobacionFormaEjec, comprobacionReposicElem)
VALUES
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '789'), '1', '1', '0', '1', '0', '1'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '1234'), '1', '1', '1', '1', '0', '1'),
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '5678'), '1', '1', '1', '1', '0', '1'),
((SELECT DISTINCT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '5678'), '1', '1', '1', '1', '1', '1'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '321'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = '987'), '1', '1', '1', '1', '1', '1');

-- Poblado de la tabla MULTA referente a INSPECCION
INSERT INTO MULTA (idLicenciaOcupacion, idLicenciaObra, idInspeccion, tipoInfraccion, importe)
VALUES
((SELECT DISTINCT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '1'), (SELECT DISTINCT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '1'), (SELECT idInspeccion FROM INSPECCION WHERE idInspeccion = '1'), 'retrasoEjecucion', 500.0),
((SELECT DISTINCT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '3'), (SELECT DISTINCT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '3'), (SELECT idInspeccion FROM INSPECCION WHERE idInspeccion = '3'), 'retrasoEjecucion', 500.0),
((SELECT DISTINCT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '3'), (SELECT DISTINCT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '3'), (SELECT idInspeccion FROM INSPECCION WHERE idInspeccion = '3'), 'noPagarLaAnterior', 5000.0),
((SELECT DISTINCT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '4'), (SELECT DISTINCT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '4'), (SELECT idInspeccion FROM INSPECCION WHERE idInspeccion = '4'), 'infraccionCasetas', 400.0),
((SELECT DISTINCT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '4'), (SELECT DISTINCT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '4'), (SELECT idInspeccion FROM INSPECCION WHERE idInspeccion = '4'), 'infraccionVallas', 300.0);

-- Poblado de la tabla CONDUCCION
INSERT INTO CONDUCCION (ubicacion, dominioComprendido, enterrada, profundidadLibre, tipo, profundidad, proteccionEspecial, altura, idLicenciaOcupacion, idLicenciaObra)
VALUES
('Ubicacion1', 'Subsuelo', '1', 10.0, 'Telefonia', 12.0, '1', 0,(SELECT DISTINCT idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '789')),
('Ubicacion2', 'Suelo', '0', 0, 'Telefonia', 0.0, '0', 0, (SELECT DISTINCT idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '789')),
('Ubicacion3', 'Subsuelo', '1', 12.0, 'Electrica', 15.0, '1', 0, (SELECT DISTINCT idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '789')),
('Ubicacion4', 'Subsuelo', '1', 10.0, 'Gas', 12.0, '1', 0,(SELECT DISTINCT idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '5678')),
('Ubicacion5', 'Suelo', '0', 0, 'Agua', 0.0, '0', 0, (SELECT DISTINCT idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '5678')),
('Ubicacion6', 'Subsuelo', '1', 10.0, 'Gas', 12.0, '1', 0,(SELECT  idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '321'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '987')),
('Ubicacion7', 'Suelo', '0', 0, 'Gas', 0.0, '0', 0, (SELECT  idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  idLicenciaOcupacion = '321'), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE idLicenciaObra = '987'));

-- Poblado de la tabla CONDUCCION_ELECTRICA
INSERT INTO CONDUCCION_ELECTRICA (ubicacion, iteracion, energiaTransportada)
VALUES
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'),(SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'), 450.0);

-- Poblado de la tabla DISTANCIA
INSERT INTO DISTANCIA (ubiConduccion1, iteracion1, ubiConduccion2, iteracion2, distancia, paralela)
VALUES
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion2'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion2'), 20.0, '1'),
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion4'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion4'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion2'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion2'), 10.0, '1'),
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion7'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion7'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion5'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion5'), 12.0, '0'),
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion1'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion1'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion7'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion7'),11.0, '1'),
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion4'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion4'), 7.0, '0');

-- Poblado de la tabla MEDIO
INSERT INTO MEDIO (ubicacion, tipo, idLicenciaOcupacion, idLicenciaObra)
VALUES
('Ubicacion11', 'Tubular', (SELECT idLicenciaOcupacion FROM OBRA_MEDIO WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM OBRA_MEDIO WHERE idLicenciaObra = '1234')),
('Ubicacion12', 'Galeria', (SELECT idLicenciaOcupacion FROM OBRA_MEDIO WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM OBRA_MEDIO WHERE idLicenciaObra = '1234'));

-- Poblado de la tabla RELACION
INSERT INTO RELACION (idInstalacion, ubiConduccion, iteracionConduccion, ubiMedio, iteracionMedio, codRelacion)
VALUES
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi1-Ubi2-Ubi3'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion1'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion1'),(SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion11'),(SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion11'), 'Relacion-conduccionUbicacion1-Iteracion1-medioUbicacion11-medioIteracion1-InstalacionUbi1-Ubi2-Ubi3'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi1-Ubi2-Ubi3'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion2'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion2'),(SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion11'),(SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion11'), 'Relacion-conduccionUbicacion2-Iteracion1-medioubicacion11-medioIteracion1-InstalacionUbi1-Ubi2-Ubi3'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi1-Ubi2-Ubi3'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion3'),(SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion11'),(SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion11'), 'Relacion-conduccionUbicacion3-Iteracion1-medioUbicacion11-medioIteracion1-InstalacionUbi1-Ubi2-Ubi3'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi6-Ubi7-Ubi4-Ubi5'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion4'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion4'), (SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), (SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'Relacion-conduccionUbicacion4-Iteracion1-medioUbicacion12-medioIteracion1-InstalacionUbi6-Ubi7-Ubi4-Ubi5'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi6-Ubi7-Ubi4-Ubi5'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion5'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion5'), (SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), (SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'Relacion-conduccionUbicacion5-Iteracion1-medioUbicacion12-medioIteracion1-InstalacionUbi6-Ubi7-Ubi4-Ubi5'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi6-Ubi7-Ubi4-Ubi5'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion6'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion6'), (SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), (SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'Relacion-conduccionUbicacion6-Iteracion1-medioUbicacion12-medioIteracion1-InstalacionUbi6-Ubi7-Ubi4-Ubi5'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Ubi6-Ubi7-Ubi4-Ubi5'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Ubicacion7'), (SELECT iteracion FROM CONDUCCION WHERE ubicacion = 'Ubicacion7'), (SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), (SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'Relacion-conduccionUbicacion7-Iteracion1-medioUbicacion12-medioIteracion1-InstalacionUbi6-Ubi7-Ubi4-Ubi5');

-- Poblado de la tabla GALERIASERVICIOS con respecto al MEDIO1
INSERT INTO GALERIASERVICIOS (ubicacion, iteracion, visitable, altaTension, dimensiones)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'),(SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), '1', '0', '100x50x50');

-- Poblado de la tabla ACCESO relacionado a la GALERIASERVICIOS
INSERT INTO ACCESO (ubicacionGaleria, iteracion, ubicacionAcceso, tipo)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'),(SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'UbicacionAcceso515Plaza', 'Personal'),
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'),(SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'UbicacionAccesoLateral41Plaza', 'Materiales');

-- Poblado de la tabla PLANMANTENIMIENTO relacionado a la GALERIASERVICIOS
INSERT INTO PLANMANTENIMIENTO (ubicacion, iteracion, cifEmpresaUsuaria, operaciones, rutinas, controles)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), (SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion12'), 'G48524045', 'Operaciones requeridas por la empresa...', 'Rutinas a seguir por la empresa...', 'Controles requeridos....');

-- Poblado de la tabla TUBULAR para los dos últimos medios
INSERT INTO TUBULAR (ubicacion, iteracion, tipoTubular, anchura, dimensiones)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Ubicacion11'), (SELECT iteracion FROM MEDIO WHERE ubicacion = 'Ubicacion11'), 'Multitubular', 2.0, '20x20x20');


