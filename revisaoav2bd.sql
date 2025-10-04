CREATE TABLE cargos (
	id serial primary key,
	cargo varchar,
	aumento numeric(7,2) 
);

INSERT INTO cargos (cargo, aumento) values ('diretor', 1000), ('coordenador', 500), ('professor', 200);

CREATE TABLE funcionarios (
	id serial primary key,
	nome varchar,
	salario numeric,
	cargo_id integer REFERENCES cargos(id),
	excluido boolean
);

INSERT INTO funcionarios (nome, salario, cargo_id, excluido) values ('Carlos', 2000, 3, true), ('João', 2500, 3, true), ('Thiago', 4000, 2, false), ('Marcio', 4300, 2, true), ('Diogo', 1200, 2, false), ('Maria', 5000, 1, true), ('Helena', 5000, 1, false);



Questão 1 – buscaFuncionariosByCargo
CREATE OR REPLACE PROCEDURE buscaFuncionariosByCargo(p_cargo VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    linha RECORD;
BEGIN
    RAISE NOTICE 'Funcionários com cargo %:', p_cargo;
	
	FOR linha IN
        SELECT f.id, f.nome, f.salario, c.cargo
        FROM funcionarios f
        JOIN cargos c ON f.cargo_id = c.id
        WHERE c.cargo = p_cargo
    LOOP
        RAISE NOTICE '% | % | %', linha.nome, linha.salario, linha.cargo;
    END LOOP;
END;
$$;
CALL buscaFuncionariosByCargo('professor');



Questão 2 – chequeSalario
CREATE OR REPLACE PROCEDURE chequeSalario(p_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_salario NUMERIC;
BEGIN
    SELECT salario INTO v_salario
    FROM funcionarios
    WHERE id = p_id;

    IF v_salario > 3999 THEN
        RAISE NOTICE 'É maior que 3999';
    ELSE
        RAISE NOTICE 'Não é maior que 3999';
    END IF;
END;
$$;
CALL chequeSalario(2); 
CALL chequeSalario(3); 



Questão 3 – aumenteSalario 
CREATE OR REPLACE PROCEDURE aumenteSalario(p_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_aumento NUMERIC;
BEGIN
    SELECT c.aumento INTO v_aumento
    FROM funcionarios f
    JOIN cargos c ON f.cargo_id = c.id
    WHERE f.id = p_id;

    UPDATE funcionarios
    SET salario = salario + v_aumento
    WHERE id = p_id;

    RAISE NOTICE 'Salário do funcionário % atualizado com aumento de %', p_id, v_aumento;
END;
$$;
CALL aumenteSalario(2); 



Questão 4 – popularBancoTeste
CREATE OR REPLACE PROCEDURE popularBancoTeste(p_qtd INT)
LANGUAGE plpgsql
AS $$
DECLARE
    i INT := 1;
    v_salario NUMERIC := 1000;
BEGIN
    WHILE i <= p_qtd LOOP
        INSERT INTO funcionarios (nome, salario, cargo_id, excluido)
        VALUES ('Funcionário Teste ' || i, v_salario, 3, TRUE);

        v_salario := v_salario + 200;
        i := i + 1;
    END LOOP;
END;
$$;
CALL popularBancoTeste(4);



Questão 5 – aumentaSalario (todos os funcionários
CREATE OR REPLACE PROCEDURE aumentaSalario()
LANGUAGE plpgsql
AS $$
BEGIN
    
    UPDATE funcionarios
    SET salario = salario * 1.20
    WHERE cargo_id = 1;

    UPDATE funcionarios
    SET salario = salario * 1.15
    WHERE cargo_id = 2;

    UPDATE funcionarios
    SET salario = salario * 1.10
    WHERE cargo_id = 3;

    RAISE NOTICE 'Salários atualizados de acordo com cargo';
END;
$$;
CALL aumentaSalario();

