SELECT * FROM clientes
WHERE nome LIKE 'Maria%'; -- seleciona todos os clientes que o nome começa com "Maria"

EXPLAIN SELECT *  FROM clientes
WHERE nome LIKE 'Maria%'; -- mostra como o banco executa a busca

CREATE INDEX idx_clientes_nome ON clientes(nome); -- cria um índice para a coluna nome, acelerando as buscas 

EXPLAIN SELECT * FROM clientes
WHERE nome LIKE 'Maria%'; -- no primeiro ele leva quase 12 segundos para carregar, ja no segundo, após criar o index ele carrega em menos de 2 segundos


ALTER TABLE clientes 
ALTER COLUMN telefone TYPE INT USING telefone::INT; --deu erro porque alguns números do telefone têm mais dígitos que o INT suporta

ALTER TABLE produtos 
ALTER COLUMN estoque TYPE VARCHAR(10);-- eu e o professor carlos nao conseguimos identificar o que esse erro significa, print estará no github


CREATE USER julia WITH PASSWORD '123456';
GRANT ALL PRIVILEGES ON DATABASE db_revenda_julia TO julia;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO julia;-- cria o usuário julia(eu) que dá acesso total ao banco e tabelas

CREATE USER colega WITH PASSWORD '123456';
GRANT SELECT ON clientes TO colega; -- cria usuário tabela que só pode CONSULTAR (SELECT) a tabale clientes 

--Refaça todos os items no usuário que criou para seu colega, registre tudo que ocorreu (erros e acertos).
--criei uma nova conexão postgres e entrei com o usuário colega para realizar os itens
--o terceiro e o quinto não executaram pois é necessario ser dono da tabela clientes e o usuário colega não é
--o sexto não executou pois tambem precisa ser dono da tabela produtos
--os demais executaram normalmente pois há permissão para que o usuário colega realize tais select


SELECT v.id, c.nome, v.valor_total 
FROM vendas v
INNER JOIN clientes c ON v.clientes_id = c.id; 

SELECT v.id, c.nome, v.valor_total 
FROM vendas v
LEFT JOIN clientes c ON v.clientes_id = c.id;

SELECT v.id, c.nome, v.valor_total 
FROM vendas v
RIGHT JOIN clientes c ON v.clientes_id = c.id;


SELECT v.id, v.valor_total, p.valor_pago 
FROM vendas v
INNER JOIN pagamentos p ON v.id = p.vendas_id;


SELECT v.id, v.valor_total, p.valor_pago 
FROM vendas v
LEFT JOIN pagamentos p ON v.id = p.vendas_id;


SELECT v.id, v.valor_total, p.valor_pago 
FROM vendas v
RIGHT JOIN pagamentos p ON v.id = p.vendas_id;


SELECT iv.id, p.nome, iv.quantidade 
FROM itens_venda iv
INNER JOIN produtos p ON iv.produtos_id = p.id;


SELECT iv.id, p.nome, iv.quantidade 
FROM itens_venda iv
LEFT JOIN produtos p ON iv.produtos_id = p.id;


SELECT iv.id, p.nome, iv.quantidade 
FROM itens_venda iv
RIGHT JOIN produtos p ON iv.produtos_id = p.id;


SELECT f.nome, p.nome 
FROM fornecedores f
INNER JOIN produtos p ON f.id = p.id;


SELECT f.nome, p.nome 
FROM fornecedores f
LEFT JOIN produtos p ON f.id = p.id;


SELECT f.nome, p.nome 
FROM fornecedores f
RIGHT JOIN produtos p ON f.id = p.id;

--inner join traz só registros que têm relação nas duas tabelas 
--left join traz todos da esquerda (ex: todas vendas), mesmo sem cliente correspondente
--right join traz todos da direita (ex: todos clientes), mesmo sem venda correspondente

alter table clientes alter column telefone drop not null;

UPDATE clientes SET telefone = NULL WHERE id IN (1,2,3); -- atualiza a tabela clientes e torna nulo o numero de telefone dos clientes em que o id é 1, 2 e 3
 
--execute as consultas com Join novamente, avalie os resultados.
--inner join ignora os nulos, left e right continuam exibindo registros, mas com colunas null onde nao tem valor
