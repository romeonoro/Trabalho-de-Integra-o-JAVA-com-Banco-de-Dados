CREATE DATABASE GerenciamentoEmprestimo
USE GerenciamentoEmprestimo

CREATE TABLE usuarios(

	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    matricula VARCHAR(10) NOT NULL,
    contato VARCHAR(14) NOT NULL 
    
);

CREATE TABLE predios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(10) NOT NULL
);

CREATE TABLE salas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(10) NOT NULL,
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
    item VARCHAR(50) NOT NULL,
    dono VARCHAR(50) NOT NULL,
    predio VARCHAR(50),
    sala VARCHAR(50),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);



-- ------ TRIGGER ATUALIZADO AQUI - IMPLEMENTAÇÃO 1
DELIMITER $$

CREATE TRIGGER trg_log_estado_update
AFTER UPDATE ON itens
FOR EACH ROW
BEGIN
    DECLARE usuario_nome VARCHAR(50);
    DECLARE predio_nome VARCHAR(50);
    DECLARE sala_nome VARCHAR(50);

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
    INSERT INTO log_acao (acao, item, descricao, dono, predio, sala)
    VALUES (
        CONCAT('Alteração de Estado: ', NEW.estado),
        NEW.nome,
        CONCAT(
            '" Alterado de "', OLD.estado, 
            '" para "', NEW.estado, '".'
        ),
        usuario_nome,
        predio_nome,
        sala_nome
    );
END$$

DELIMITER ;



-- ------- COLOCAR OUTRAS IMPLEMENTAÇÕES A PARTIR DAQUI
