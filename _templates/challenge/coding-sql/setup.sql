-- Schema + seed data loaded into the student's database before they run.
CREATE TABLE users (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age  INT  NOT NULL
);

INSERT INTO users (name, age) VALUES
    ('Alice',   25),
    ('Bob',     17),
    ('Charlie', 30),
    ('Diana',   18),
    ('Eve',     22);
