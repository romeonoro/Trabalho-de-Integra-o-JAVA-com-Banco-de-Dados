USE GerenciamentoEmprestimo

INSERT INTO usuarios (nome, matricula, contato) 
VALUES ('João', '222222222', '559999999');

-- Inserir prédio
INSERT INTO predios (nome) 
VALUES ('3');

-- Inserir sala
INSERT INTO salas (nome, id_predio) 
VALUES ('303', 1);

-- Inserir item
INSERT INTO itens (nome, categoria, estado, id_sala, id_usuario) 
VALUES ('Chave Salão Azul', 'Chaves', 'Disponivel', 1, 1);

UPDATE itens
SET estado = 'Emprestado'
WHERE id = 11;

SELECT * FROM log_acao
