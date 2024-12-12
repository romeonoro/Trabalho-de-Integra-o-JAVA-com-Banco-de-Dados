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
    nome VARCHAR(2) NOT NULL
);

-- Tabela de Salas
CREATE TABLE salas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(5) NOT NULL,
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

-- Trigger para impedir a inserção de matrículas duplicadas
DELIMITER $$

CREATE TRIGGER trg_impedir_matricula_duplicada
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    -- Verifica se a matrícula já existe na tabela de usuários
    IF EXISTS (SELECT 1 FROM usuarios WHERE matricula = NEW.matricula) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Matrícula já cadastrada!';
    END IF;
END$$

DELIMITER ;

-- Trigger para impedir a inserção de prédios com nomes duplicados
DELIMITER $$

CREATE TRIGGER trg_impedir_predio_duplicado
BEFORE INSERT ON predios
FOR EACH ROW
BEGIN
    -- Verifica se o nome do prédio já existe na tabela de prédios
    IF EXISTS (SELECT 1 FROM predios WHERE nome = NEW.nome) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Prédio com esse nome já cadastrado!';
    END IF;
END$$

DELIMITER ;

-- View para visualizar os itens emprestados com informações
CREATE VIEW vw_itens_emprestados AS
    SELECT 
        i.id AS item_id,
        i.nome AS item_nome,
        i.categoria,
        i.estado,
        u.nome AS usuario_nome,
        u.matricula,
        s.nome AS sala_nome,
        p.nome AS predio_nome
    FROM itens i
    JOIN usuarios u ON i.id_usuario = u.id
    JOIN salas s ON i.id_sala = s.id
    JOIN predios p ON s.id_predio = p.id
    WHERE i.estado = 'emprestado';
-- Utilizar a view
SELECT * FROM vw_itens_emprestados;

-- Devoluções Atrasadas
CREATE VIEW vw_itens_devolucoes_atrasadas AS
SELECT 
    la.item AS item_nome,
    la.dono AS usuario_nome,
    la.data_hora AS data_emprestimo,
    la.sala AS sala,
    la.predio AS predio,
    TIMESTAMPDIFF(DAY, la.data_hora, NOW()) AS dias_em_atraso
FROM log_acao la
JOIN (
    -- Subconsulta para pegar o registro mais recente de cada item
    SELECT item, MAX(data_hora) AS ultima_acao
    FROM log_acao
    GROUP BY item
) recentes ON la.item = recentes.item AND la.data_hora = recentes.ultima_acao
WHERE la.acao LIKE 'Alteração de Estado: atrasado'
ORDER BY dias_em_atraso DESC;


SELECT * FROM vw_itens_devolucoes_atrasadas;
