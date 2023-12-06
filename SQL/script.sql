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
    tipoCala varchar NOT NULL,
    condicionesEjecucion text NOT NULL,
    horariosDeTrabajo varchar NOT NULL,
    modalidadesDeTrabajo varchar NOT NULL,
    PRIMARY KEY (idLicenciaObra),
    FOREIGN KEY (idLicenciaObra)
        REFERENCES LICENCIA
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
        REFERENCES LICENCIA_DEOBRA (idLicenciaObra), 
    FOREIGN KEY (cifEmpresaExplotadora) 
        REFERENCES PLAN (cifEmpresaExplotadora) 
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
        REFERENCES LICENCIA_DEOCUPACION(idLicenciaOcupacion),
    FOREIGN KEY (idLicenciaObra)
        REFERENCES LICENCIA_DEOBRA(idLicenciaObra)
);

CREATE TABLE OBRA_CONDUCCION
(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    iteracion SERIAL,
    caracteristicas text,
    temporal bit NOT NULL,

    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra,iteracion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA(idLicenciaOcupacion, idLicenciaObra)
);


CREATE TABLE OBRA_MEDIO
(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    iteracion SERIAL,
    caracteristicas text,
    temporal bit NOT NULL,

    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra,iteracion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra)
        REFERENCES OBRA(idLicenciaOcupacion, idLicenciaObra)


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
);



CREATE TABLE CONDUCCION
(
    ubicacion varchar  NOT NULL,
    dominioComprendido varchar  NOT NULL,
    enterrada bit NOT NULL,
    profundidadLibre float NOT NULL,
    tipo varchar  NOT NULL,
    profundidad float NOT NULL,
    proteccionEspecial bit NOT NULL,
    altura float NOT NULL,
    idLicenciaOcupacion integer,
    idLicenciaObra integer,
    iteracion integer,
    PRIMARY KEY (ubicacion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra, iteracion)
        REFERENCES OBRA_CONDUCCION(idLicenciaOcupacion, idLicenciaObra, iteracion)
);

CREATE TABLE CONDUCCION_ELECTRICA
(
    ubicacion varchar  NOT NULL,
    energiaTransportada float NOT NULL,
    PRIMARY KEY (ubicacion)
);

CREATE TABLE DISTANCIA
(
    idConduccion1 varchar  NOT NULL,
    idConduccion2 varchar NOT NULL,
    distancia float NOT NULL,
    paralela bit NOT NULL,
    PRIMARY KEY (idConduccion1, idConduccion2),
    FOREIGN KEY(idConduccion1) 
        REFERENCES CONDUCCION,
    FOREIGN KEY(idConduccion2)
        REFERENCES CONDUCCION
);


CREATE TABLE MEDIO
(
    ubicacion varchar  NOT NULL,
    tipo varchar  NOT NULL,
    idLicenciaOcupacion integer,
    idLicenciaObra integer,
    iteracion integer,
    PRIMARY KEY (ubicacion),
    FOREIGN KEY (idLicenciaOcupacion, idLicenciaObra, iteracion)
        REFERENCES OBRA_MEDIO(idLicenciaOcupacion, idLicenciaObra, iteracion)

);

CREATE TABLE RELACION
(
    idInstalacion varchar  NOT NULL,
    idConduccion varchar NOT NULL,
    idMedio varchar NOT NULL,
    codRelacion varchar NOT NULL,
    PRIMARY KEY (idInstalacion,idConduccion,idMedio,codRelacion),
    FOREIGN KEY (idInstalacion)
        REFERENCES INSTALACION,
    FOREIGN KEY (idConduccion)
        REFERENCES CONDUCCION,
    FOREIGN KEY (idMedio)
        REFERENCES MEDIO
);

CREATE TABLE GALERIASERVICIOS
(
    ubicacion varchar  NOT NULL,
    visitable bit NOT NULL,
    altaTension bit NOT NULL,
    dimensiones varchar  NOT NULL,
    PRIMARY KEY (ubicacion),
    FOREIGN KEY (ubicacion)
        REFERENCES MEDIO
);

CREATE TABLE ACCESO
(
    ubicacionGaleria varchar  NOT NULL,
    ubicacionAcceso varchar NOT NULL,
    tipo varchar NOT NULL,
    PRIMARY KEY (ubicacionGaleria, ubicacionAcceso),
    FOREIGN KEY (ubicacionGaleria)
        REFERENCES GALERIASERVICIOS
);

CREATE TABLE PLANMANTENIMIENTO
(
    ubicacion varchar  NOT NULL,
    cifEmpresaUsuaria varchar NOT NULL,
    operaciones varchar NOT NULL,
    rutinas varchar NOT NULL,
    controles varchar NOT NULL,
    PRIMARY KEY (ubicacion, cifEmpresaUsuaria),
    FOREIGN KEY (ubicacion)
        REFERENCES GALERIASERVICIOS
);

CREATE TABLE TUBULAR
(
    ubicacion varchar  NOT NULL,
    tipoTubular varchar NOT NULL,
    anchura float NOT NULL,
    dimensiones varchar  NOT NULL,
    PRIMARY KEY (ubicacion),
    FOREIGN KEY (ubicacion)
        REFERENCES MEDIO
);

------------------POBLADO DE TABLAS ------------------------

-- Poblado de la tabla LICENCIA
INSERT INTO LICENCIA (idLicencia, tipoLicencia, claseLicencia, titular, tributosPublicos, extinguida)
VALUES
(123, 'Ocupacion', 'Definitiva', 'JuanAntonio', 1500.50, '0'),
(456, 'Ocupacion', 'Definitiva', 'JoseBalles', 2200.75, '0'),
(789, 'Obra', 'Definitiva', 'MartaCazo', 1800.25, '0'),
(1234, 'Conexion', 'Provisional', 'LuisDaniel', 1600.25, '0'),
(5678, 'Conexion', 'Transitoria', 'RamonEmpiro', 1200.25, '1');

-- Poblado de la tabla LICENCIA_DEOCUPACION
INSERT INTO LICENCIA_DEOCUPACION (idLicenciaOcupacion, caracter, dominioComprendido, emplazamiento, dimensiones, otras, rutaCroquisSituacion, porcionVia)
VALUES
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '123'), (SELECT claseLicencia FROM LICENCIA WHERE idLicencia = '123'), 'Suelo', 'Calle 2 Mayo', '300x500x50', 'Caracteristicas extras que escribe el funcionario', 'C:\Documents\Proyectos\croquis.pdf', 'Desde el portal 6 al 10'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '456'), (SELECT claseLicencia FROM LICENCIA WHERE idLicencia = '123'), 'Subsuelo', 'Calle Antillas', '100x100x50', NULL , 'C:\Documents\Proyectos\croquis2.pdf', 'Toda la via');

-- Poblado de la tabla LICENCIA_DEOBRA
INSERT INTO LICENCIA_DEOBRA (idLicenciaObra, claseLicenciaObras, plazoInic, plazoFin, porcionVia, acondicionamientoParaCoordinacion, condicionesEspeciales, tipoCala, condicionesEjecucion, horariosDeTrabajo, modalidadesDeTrabajo)
VALUES
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '789'), 'Instalacion de conducciones', '2023-01-01', '2023-02-01', 'Toda la via', 'Acondicionamiento1', 'Condiciones1', 'TipoCala1', 'CondicionesEjecucion1', 'Horarios1', 'Modalidades1'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '1234'), 'Conexion', '2023-02-01', '2023-03-01', 'Toda la via', NULL, NULL, 'TipoCala2', 'CondicionesEjecucion2', 'Horarios2', 'Modalidades2'),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '5678'), 'Conexion', '2023-03-01', '2023-04-01', 'Toda la via', 'Acondicionamiento3', NULL, 'TipoCala3', 'CondicionesEjecucion3', 'Horarios3', 'Modalidades3');

-- Poblado de la tabla LICENCIA_DECONEXION
INSERT INTO LICENCIA_DECONEXION (idLicencia, claseConexion, tipoCanalizacion, emplazamiento, dimensiones, otras, rutaCroquisSituacion, rutaPlanoObra, clasePavim, superfPavim)
VALUES
((SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '1234'), 'Clase1', 'Por calzada', 'Plaza Mayor', '200x100x30', 'Otras caracteristicas', 'C:\Documents\Proyectos\croquis.pdf', 'C:\Documents\Proyectos\plano.pdf', 'ClasePavim1', '200x100'),
((SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '5678'), 'Clase2', 'Por calzada', 'Plaza Cataluña', '30x30x100', NULL, 'C:\Documents\Proyectos\croquis2.pdf', 'C:\Documents\Proyectos\plano2.pdf', 'ClasePavim2', '30x30');

-- Poblado de la tabla INSTALACION
INSERT INTO INSTALACION (idCodConducciones, titular, estadoEjecucion)
VALUES
('Plaza1-Plaza2-Plaza2-Plaza3-Plaza3-Calle1', 'Luis_TitularInstalacion1', 'En ejecución'),
('Plaza2-Plaza3-Plaza3-Calle2-Calle2-Calle1', 'Roberto_TitularInstalacion2', 'Completada'),
('Plaza3-Calle1-Calle1-Plaza4-Plaza4-Calle3', 'Rafa_TitularInstalacion3', 'En ejecución');

-- Poblado de la tabla PLAN para la primera instalación
INSERT INTO PLAN (cifEmpresaExplotadora, estimacionNecesidades, ubicacionCentroProductor, ubicacionCentroDistribuidor, lineaGeneralTransporte, lineaGeneralDistribucion)
VALUES
('J92455278', 'Estimacion de necesidades que se puede introducir', 'UbicacionProductor1', 'UbicacionDistribuidor1', 'LineaTransporte1', 'LineaDistribucion1'),
('J25813494', NULL, 'UbicacionProductor2', 'UbicacionDistribuidor2', 'LineaTransporte2', 'LineaDistribucion2'),
('S3920079E', NULL, 'UbicacionProductor3', 'UbicacionDistribuidor3', 'LineaTransporte3', 'LineaDistribucion3');

-- Poblado de la tabla PROYECTO referente a la LICENCIA_DEOBRA y al PLAN
INSERT INTO PROYECTO (idLicenciaObra, fechaSolicitud, cifEmpresaExplotadora, motivoObra, instalacionesDeObra, modalidadDeObra, expresionFinalidad, emplazamientoObra, dimensionesObra, caracteristicasObra, rutaPlanoDetallado, restriccionCirculacion, materialesAEmplear, equiposTrabajo, maquinariaAEmplear, fechaFinPrevisibleObra, calendarioEjecucion, presupuesto)
VALUES
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '789'), '2023-01-15', 'J92455278', 'Caida de materiales sobre la via', 'Instalacion electrica', 'ModalidadObra1', 'ExpresionFinalidad1', 'Calle 2 Mayo', '100x100x100', 'CaracteristicasObra1', 'C:\Documents\Proyectos\plano1.pdf', '0', 'Materiales1', 'EquiposTrabajo1', 'Maquinaria1', '2023-11-28', 'Introduccion del calendario', 15000.95),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '1234'), '2023-02-15', 'J25813494', 'Introduccion cable fibra', 'Instalacion de internet', 'ModalidadObra2', 'ExpresionFinalidad2', 'Calle Antillas', '20x20x20', NULL, 'C:\Documents\Proyectos\plano2.pdf', '1', 'Materiales1', 'EquiposTrabajo2', 'Maquinaria2', '2023-12-30', 'Introduccion de otro calendario', 20000),
((SELECT idLicencia FROM LICENCIA WHERE idLicencia = '5678'), '2023-03-15', 'S3920079E', 'Cambio de tuberias', 'Instalacion agua', 'ModalidadObra3', 'ExpresionFinalidad3', 'Calle Antillas', '10x10x10', 'CaracteristicasObra1', 'C:\Documents\Proyectos\plano3.pdf', '1', 'Materiales1', 'EquiposTrabajo3', 'Maquinaria3', '2023-10-27', 'Introduccion de otro calendario mas', 30500.50);


-- Poblado de la tabla OBRA referente a LICENCIA_DEOCUPACION y LICENCIA_DEOBRA
INSERT INTO OBRA (idLicenciaOcupacion, idLicenciaObra, fechaInic, fechaFin, tecnicoResponsable, garantia, señalamientoFecha)
VALUES
((SELECT idLicenciaOcupacion FROM LICENCIA_DEOCUPACION WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '789'), '2023-02-01', '2023-12-31', 'TecnicoResponsable1', '2023-12-31', 'SeñalamientoFecha1'),
((SELECT idLicenciaOcupacion FROM LICENCIA_DEOCUPACION WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM LICENCIA_DEOBRA WHERE idLicenciaObra = '1234'), '2023-02-01', '2023-12-31', 'TecnicoResponsable1', '2023-12-31', 'SeñalamientoFecha2');

-- Poblado de la tabla OBRA_CONDUCCION
INSERT INTO OBRA_CONDUCCION (idLicenciaOcupacion, idLicenciaObra, caracteristicas, temporal)
VALUES
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = 123), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = 789), 'Caracteristicas1', '0'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = 123), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = 789), 'Caracteristicas2', '0'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = 123), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = 789), 'Caracteristicas3', '0');

-- Poblado de la tabla OBRA_MEDIO
INSERT INTO OBRA_MEDIO (idLicenciaOcupacion, idLicenciaObra, caracteristicas, temporal)
VALUES
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = 456), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = 1234), 'Caracteristicas1', '0'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = 456), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = 1234), 'Caracteristicas2', '0'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = 456), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaObra = 1234), NULL, '0');

-- Poblado de la tabla DEPOSITO referente a OBRA
INSERT INTO DEPOSITO (idLicenciaOcupacion, idLicenciaObra, fechaCreacion, peticionario, costeReposicion, dañosYPerjuiciosOcasionados, gastosPorDesviarTrafico, plazoGarantia)
VALUES
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaOcupacion = '123'), '2023-02-01', 'Peticionaria1', 5000.0, 'Daños y Perjuicios1', NULL , '2024-02-01'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '456'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaOcupacion = '456'),'2023-01-01', 'Peticionaria2', 6000.0, 'Daños y Perjuicios2', 500.0, '2024-02-01');

-- Poblado de la tabla INSPECCION referente a OBRA
INSERT INTO INSPECCION (idLicenciaOcupacion, idLicenciaObra, comprobacionEspacio, comprobacionTiempo, comprobacionConformidad, comprobacionConsInstalac, comprobacionFormaEjec, comprobacionReposicElem)
VALUES
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaOcupacion = '123'), '1', '1', '0', '1', '0', '1'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaOcupacion = '123'), '1', '1', '1', '1', '0', '1'),
((SELECT idLicenciaOcupacion FROM OBRA WHERE idLicenciaOcupacion = '123'), (SELECT idLicenciaObra FROM OBRA WHERE idLicenciaOcupacion = '123'), '1', '1', '1', '1', '1', '1');


-- Poblado de la tabla MULTA referente a INSPECCION
INSERT INTO MULTA (idLicenciaOcupacion, idLicenciaObra, idInspeccion, tipoInfraccion, importe)
VALUES
((SELECT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '1'), (SELECT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '1'), 1, 'retrasoEjecucion', 500.0),
((SELECT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '1'), (SELECT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '1'), 1, 'infraccionCasetas', 400.0),
((SELECT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '1'), (SELECT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '1'), 1, 'infraccionVallas', 300.0),
((SELECT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '2'), (SELECT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '2'), 2, 'faltaReposicion', 500.0),
((SELECT idLicenciaOcupacion FROM INSPECCION WHERE idInspeccion = '2'), (SELECT idLicenciaObra FROM INSPECCION WHERE idInspeccion = '2'), 2, 'reposicionProvisionalPeligrosa', 500.0);


-- Poblado de la tabla CONDUCCION
INSERT INTO CONDUCCION (ubicacion, dominioComprendido, enterrada, profundidadLibre, tipo, profundidad, proteccionEspecial, altura, idLicenciaOcupacion, idLicenciaObra, iteracion)
VALUES
('Plaza1-Plaza2', 'Subsuelo', '1', 10.0, 'Electricidad', 12.0, '1', 0,(SELECT idLicenciaOcupacion FROM OBRA_CONDUCCION WHERE  iteracion = 3), (SELECT idLicenciaObra FROM OBRA_CONDUCCION WHERE  iteracion = 3), (SELECT iteracion FROM OBRA_CONDUCCION WHERE iteracion = 3)),
('Plaza1-Plaza3', 'Suelo', '0', 0, 'Electricidad', 0.0, '0', 0, NULL, NULL, NULL),
('Plaza3-Calle1', 'Subsuelo', '1', 12.0, 'Agua', 15.0, '1', 0, NULL, NULL, NULL);

-- Poblado de la tabla CONDUCCION_ELECTRICA
INSERT INTO CONDUCCION_ELECTRICA (ubicacion, energiaTransportada)
VALUES
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Plaza1-Plaza2'), 450.0),
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Plaza1-Plaza3'), 500.0);

-- Poblado de la tabla DISTANCIA
INSERT INTO DISTANCIA (idConduccion1, idConduccion2, distancia, paralela)
VALUES
((SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Plaza1-Plaza2'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Plaza1-Plaza3'), 20.0, '1');

-- Poblado de la tabla MEDIO
INSERT INTO MEDIO (ubicacion, tipo,idLicenciaOcupacion, idLicenciaObra, iteracion)
VALUES
('Plaza1-Plaza2', 'Tubular',NULL,NULL,NULL),
('Plaza1-Plaza3', 'Galeria',NULL,NULL,NULL);

-- Poblado de la tabla RELACION
INSERT INTO RELACION (idInstalacion, idConduccion, idMedio, codRelacion)
VALUES
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Plaza1-Plaza2-Plaza2-Plaza3-Plaza3-Calle1'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Plaza1-Plaza2'), (SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza2'), 'Relacion-Plaza1-Plaza2-InstalacionPlaza1-Calle1'),
((SELECT idCodConducciones FROM INSTALACION WHERE idCodConducciones = 'Plaza1-Plaza2-Plaza2-Plaza3-Plaza3-Calle1'), (SELECT ubicacion FROM CONDUCCION WHERE ubicacion = 'Plaza1-Plaza3'), (SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza3'), 'Relacion-Plaza1-Plaza3-InstalacionPlaza1-Calle1');

-- Poblado de la tabla GALERIASERVICIOS con respecto al MEDIO1
INSERT INTO GALERIASERVICIOS (ubicacion, visitable, altaTension, dimensiones)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza3'), '1', '0', '100x50x50');

-- Poblado de la tabla ACCESO relacionado a la GALERIASERVICIOS
INSERT INTO ACCESO (ubicacionGaleria, ubicacionAcceso, tipo)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza3'), 'acceso515Plaza', 'Personal'),
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza3'), 'accesoLateral41Plaza', 'Personal'),
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza3'), 'acceso245Plaza' , 'Materiales');

-- Poblado de la tabla PLANMANTENIMIENTO relacionado a la GALERIASERVICIOS
INSERT INTO PLANMANTENIMIENTO (ubicacion, cifEmpresaUsuaria, operaciones, rutinas, controles)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza3'), 'G48524045', 'Operaciones requeridas por la empresa...', 'Rutinas a seguir por la empresa...', 'Controles requeridos....');

-- Poblado de la tabla TUBULAR para los dos últimos medios
INSERT INTO TUBULAR (ubicacion, tipoTubular, anchura, dimensiones)
VALUES
((SELECT ubicacion FROM MEDIO WHERE ubicacion = 'Plaza1-Plaza2'), 'Multitubular', 2.0, '20x20x20');


