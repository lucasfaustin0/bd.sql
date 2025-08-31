CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    categoria VARCHAR(50)
);

CREATE TABLE telefones (
    id SERIAL PRIMARY KEY,
    telefone VARCHAR(20),
    cliente_id INTEGER REFERENCES clientes(id)
);

CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    produto VARCHAR(50),
    preco NUMERIC(10, 2),
    categoria_id INTEGER REFERENCES categorias(id)
);

CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(id),
    total NUMERIC(10, 2)
);

CREATE TABLE vendas_produtos (
    venda_id INT REFERENCES vendas(id),
    produto_id INT REFERENCES produtos(id),
    PRIMARY KEY (venda_id, produto_id)
);

INSERT INTO clientes (nome) VALUES
('Cliente 1'),
('Cliente 2'),
('Cliente 3');

INSERT INTO telefones (telefone, cliente_id) VALUES
('99999-9999', 1),
('88888-8888', 1),
('77777-7777', 2),
('66666-6666', 3),
('55555-5555', 3);

INSERT INTO categorias (categoria) VALUES
('Papelaria'),
('Informática'),
('Alimentação');

INSERT INTO produtos (produto, preco, categoria_id) VALUES
('Caneta', 1.00, 1),
('Caderno', 10.00, 1),
('Pendriver', 20.00, 2),
('Mouse', 35.50, 2),
('Leite', 5.80, 3);

UPDATE produtos
SET preco = preco * 1.30
WHERE categoria_id = (SELECT id FROM categorias WHERE categoria = 'Papelaria');

INSERT INTO vendas (cliente_id, total)
VALUES (
    1,
    (SELECT SUM(preco) FROM produtos WHERE id IN (1, 4))
);

INSERT INTO vendas_produtos (venda_id, produto_id)
VALUES (1, 1),
       (1, 4);

SELECT c.nome, t.telefone
FROM clientes c
JOIN telefones t ON c.id = t.cliente_id; 

