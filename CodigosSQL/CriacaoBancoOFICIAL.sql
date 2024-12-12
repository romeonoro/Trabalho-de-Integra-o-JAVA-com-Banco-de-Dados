-- Cria o banco de dados
CREATE DATABASE GerenciamentoEmprestimo;
USE GerenciamentoEmprestimo;

-- Tabela de Usuarios
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    matricula VARCHAR(10) NOT NULL,
    contato VARCHAR(14) NOT NULL
);

-- Tabela de Predios
CREATE TABLE predios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(1) NOT NULL
);

-- Tabela de Salas
CREATE TABLE salas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(3) NOT NULL,
    id_predio INT NOT NULL,
    FOREIGN KEY (id_predio) REFERENCES predios(id)
);

-- Tabela de Itens
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

-- Tabela de Log de Ações
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

-- Trigger para Log de Alteração no Estado dos Itens
DELIMITER $$

CREATE TRIGGER trg_log_estado_update
AFTER UPDATE ON itens
FOR EACH ROW
BEGIN
    DECLARE usuario_nome VARCHAR(50);
    DECLARE predio_nome VARCHAR(50);
    DECLARE sala_nome VARCHAR(50);

    -- Busca o nome do usuário associado ao item
    SELECT nome INTO usuario_nome
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
        CONCAT('" Alterado de "', OLD.estado, '" para "', NEW.estado, '".'),
        usuario_nome,
        predio_nome,
        sala_nome
    );
END$$

DELIMITER ;

-- Procedure para Emprestar Item
DELIMITER $$

CREATE PROCEDURE EmprestarItem (
    IN p_item_id INT,
    IN p_usuario_id INT,
    IN p_sala_id INT
)
BEGIN
    DECLARE item_estado VARCHAR(10);

    -- Verifica o estado atual do item
    SELECT estado INTO item_estado FROM itens WHERE id = p_item_id;

    -- Verifica se o item está disponível
    IF item_estado = 'disponivel' THEN
        -- Atualiza o estado do item para 'emprestado'
        UPDATE itens 
        SET estado = 'emprestado',
            id_usuario = p_usuario_id,
            id_sala = p_sala_id
        WHERE id = p_item_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item não está disponível para empréstimo.';
    END IF;
END$$

DELIMITER ;

-- Procedure com Transaction para Devolução de Item
DELIMITER $$

CREATE PROCEDURE DevolverItem (
    IN p_item_id INT
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao processar a devolução.';
    END;

    START TRANSACTION;

    -- Atualiza o estado do item para 'disponivel'
    UPDATE itens 
    SET estado = 'disponivel',
        id_usuario = NULL,
        id_sala = NULL
    WHERE id = p_item_id;

    COMMIT;
END$$

DELIMITER ;
