CREATE DATABASE aula_trigger_atividade;

CREATE TABLE setores (
	id serial primary key,
	setor varchar,
	total_funcionarios integer default(0)
);

INSERT INTO setores (setor) VALUES 
('RH'), 
('Financeiro'), 
('Acadêmico'), 
('Reitoria'), 
('Almoxarifado');

CREATE TABLE empregados (
	id serial primary key,
	nome varchar,
	salario numeric,
	setor_id integer REFERENCES setores(id)
);

INSERT INTO empregados (nome, salario, setor_id) VALUES 
('Arthur', 2314.50, 1), 
('Alice', 3000.00, 1), 
('Sophia', 1500.00, 2), 
('Júlia', 2000.00, 2), 
('Pedro', 1000.50, 3), 
('Antonio', 1888.90, 3), 
('Marcos', 5000.00, 4), 
('Lais', 3450.30, 4), 
('Monica', 3333.33, 5), 
('Eduardo', 1543.00, 5);

CREATE TABLE logs_empregados (
	empregado_id integer,
	usuario varchar,
	operacao varchar,
	data_operacao timestamp
);


CREATE OR REPLACE FUNCTION zerarTotalFuncionarios()
RETURNS TRIGGER AS $$
BEGIN
    NEW.total_funcionarios := 0;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_zerar_total_funcionarios
BEFORE INSERT ON setores
FOR EACH ROW
EXECUTE FUNCTION zerarTotalFuncionarios();


CREATE OR REPLACE FUNCTION limitarSalario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salario < 937 THEN
        NEW.salario := 937;
    ELSIF NEW.salario > 10000 THEN
        NEW.salario := 10000;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_limitar_salario
BEFORE INSERT OR UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION limitarSalario();


CREATE OR REPLACE FUNCTION atualizarTotalFuncionarios()
RETURNS TRIGGER AS $$
DECLARE
    v_total INT;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM empregados
    WHERE setor_id = COALESCE(NEW.setor_id, OLD.setor_id);

    UPDATE setores
    SET total_funcionarios = v_total
    WHERE id = COALESCE(NEW.setor_id, OLD.setor_id);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_total_funcionarios
AFTER INSERT OR DELETE ON empregados
FOR EACH ROW
EXECUTE FUNCTION atualizarTotalFuncionarios();


CREATE OR REPLACE FUNCTION logOperacoesEmpregados()
RETURNS TRIGGER AS $$
DECLARE
    v_operacao VARCHAR(50);
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_operacao := 'INSERINDO USUARIO';
        INSERT INTO logs_empregados(empregador_id, usuario, operacao, data_operacao)
        VALUES (NEW.id, USER, v_operacao, NOW());
    ELSIF TG_OP = 'UPDATE' THEN
        v_operacao := 'ATUALIZANDO USUARIO';
        INSERT INTO logs_empregados(empregador_id, usuario, operacao, data_operacao)
        VALUES (NEW.id, USER, v_operacao, NOW());
    ELSIF TG_OP = 'DELETE' THEN
        v_operacao := 'DELETANDO USUARIO';
        INSERT INTO logs_empregados(empregador_id, usuario, operacao, data_operacao)
        VALUES (OLD.id, USER, v_operacao, NOW());
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_operacoes_empregados
AFTER INSERT OR UPDATE OR DELETE ON empregados
FOR EACH ROW
EXECUTE FUNCTION logOperacoesEmpregados();


CREATE OR REPLACE FUNCTION impedirAlteracaoUsuario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.usuario <> OLD.usuario THEN
        RAISE EXCEPTION 'Não é permitido alterar o nome do usuário!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impedir_alteracao_usuario
BEFORE UPDATE ON logs_empregados
FOR EACH ROW
EXECUTE FUNCTION impedirAlteracaoUsuario();



