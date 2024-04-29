CREATE DATABASE curso_aula_udf
GO
USE curso_aula_udf
GO
CREATE TABLE curso
(
	codigo				INT				NOT NULL,
	nome				VARCHAR(50)		NOT NULL,
	duracao				INT				NOT NULL
	PRIMARY KEY (codigo)
)
GO
CREATE TABLE disciplina
(
	codigo				CHAR(6)			NOT NULL,
	nome				VARCHAR(50) 	NOT NULL,
	carga_horaria		INT 			NOT NULL
	PRIMARY KEY (codigo)
)
GO
CREATE TABLE curso_disciplina
(
	codigo_curso		INT 			NOT NULL,
	codigo_disciplina	CHAR(6) 		NOT NULL
	PRIMARY KEY (codigo_curso, codigo_disciplina)
	FOREIGN KEY (codigo_curso) REFERENCES curso (codigo),
	FOREIGN KEY (codigo_disciplina) REFERENCES disciplina (codigo)
)

SELECT * FROM disciplina

INSERT INTO curso (codigo, nome, duracao) VALUES (48, 'Análise e Desenvolvimento de Sistemas', 2880)
INSERT INTO curso (codigo, nome, duracao) VALUES (51, 'Logística', 2880)
INSERT INTO curso (codigo, nome, duracao) VALUES (67, 'Polímeros', 2880)
INSERT INTO curso (codigo, nome, duracao) VALUES (73, 'Comércio Exterior', 2600)
INSERT INTO curso (codigo, nome, duracao) VALUES (94, 'Gestão Empresarial', 2600)

INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('ALG001', 'Algoritmos', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('ADM001', 'Administração', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('LHW010', 'Laboratório de Hardware', 40)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('LPO001', 'Pesquisa Operacional', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('FIS003', 'Física I', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('FIS007', 'Físico Química', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('CMX001', 'Comércio Exterior', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('MKT002', 'Fundamentos de Marketing', 80)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('INF001', 'Informática', 40)
INSERT INTO disciplina (codigo, nome, carga_horaria) VALUES ('ASI001', 'Sistemas de Informação', 80)

INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ALG001', 48)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ADM001', 48)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ADM001', 51)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ADM001', 73)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ADM001', 94)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('LHW010', 48)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('LPO001', 51)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('FIS003', 67)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('FIS007', 67)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('CMX001', 51)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('CMX001', 73)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('MKT002', 51)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('MKT002', 94)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('INF001', 51)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('INF001', 73)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ASI001', 48)
INSERT INTO curso_disciplina (codigo_disciplina, codigo_curso) VALUES ('ASI001', 94)

CREATE FUNCTION fn_curso()
RETURNS @table TABLE
(
	codigo_disciplina			CHAR(6),
	nome_disciplina				VARCHAR(50),
	carga_horaria_disciplina	INT,
	nome_curso					VARCHAR(50)
)
AS
BEGIN
	DECLARE @codigo_disciplina			CHAR(6),
			@nome_disciplina			VARCHAR(50),
			@carga_horaria_disciplina	INT,
			@nome_curso					VARCHAR(50)
	DECLARE c CURSOR FOR
		SELECT d.codigo, d.nome, d.carga_horaria, c.nome FROM curso c, disciplina d, curso_disciplina cd
		WHERE c.codigo = cd.codigo_curso
			AND d.codigo = cd.codigo_disciplina
	OPEN c
	FETCH NEXT FROM c
		INTO @codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @table 
		VALUES
		(@codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso)
		
		FETCH NEXT FROM c
			INTO @codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso
	END
	CLOSE c
	DEALLOCATE c
	RETURN
END

SELECT * FROM fn_curso() 
