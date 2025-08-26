
CREATE DATABASE db_revenda_julia;


CREATE TABLE clientes (
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE produtos (
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    estoque INT NOT NULL DEFAULT 0 CHECK (estoque >= 0)
);

CREATE TABLE fornecedores (
    id serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cidade VARCHAR(50) NOT NULL
);

CREATE TABLE vendas (
    id serial PRIMARY KEY,
    clientes_id INT NOT NULL,
    data_venda DATE NOT NULL DEFAULT CURRENT_DATE,
    valor_total DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pendente',
    CONSTRAINT fk_vendas_clientes FOREIGN KEY (clientes_id) REFERENCES clientes(id),
    CONSTRAINT chk_status CHECK (status IN ('pendente','pago','cancelado'))
);

CREATE TABLE itens_venda (
	id serial primary key,
    vendas_id INT NOT NULL,
    produtos_id INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_venda DECIMAL(10,2) NOT NULL CHECK (preco_venda > 0),
    CONSTRAINT fk_itens_venda_vendas FOREIGN KEY (vendas_id) REFERENCES vendas(id),
    CONSTRAINT fk_itens_venda_produtos FOREIGN KEY (produtos_id) REFERENCES produtos(id)
);

CREATE TABLE pagamentos (
    id serial PRIMARY KEY,
    vendas_id INT NOT NULL,
    data_pagamento DATE NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL CHECK (valor_pago > 0),
    forma_pagto VARCHAR(20) NOT NULL,
    CONSTRAINT fk_pagamentos_vendas FOREIGN KEY (vendas_id) REFERENCES vendas(id),
    CONSTRAINT chk_forma_pagto CHECK (forma_pagto IN ('cartão','boleto','dinheiro'))
);



CREATE VIEW view_vendas_detalhadas AS
SELECT v.id, c.nome AS cliente, v.data_venda, v.valor_total, v.status,
       p.nome AS produto, iv.quantidade, iv.preco_venda
FROM vendas v
JOIN clientes c ON v.clientes_id = c.id
JOIN itens_venda iv ON v.id = iv.vendas_id
JOIN produtos p ON iv.produtos_id = p.id;

CREATE VIEW view_pagamentos_resumo AS
SELECT p.id as pagamento_id, v.id, c.nome AS cliente, p.data_pagamento, p.valor_pago, p.forma_pagto
FROM pagamentos p
JOIN vendas v ON p.vendas_id = v.id
JOIN clientes c ON v.clientes_id = c.id;


INSERT INTO clientes (nome, email, telefone) 
values ('João Silva', 'joao@email.com', '11999998888'),
('Maria Souza', 'maria@email.com', '11988887777'),
('Carlos Pereira', 'carlos@email.com', '11977776666'),
('Ana Lima', 'ana.lima@email.com', '11966665555'),
('Pedro Alves', 'pedro.alves@email.com', '11955554444'),
('Mariana Rocha', 'mariana.rocha@email.com', '11944443333'),
('Felipe Costa', 'felipe.costa@email.com', '11933332222'),
('Laura Mendes', 'laura.mendes@email.com', '11922221111'),
('Ricardo Dias', 'ricardo.dias@email.com', '11911110000'),
('Beatriz Nunes', 'beatriz.nunes@email.com', '11900009999');


INSERT INTO produtos (nome, descricao, preco_unitario, estoque) 
values ('Prancha de Surf', 'Prancha de fibra para surfistas iniciantes', 1200.00, 10),
('Roupa de Neoprene', 'Roupa para mergulho até 5mm', 450.50, 20),
('Óculos de Mergulho', 'Óculos antiembaçante', 150.75, 15),
('Barco Inflável', 'Barco para lazer em lagoa', 3000.00, 5),
('Coletes Salva-vidas', 'Coletes para segurança', 200.00, 50),
('Remo Ajustável', 'Remo para canoagem', 350.00, 25),
('Caiaque', 'Caiaque para uso recreativo', 1800.00, 8),
('Snorkel', 'Snorkel para mergulho', 100.00, 40),
('Bóia de Resgate', 'Bóia para emergências', 250.00, 12),
('Câmera à prova d’água', 'Para filmagens subaquáticas', 900.00, 7);


INSERT INTO fornecedores (nome, telefone, email, cidade)
values ('AquaSports Ltda', '1133334444', 'contato@aquasports.com', 'São Paulo'),
('Mergulhador Pro', '1144445555', 'vendas@mergulhadopro.com', 'Rio de Janeiro'),
('Esportes Náuticos', '1155556666', 'contato@esportesnauticos.com', 'Porto Alegre'),
('Vida Aquática', '1166667777', 'contato@vidaaquatica.com', 'Curitiba'),
('Oceanic Supply', '1177778888', 'oceanic@supply.com', 'Florianópolis'),
('Nautic Brasil', '1188889999', 'contato@nauticbrasil.com', 'Recife'),
('Mundo Mar', '1199990000', 'mundo.mar@email.com', 'Fortaleza'),
('Aqua Equipamentos', '1112223333', 'equipamentos@aqua.com', 'Salvador'),
('Blue Water', '1122334455', 'contato@bluewater.com', 'Natal'),
('Mar Profundo', '1133445566', 'marprofundo@email.com', 'Belém');


INSERT INTO vendas (clientes_id, data_venda, valor_total, status)
values (1, '2025-08-01', 1500.00, 'pago'),
(2, '2025-08-02', 450.50, 'pendente'),
(3, '2025-08-03', 3000.00, 'pago'),
(4, '2025-08-04', 200.00, 'cancelado'),
(5, '2025-08-05', 350.00, 'pago'),
(6, '2025-08-06', 1800.00, 'pago'),
(7, '2025-08-07', 100.00, 'pendente'),
(8, '2025-08-08', 250.00, 'pago'),
(9, '2025-08-09', 900.00, 'pago'),
(10, '2025-08-10', 1200.00, 'pendente');


INSERT INTO itens_venda (vendas_id, produtos_id, quantidade, preco_venda)
values (1, 1, 1, 1200.00),
(1, 3, 2, 150.00),
(2, 2, 1, 450.50),
(3, 4, 1, 3000.00),
(4, 5, 1, 200.00),
(5, 6, 1, 350.00),
(6, 7, 1, 1800.00),
(7, 8, 1, 100.00),
(8, 9, 1, 250.00),
(9, 10, 1, 900.00);


INSERT INTO pagamentos (vendas_id, data_pagamento, valor_pago, forma_pagto)
values (1, '2025-08-02', 1500.00, 'cartão'),
(3, '2025-08-04', 3000.00, 'boleto'),
(5, '2025-08-06', 350.00, 'dinheiro'),
(6, '2025-08-07', 1800.00, 'cartão'),
(8, '2025-08-09', 250.00, 'boleto'),
(9, '2025-08-10', 900.00, 'dinheiro'),
(2, '2025-08-12', 450.50, 'cartão'),
(7, '2025-08-14', 100.00, 'dinheiro'),
(4, '2025-08-15', 200.00, 'boleto'),
(10, '2025-08-16', 1200.00, 'cartão');



SELECT * FROM view_vendas_detalhadas;

SELECT * FROM view_pagamentos_resumo;
