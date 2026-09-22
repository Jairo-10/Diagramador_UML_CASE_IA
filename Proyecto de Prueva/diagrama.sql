-- ==========================================================
-- Script DDL generado automaticamente por UML Studio
-- Motor: PostgreSQL 17
-- Base de datos: uml_database
-- ==========================================================

CREATE TABLE Boletin (
  codigoVerificacion VARCHAR(255) PRIMARY KEY,
  fechaEmision DATE,
  id INT,
  promedioGeneral DECIMAL(12,2)
);

CREATE TABLE Calificacion (
  id SERIAL PRIMARY KEY,
  notaFinal DECIMAL(12,2),
  observacion VARCHAR(255),
  trimestre VARCHAR(255)
);

CREATE TABLE Curso (
  capacidadMax SERIAL PRIMARY KEY,
  id INT,
  nombre VARCHAR(255),
  turno VARCHAR(255)
);

CREATE TABLE Docente (
  apellido VARCHAR(255) PRIMARY KEY,
  especialidad VARCHAR(255),
  fechaContrato DATE,
  id INT,
  salario DECIMAL(12,2)
);

CREATE TABLE Estudiante (
  apellido VARCHAR(255) PRIMARY KEY,
  activo BOOLEAN,
  codigoRude VARCHAR(255),
  id INT,
  tutorContacto VARCHAR(255)
);

CREATE TABLE Inscripcion (
  costoMatricula DECIMAL(12,2),
  estado VARCHAR(255) PRIMARY KEY,
  fechaInscripcion TIMESTAMP,
  id INT,
  numeroFolio VARCHAR(255)
);

CREATE TABLE Materia (
  horasSemanales SERIAL PRIMARY KEY,
  id INT,
  nombre VARCHAR(255),
  sigla VARCHAR(255)
);

CREATE TABLE Persona (
  apellido VARCHAR(255) PRIMARY KEY,
  celular VARCHAR(255),
  ci VARCHAR(255),
  fechaNacimiento DATE,
  id INT,
  nombre VARCHAR(255)
);

ALTER TABLE Inscripcion
  ADD COLUMN boletin_id VARCHAR(255),
  ADD CONSTRAINT fk_inscripcion_boletin FOREIGN KEY (boletin_id) REFERENCES Boletin(codigoVerificacion) ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Calificacion
  ADD COLUMN inscripcion_id VARCHAR(255) NOT NULL,
  ADD CONSTRAINT fk_calificacion_inscripcion FOREIGN KEY (inscripcion_id) REFERENCES Inscripcion(estado) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Docente
  ADD COLUMN curso_id INT,
  ADD CONSTRAINT fk_docente_curso FOREIGN KEY (curso_id) REFERENCES Curso(capacidadMax) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Inscripcion
  ADD COLUMN curso_id INT,
  ADD CONSTRAINT fk_inscripcion_curso FOREIGN KEY (curso_id) REFERENCES Curso(capacidadMax) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Curso
  ADD COLUMN curso_id INT,
  ADD CONSTRAINT fk_curso_curso FOREIGN KEY (curso_id) REFERENCES Curso(capacidadMax) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE Docente_Materia (
  docente_id VARCHAR(255) NOT NULL,
  materia_id INT NOT NULL,
  PRIMARY KEY (docente_id, materia_id),
  CONSTRAINT fk_Docente_Materia_docente FOREIGN KEY (docente_id) REFERENCES Docente(apellido) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Docente_Materia_materia FOREIGN KEY (materia_id) REFERENCES Materia(horasSemanales) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE Docente
  ADD CONSTRAINT fk_docente_persona FOREIGN KEY (apellido) REFERENCES Persona(apellido) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Estudiante
  ADD CONSTRAINT fk_estudiante_persona FOREIGN KEY (apellido) REFERENCES Persona(apellido) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Inscripcion
  ADD COLUMN estudiante_id VARCHAR(255),
  ADD CONSTRAINT fk_inscripcion_estudiante FOREIGN KEY (estudiante_id) REFERENCES Estudiante(apellido) ON DELETE SET NULL ON UPDATE CASCADE;