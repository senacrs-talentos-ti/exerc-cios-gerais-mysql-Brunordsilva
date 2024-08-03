USE mercado;

CREATE TABLE CLIENTES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

USE mercado;

CREATE TABLE PRODUTOS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
);

USE mercado;

CREATE TABLE PEDIDOS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES CLIENTES(id)
);

USE mercado;

CREATE TABLE ITENS_PEDIDO (
    pedido_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (pedido_id, produto_id),
    FOREIGN KEY (pedido_id) REFERENCES PEDIDOS(id),
    FOREIGN KEY (produto_id) REFERENCES PRODUTOS(id)
);

USE mercado;

INSERT INTO CLIENTES (nome, email) VALUES
('luis', 'luis@gmail.com'),
('ana', 'ana@gmail.com');

INSERT INTO PRODUTOS (nome, preco) VALUES
('tv', 1200.00),
('Mouse', 25.50);

USE mercado;

INSERT INTO PEDIDOS (cliente_id, data_pedido, total) VALUES
(1, '2024-07-01', 1225.50),
(2, '2024-07-05', 1200.00);

USE mercado;

INSERT INTO ITENS_PEDIDO (pedido_id, produto_id, quantidade, preco) VALUES
(1, 1, 1, 1200.00),
(1, 2, 1, 25.50),
(2, 1, 1, 1200.00);

USE mercado;

UPDATE PRODUTOS
SET preco = 1300.00
WHERE id = 1;

UPDATE ITENS_PEDIDO
JOIN PRODUTOS ON ITENS_PEDIDO.produto_id = PRODUTOS.id
SET ITENS_PEDIDO.preco = PRODUTOS.preco
WHERE PRODUTOS.id = 1;

USE mercado;

DELETE FROM CLIENTES
WHERE id = 1;

DELETE FROM ITENS_PEDIDO
WHERE pedido_id IN (SELECT id FROM PEDIDOS WHERE cliente_id = 1);

DELETE FROM PEDIDOS
WHERE cliente_id = 1;

USE mercado;

ALTER TABLE CLIENTES
ADD COLUMN data_nascimento DATE;

USE mercado;

SELECT PEDIDOS.id AS id_pedido, CLIENTES.nome AS nome_cliente, PRODUTOS.nome AS nome_produto
FROM PEDIDOS
JOIN CLIENTES ON PEDIDOS.cliente_id = CLIENTES.id
JOIN ITENS_PEDIDO ON PEDIDOS.id = ITENS_PEDIDO.pedido_id
JOIN PRODUTOS ON ITENS_PEDIDO.produto_id = PRODUTOS.id;

USE mercado;

SELECT CLIENTES.nome AS nome_cliente, PEDIDOS.id AS id_pedido, PEDIDOS.data_pedido
FROM CLIENTES
LEFT JOIN PEDIDOS ON CLIENTES.id = PEDIDOS.cliente_id;

USE mercado;

SELECT PRODUTOS.nome AS nome_produto, PEDIDOS.id AS id_pedido
FROM PRODUTOS
RIGHT JOIN ITENS_PEDIDO ON PRODUTOS.id = ITENS_PEDIDO.produto_id
RIGHT JOIN PEDIDOS ON ITENS_PEDIDO.pedido_id = PEDIDOS.id;

USE mercado;

SELECT SUM(total) AS total_vendas, SUM(quantidade) AS total_itens_vendidos
FROM (
    SELECT PEDIDOS.total, SUM(ITENS_PEDIDO.quantidade) AS quantidade
    FROM PEDIDOS
    JOIN ITENS_PEDIDO ON PEDIDOS.id = ITENS_PEDIDO.pedido_id
    GROUP BY PEDIDOS.id
) AS resumo_vendas;

USE mercado;

SELECT CLIENTES.nome AS nome_cliente, COUNT(PEDIDOS.id) AS total_pedidos
FROM CLIENTES
LEFT JOIN PEDIDOS ON CLIENTES.id = PEDIDOS.cliente_id
GROUP BY CLIENTES.id
ORDER BY total_pedidos DESC;

USE mercado;

SELECT PRODUTOS.nome AS nome_produto, SUM(ITENS_PEDIDO.quantidade) AS total_quantidade
FROM PRODUTOS
LEFT JOIN ITENS_PEDIDO ON PRODUTOS.id = ITENS_PEDIDO.produto_id
GROUP BY PRODUTOS.id
ORDER BY total_quantidade DESC;

USE mercado;

SELECT CLIENTES.nome AS nome_cliente, SUM(PEDIDOS.total) AS total_gasto
FROM CLIENTES
LEFT JOIN PEDIDOS ON CLIENTES.id = PEDIDOS.cliente_id
GROUP BY CLIENTES.id
ORDER BY total_gasto DESC;

USE loja;

SELECT PRODUTOS.nome AS nome_produto, SUM(ITENS_PEDIDO.quantidade) AS total_quantidade, SUM(ITENS_PEDIDO.preco * ITENS_PEDIDO.quantidade) AS total_vendas
FROM PRODUTOS
JOIN ITENS_PEDIDO ON PRODUTOS.id = ITENS_PEDIDO.produto_id
GROUP BY PRODUTOS.id
ORDER BY total_quantidade DESC
LIMIT 3;

USE mercado;

SELECT CLIENTES.nome AS nome_cliente, SUM(PEDIDOS.total) AS total_gasto
FROM CLIENTES
JOIN PEDIDOS ON CLIENTES.id = PEDIDOS.cliente_id
GROUP BY CLIENTES.id
ORDER BY total_gasto DESC
LIMIT 3;

USE mercado;

SELECT AVG(contagem_itens_pedido) AS media_itens_por_pedido
FROM (
    SELECT nome,CLIENTES.id AS id_cliente, COUNT(ITENS_PEDIDO.produto_id) AS contagem_itens_pedido
    FROM CLIENTES
    LEFT JOIN PEDIDOS ON CLIENTES.id = PEDIDOS.cliente_id
    LEFT JOIN ITENS_PEDIDO ON PEDIDOS.id = ITENS_PEDIDO.pedido_id
    GROUP BY PEDIDOS.id, CLIENTES.id
) AS resumo_clientes
GROUP BY id_cliente;

USE mercado;

SELECT DATE_FORMAT(PEDIDOS.data_pedido, '%m') AS mes, COUNT(DISTINCT PEDIDOS.cliente_id) AS total_clientes, COUNT(PEDIDOS.id) AS total_pedidos
FROM PEDIDOS
GROUP BY mes;

USE mercado;

SELECT PRODUTOS.nome AS nome_produto
FROM PRODUTOS
LEFT JOIN ITENS_PEDIDO ON PRODUTOS.id = ITENS_PEDIDO.produto_id
WHERE ITENS_PEDIDO.produto_id IS NULL;
