-- Cria o banco de dados para gerenciamento de empréstimos
CREATE DATABASE GerenciamentoEmprestimo;
USE GerenciamentoEmprestimo;

-- Tabela de usuários para armazenar informações dos usuários que realizam os empréstimos
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,    -- Identificador único do usuário
    nome VARCHAR(50) NOT NULL,            -- Nome do usuário
    matricula VARCHAR(10) NOT NULL,       -- Matrícula do usuário
    contato VARCHAR(14) NOT NULL          -- Contato do usuário
);

-- Tabela de prédios onde os itens estão localizados
CREATE TABLE predios (
    id INT PRIMARY KEY AUTO_INCREMENT,    -- Identificador único do prédio
    nome VARCHAR(1) NOT NULL              -- Nome do prédio (ex: '1', '3')
);

-- Tabela de salas dentro dos prédios
CREATE TABLE salas (
    id INT PRIMARY KEY AUTO_INCREMENT,    -- Identificador único da sala
    nome VARCHAR(3) NOT NULL,             -- Nome da sala (ex: '101', '102')
    id_predio INT NOT NULL,               -- ID do prédio ao qual a sala pertence
    FOREIGN KEY (id_predio) REFERENCES predios(id) -- Chave estrangeira referenciando a tabela de prédios
);

-- Tabela de itens que podem ser emprestados
CREATE TABLE itens (
    id INT PRIMARY KEY AUTO_INCREMENT,    -- Identificador único do item
    nome VARCHAR(50) NOT NULL,            -- Nome do item (ex: 'Chave da sala 102')
    categoria VARCHAR(50) NOT NULL,       -- Categoria do item (ex: 'Sala', 'Controle')
    estado VARCHAR(10) NOT NULL,          -- Estado do item (ex: 'disponível', 'emprestado')
    id_sala INT,                          -- ID da sala onde o item está localizado
    id_usuario INT,                       -- ID do usuário associado ao item emprestado
    FOREIGN KEY (id_sala) REFERENCES salas(id),    -- Chave estrangeira referenciando a tabela de salas
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) -- Chave estrangeira referenciando a tabela de usuários
);

-- Tabela de log de ações para registrar alterações e atividades realizadas nos itens
CREATE TABLE log_acao (
    id INT PRIMARY KEY AUTO_INCREMENT,    -- Identificador único do log
    acao VARCHAR(50) NOT NULL,            -- Tipo de ação realizada (ex: 'Empréstimo', 'Devolução')
    descricao TEXT NOT NULL,              -- Descrição detalhada da ação
    dono_Local TEXT NOT NULL,             -- Informações sobre o usuário e a localização associada à ação
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP -- Data e hora em que a ação foi registrada
);

-- Trigger para registrar alterações no estado dos itens na tabela de log
DELIMITER $$

CREATE TRIGGER trg_log_estado_update
AFTER UPDATE ON itens
FOR EACH ROW
BEGIN
    DECLARE usuario_nome VARCHAR(50);     -- Variável para armazenar o nome do usuário
    DECLARE predio_nome VARCHAR(1);       -- Variável para armazenar o nome do prédio
    DECLARE sala_nome VARCHAR(3);         -- Variável para armazenar o nome da sala

    -- Busca o nome do usuário associado ao item atualizado
    SELECT nome INTO usuario_nome
    FROM usuarios
    WHERE id = NEW.id_usuario;

    -- Busca o nome do prédio e da sala associados ao item atualizado
    SELECT p.nome, s.nome
    INTO predio_nome, sala_nome
    FROM salas s
    JOIN predios p ON s.id_predio = p.id
    WHERE s.id = NEW.id_sala;

    -- Insere um registro no log com as informações da alteração
    INSERT INTO log_acao (acao, descricao, dono_Local)
    VALUES (
        CONCAT('Alteração de estado: ', NEW.estado),
        CONCAT('Item "', NEW.nome, '" alterado de "', OLD.estado, '" para "', NEW.estado, '".'),
        CONCAT('Usuário: ', usuario_nome, ', Local: Prédio ', predio_nome, ', Sala ', sala_nome)
    );
END$$

DELIMITER ;

-- Procedure para realizar empréstimos de itens
DELIMITER $$

CREATE PROCEDURE EmprestarItem (
    IN p_item_id INT,     -- ID do item a ser emprestado
    IN p_usuario_id INT,  -- ID do usuário que está pegando o item emprestado
    IN p_sala_id INT      -- ID da sala onde o item está sendo alocado
)
BEGIN
    DECLARE item_estado VARCHAR(10); -- Variável para armazenar o estado atual do item

    -- Verifica o estado atual do item
    SELECT estado INTO item_estado FROM itens WHERE id = p_item_id;

    -- Verifica se o item está disponível para empréstimo
    IF item_estado = 'disponível' THEN
        -- Atualiza o estado do item para "emprestado" e associa ao usuário e à sala
        UPDATE itens 
        SET estado = 'emprestado',
            id_usuario = p_usuario_id,
            id_sala = p_sala_id
        WHERE id = p_item_id;

        -- Insere um registro no log da ação de empréstimo
        INSERT INTO log_acao (acao, descricao, dono_Local)
        VALUES (
            'Empréstimo',
            CONCAT('Item "', p_item_id, '" emprestado para usuário "', p_usuario_id, '".'),
            CONCAT('Local: Sala ', p_sala_id)
        );

    ELSE
        -- Lança um erro se o item não estiver disponível
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item não está disponível para empréstimo.';
    END IF;
END$$

DELIMITER ;

-- Procedure com transaction para realizar devolução de itens
DELIMITER $$

CREATE PROCEDURE DevolverItem (
    IN p_item_id INT -- ID do item a ser devolvido
)
BEGIN
    -- Handler para tratar erros e realizar rollback em caso de falha
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao processar a devolução.';
    END;

    START TRANSACTION;

    -- Atualiza o estado do item para "disponível" e remove associações de usuário e sala
    UPDATE itens 
    SET estado = 'disponível',
        id_usuario = NULL,
        id_sala = NULL
    WHERE id = p_item_id;

    -- Insere um registro no log da ação de devolução
    INSERT INTO log_acao (acao, descricao, dono_Local)
    VALUES (
        'Devolução',
        CONCAT('Item "', p_item_id, '" foi devolvido.'),
        'Local: N/A'
    );

    COMMIT;
END$$

DELIMITER ;

-- Trigger para validar o estado dos itens antes de atualizar
DELIMITER $$

CREATE TRIGGER trg_validar_estado_update
BEFORE UPDATE ON itens
FOR EACH ROW
BEGIN
    -- Verifica se o novo estado é válido (apenas 'disponível' ou 'emprestado')
    IF NEW.estado NOT IN ('disponível', 'emprestado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado inválido. Os estados permitidos são: "disponível" ou "emprestado".';
    END IF;
END$$

DELIMITER ;
