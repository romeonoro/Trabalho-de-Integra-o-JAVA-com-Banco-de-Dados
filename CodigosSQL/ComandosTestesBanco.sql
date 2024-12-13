USE GerenciamentoEmprestimo

INSERT INTO usuarios (nome, matricula, contato) 
VALUES ('Vicenzo', '444444444', '559999999');

-- Inserir prédio
INSERT INTO predios (nome) 
VALUES ('1');

-- Inserir sala
INSERT INTO salas (nome, id_predio) 
VALUES ('303', 1);

-- Inserir item
INSERT INTO itens (nome, categoria, estado, id_sala, id_usuario) 
VALUES ('Chave Salão Branco', 'Chaves', 'Disponivel', 1, 1);

-- Atualizar estado do item
UPDATE itens
SET estado = 'Emprestado'
WHERE id = 1;

-- Verificar os resultados
SELECT * FROM log_acao
SELECT * FROM usuarios
SELECT * FROM itens
SELECT * FROM salas
SELECT * FROM predios



