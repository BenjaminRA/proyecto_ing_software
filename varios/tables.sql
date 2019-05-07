create table categorias(
    id INTEGER PRIMARY KEY autoincrement,
    categoria VARCHAR(255)
);

create table habilidades(
    id INTEGER PRIMARY KEY autoincrement,
    habilidad VARCHAR(255),
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

create table perfiles(
    id INTEGER PRIMARY KEY autoincrement,
    perfil VARCHAR(255),
    descripcion TEXT
);

create table perfil_habilidad(
    perfil_id INTEGER,
    habilidad_id INTEGER,
    valor_esperado INTEGER,
    FOREIGN KEY (perfil_id) REFERENCES perfiles(id),
    FOREIGN KEY (habilidad_id) REFERENCES habilidades(id)
);

create table usuarios(
    id INTEGER PRIMARY KEY autoincrement,
    nombre VARCHAR(255),
    rut INTEGER,
    pwd VARCHAR(255),
    correo VARCHAR(255)
);

create table estados(
    id INTEGER PRIMARY KEY autoincrement,
    estado VARCHAR(255)
);

create table colaboradores(
    id INTEGER PRIMARY KEY autoincrement,
    usuario_id INTEGER,
    estado_id INTEGER,
    FOREIGN KEY (estado_id) REFERENCES estados(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

create table administradores(
    usuario_id INTEGER PRIMARY KEY,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

create table periodos(
    id INTEGER PRIMARY KEY autoincrement,
    feha_inicio DATE,
    fecha_termino DATE
);

create table colaborador_periodo(
    colaborador_id INTEGER,
    periodo_id INTEGER,
    perfil_id INTEGER,
    FOREIGN KEY (colaborador_id) REFERENCES colaboradores(id),
    FOREIGN KEY (periodo_id) REFERENCES periodos(id),
    FOREIGN KEY (perfil_id) REFERENCES prefiles(id)
);

create table evaluadores(
    id INTEGER PRIMARY KEY autoincrement,
    colaborador_id INTEGER,
    periodo_id INTEGER,
    FOREIGN KEY (colaborador_id) REFERENCES colaboradores(id),
    FOREIGN KEY (periodo_id) REFERENCES periodos(id)
);

create table evaluaciones(
    id INTEGER PRIMARY KEY autoincrement,
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