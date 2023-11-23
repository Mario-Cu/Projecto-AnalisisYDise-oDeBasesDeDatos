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
DROP TABLE IF EXISTS OBRA;
DROP TABLE IF EXISTS PROYECTO;
DROP TABLE IF EXISTS PLAN;
DROP TABLE IF EXISTS INSTALACION;
DROP TABLE IF EXISTS CONDUCCION;
DROP TABLE IF EXISTS LICENCIA_DECONEXION;
DROP TABLE IF EXISTS LICENCIA_DEOBRA;
DROP TABLE IF EXISTS LICENCIA_DEOCUPACION;
DROP TABLE IF EXISTS LICENCIA;
DROP TABLE IF EXISTS MEDIO;

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

CREATE TABLE LICENCIA_DECONEXION
(
    idLicencia integer NOT NULL,
    claseConexion varchar NOT NULL,
    PRIMARY KEY (idLicencia),
    FOREIGN KEY (idLicencia)
        REFERENCES LICENCIA
);

CREATE TABLE LICENCIA_DEOCUPACION
(
    idLicencia integer NOT NULL,
    caracter varchar NOT NULL,
    dominioComprendido varchar NOT NULL,
    PRIMARY KEY (idLicencia),
    FOREIGN KEY (idLicencia)
        REFERENCES LICENCIA
);

CREATE TABLE LICENCIA_DEOBRA
(
    idLicencia integer NOT NULL,
    claseLicenciaObras varchar NOT NULL,
    plazoInic Date NOT NULL,
    plazoFin Date NOT NULL,
    PRIMARY KEY (idLicencia),
    FOREIGN KEY (idLicencia)
        REFERENCES LICENCIA
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
    idInstalacion varchar NOT NULL,
    ubicacionCentroProductor varchar NOT NULL,
    PRIMARY KEY (cifEmpresaExplotadora),
    FOREIGN KEY (idInstalacion)
        REFERENCES INSTALACION
);

CREATE TABLE PROYECTO(
    idLicenciaObra integer NOT NULL,
    fechaSolicitud Date NOT NULL,
    cifEmpresaExplotadora varchar NOT NULL,
    PRIMARY KEY (idLicenciaObra, fechaSolicitud),
    FOREIGN KEY (idLicenciaObra) 
        REFERENCES LICENCIA_DEOBRA (idLicencia), 
    FOREIGN KEY (cifEmpresaExplotadora) 
        REFERENCES PLAN (cifEmpresaExplotadora) 
);


CREATE TABLE OBRA(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    fechaInic Date NOT NULL,
    fechaFin Date NOT NULL,
    tecnicoResponsable varchar NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra),
    FOREIGN KEY (idLicenciaOcupacion)
        REFERENCES LICENCIA_DEOCUPACION (idLicencia), 
    FOREIGN KEY (idLicenciaObra)
        REFERENCES LICENCIA_DEOBRA (idLicencia) 
);


CREATE TABLE DEPOSITO(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    fechaCreacion Date NOT NULL,
    costeReposicion float NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra, fechaCreacion),
    FOREIGN KEY (idLicenciaOcupacion)
    REFERENCES OBRA (idLicenciaOcupacion), 
    FOREIGN KEY (idLicenciaObra)
    REFERENCES OBRA (idLicenciaObra) 
);


CREATE TABLE INSPECCION(
    idLicenciaOcupacion integer NOT NULL,
    idLicenciaObra integer NOT NULL,
    idInspeccion integer NOT NULL,
    PRIMARY KEY (idLicenciaOcupacion, idLicenciaObra, idInspeccion),
    FOREIGN KEY (idLicenciaOcupacion)
        REFERENCES OBRA (idLicenciaOcupacion), 
    FOREIGN KEY (idLicenciaObra)
        REFERENCES OBRA (idLicenciaObra) 
);


CREATE TABLE MULTA(
    idInspeccion integer NOT NULL,
    idMulta integer NOT NULL,
    tipoInfraccion varchar NOT NULL,
    importe float NOT NULL,
    PRIMARY KEY (idInspeccion, idMulta),
    FOREIGN KEY (idInspeccion)
        REFERENCES INSPECCION (idInspeccion) 
);


CREATE TABLE CONDUCCION
(
    ubicacion varchar  NOT NULL,
    dominioComprendido varchar  NOT NULL,
    enterrada bit(1) NOT NULL,
    profundidadLibre float NOT NULL,
    tipo varchar  NOT NULL,
    profundidad float NOT NULL,
    proteccionEspecial bit(1) NOT NULL,
    altura float NOT NULL,
    PRIMARY KEY (ubicacion)
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
    paralela bit(1) NOT NULL,
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
    PRIMARY KEY (ubicacion)
);

CREATE TABLE RELACION
(
    idInstalacion varchar  NOT NULL,
    idConduccion varchar NOT NULL,
    idMedio varchar NOT NULL,
    PRIMARY KEY (idInstalacion,idConduccion,idMedio),
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
    visitable bit(1) NOT NULL,
    altaTension bit(1) NOT NULL,
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

