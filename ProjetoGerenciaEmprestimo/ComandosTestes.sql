USE GerenciamentoEmprestimo

-- Inserir usuários
INSERT INTO usuarios (nome, matricula, contato) VALUES 
('Bruno Difante', '12345678', '1111-1111'),
(`'Matheus Nogueira', '23456789', '2222-2222');

-- Inserir prédios
INSERT INTO predios (nome) VALUES 
('1'), 
('3');

-- Inserir salas
INSERT INTO salas (nome, id_predio) VALUES 
('101', 1), 
('102', 1), 
('201', 2);

-- Inserir itens
INSERT INTO itens (nome, categoria, estado) VALUES 
('Livro de Redes', 'Livro', 'disponivel'),
('Projetor Epson', 'Equipamento', 'disponivel');

-- Emprestar um Item
CALL EmprestarItem(1, 1, 1);

-- Devolver um Item
CALL DevolverItem(1);

-- Verificar os Itens
SELECT * FROM itens;

-- Verificar o Log de Ações
SELECT * FROM log_acao;

