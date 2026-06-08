<?php

declare(strict_types=1);

$pdo = new PDO('pgsql:host=localhost;dbname=app', 'user', 'pass');

// Вариант A
$id = $_GET['id'];
$rows = $pdo->query("SELECT * FROM users WHERE id = $id")->fetchAll();

// Вариант B
$stmt = $pdo->prepare('SELECT * FROM users WHERE id = :id');
$stmt->execute(['id' => $_GET['id']]);
$rows = $stmt->fetchAll();
