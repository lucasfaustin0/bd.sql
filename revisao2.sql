CREATE TABLE secoes (
    id SERIAL PRIMARY KEY,
    secao VARCHAR(50) NOT NULL,
    ativa CHAR(1) DEFAULT 'S'
);

CREATE TABLE autores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(50) NOT NULL
);

CREATE TABLE noticias (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    data_postagem DATE NOT NULL,
    descricao VARCHAR(150),
    autor_id INT REFERENCES autores(id),
    secao_id INT REFERENCES secoes(id)
);

INSERT INTO autores (nome, email, senha) VALUES ('Carlos', 'carlos@email.com', '123');
INSERT INTO autores (nome, email, senha) VALUES ('Maria', 'maria@email.com', '123');
INSERT INTO autores (nome, email, senha) VALUES ('João', 'joao@email.com', '123');

INSERT INTO secoes (secao, ativa) VALUES ('Culinária', 'S');
INSERT INTO secoes (secao, ativa) VALUES ('Moda', 'S');
INSERT INTO secoes (secao, ativa) VALUES ('Esporte', 'S');

INSERT INTO noticias (titulo, descricao, data_postagem, secao_id, autor_id)
VALUES ('Fazendo Pão', 'Descrição 1', '2018-09-17', 1, 1);

INSERT INTO noticias (titulo, descricao, data_postagem, secao_id, autor_id)
VALUES ('Limpando o Rosto', 'Descrição 2', '2017-10-20', 2, 2);

INSERT INTO noticias (titulo, descricao, data_postagem, secao_id, autor_id)
VALUES ('X vence partida', 'Descrição 3', '2020-05-14', 3, 3);

INSERT INTO noticias (titulo, descricao, data_postagem, secao_id, autor_id)
VALUES ('Pavê de Limão', 'Descrição 4', '2015-11-28', 1, 1);

INSERT INTO noticias (titulo, descricao, data_postagem, secao_id, autor_id)
VALUES ('Acabando Espinhas', 'Descrição 5', '2009-04-22', 2, 2);

CREATE INDEX idx_noticias_data
ON noticias (data_postagem);

CREATE USER admin WITH PASSWORD 'admin';
ALTER USER admin WITH SUPERUSER;

CREATE USER revisor WITH PASSWORD '123456';
GRANT SELECT, UPDATE ON noticias TO revisor;

CREATE OR REPLACE VIEW noticias_vw AS
SELECT 
    n.titulo,
    n.descricao,
    n.data_postagem,
    s.secao,
    a.nome AS autor
FROM noticias n
JOIN secoes s ON n.secao_id = s.id
JOIN autores a ON n.autor_id = a.id;
