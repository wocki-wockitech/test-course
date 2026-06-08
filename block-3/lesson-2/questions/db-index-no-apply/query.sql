-- Дано: индекс по колонке email
CREATE INDEX idx_users_email ON users (email);

-- Запрос A
SELECT * FROM users WHERE LOWER(email) = 'a@b.c';

-- Запрос B
SELECT * FROM users WHERE email = 'a@b.c';

-- Запрос C
SELECT * FROM users WHERE name LIKE '%ivan';
