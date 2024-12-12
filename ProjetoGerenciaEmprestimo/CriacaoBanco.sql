CREATE DATABASE GerenciamentoEmprestimo2
USE GerenciamentoEmprestimo2

CREATE TABLE usuarios(

    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    matricula VARCHAR(10) NOT NULL,
    contato VARCHAR(14) NOT NULL 
    
);

CREATE TABLE predios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(1) NOT NULL
);

CREATE TABLE salas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(3) NOT NULL,
    id_predio INT NOT NULL,
    FOREIGN KEY (id_predio) REFERENCES predios(id)
);

CREATE TABLE itens (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    estado VARCHAR(10) NOT NULL,
    id_sala INT,
    id_usuario INT,
    FOREIGN KEY (id_sala) REFERENCES salas(id),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);



CREATE TABLE log_acao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    acao VARCHAR(50) NOT NULL,
    descricao TEXT NOT NULL,
    dono_Local TEXT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------- Triggers
DELIMITER $$

CREATE TRIGGER trg_log_estado_update
AFTER UPDATE ON itens
FOR EACH ROW
BEGIN
    DECLARE usuario_nome VARCHAR(50);
    DECLARE predio_nome VARCHAR(1);
    DECLARE sala_nome VARCHAR(3);

    -- Busca o nome do usuário associado ao item
    SELECT nome 
    INTO usuario_nome
    FROM usuarios
    WHERE id = NEW.id_usuario;

    -- Busca o prédio e a sala associados ao item
    SELECT p.nome, s.nome
    INTO predio_nome, sala_nome
    FROM salas s
    JOIN predios p ON s.id_predio = p.id
    WHERE s.id = NEW.id_sala;

    -- Insere o log com as informações adicionais
    INSERT INTO log_acao (acao, descricao, dono_Local)
    VALUES (
        CONCAT('Alteração de Estado: ', NEW.estado),
        CONCAT(
            'Item "', NEW.nome, 
            '" alterado de "', OLD.estado, 
            '" para "', NEW.estado, '".'
        ),
        CONCAT(
            'Usuário: ', usuario_nome, 
            ', Local: Prédio ', predio_nome, 
            ', Sala ', sala_nome
        )
    );
END$$

DELIMITER ;


-- ------------------------------- TERMINA AQUI
