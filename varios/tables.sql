create table categorias(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(255)
);

create table habilidades(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    habilidad VARCHAR(255),
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

create table perfiles(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT
);

create table perfil_habilidad(
    perfil_id INTEGER,
    habilidad_id INTEGER,
    valor_esperado INTEGER,
    FOREIGN KEY (perfil_id) REFERENCES perfiles(id),
    FOREIGN KEY (habilidad_id) REFERENCES habilidades(id)
);

create table estados(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(255)
);

create table colaboradores(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    rut INTEGER,
    correo VARCHAR(255),
    estado_id INTEGER,
    FOREIGN KEY (estado_id) REFERENCES estados(id)
);

create table periodos(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    feha_inicio DATE,
    fecha_termino DATE
);

create table colaborador_periodo(
    colaborador_id INTEGER,
    periodo_id INTEGER,
    FOREIGN KEY (colaborador_id) REFERENCES colaboradores(id),
    FOREIGN KEY (periodo_id) REFERENCES periodos(id)
);

create table evaluadores(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    colaborador_id INTEGER,
    periodo_id INTEGER,
    FOREIGN KEY (colaborador_id) REFERENCES colaboradores(id),
    FOREIGN KEY (periodo_id) REFERENCES periodos(id)
);

create table evaluaciones(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    colaborador_id INTEGER,
    evaluador_id INTEGER,
    FOREIGN KEY (colaborador_id) REFERENCES colaboradores(id),
    FOREIGN KEY (evaluador_id) REFERENCES evaluadores(id)
);

create table evaluacion_habilidad(
    habilidad_id INTEGER,
    evaluacion_id INTEGER,
    valor INTEGER,
    FOREIGN KEY (habilidad_id) REFERENCES habilidades(id),
    FOREIGN KEY (evaluacion_id) REFERENCES evaluaciones(id)
);

create table administradores(
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(255),
    pass VARCHAR(255),
    nombre VARCHAR(255),
    rut INTEGER,
    correo VARCHAR(255)
);