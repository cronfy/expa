<?php

// https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&LESSON_ID=2161

require($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/include/prolog_before.php");
ini_set('display_errors', 1);
error_reporting(E_ALL & ~E_STRICT & ~E_DEPRECATED & ~E_WARNING & ~E_NOTICE);

$switchTo = ((int) $_GET['userId']) ?: 1;

global $USER;
$USER->Authorize($switchTo);

if ($_POST['action'] === 'setLoginAdmin') {
    $connection = Bitrix\Main\Application::getConnection();
    $connection->queryExecute("UPDATE b_user SET login = 'admin' WHERE id = 1");
    $msg = "Логин изменен на admin";
}
?>
<!doctype html>

<html lang="ru">
<head>
    <meta charset="utf-8">

    <title>Empty UTF-8 HTML Page</title>
    <meta name="description" content="   put some description here   ">
</head>

<body>

<h1>Авторизовались под пользователем login: <?= $USER->GetLogin() ?> / email: <?= $USER->GetEmail() ?> / ID: <?= $USER->GetId() ?></h1>

<p>Добро пожаловать в админку <a href="/bitrix/">/bitrix/</a> или <a href="/">на главную</a>.</p>

<form method="post">
    <button name="action" value="setLoginAdmin">Сменить логин пользователя с ID == 1 на admin</button>
</form>

<?php if ($msg) : ?>
    <p><?= htmlspecialcharsbx($msg) ?></p>
<?php endif ?>

<h2>Администраторы</h2>

<ul>
<?php foreach (\Bitrix\Main\UserTable::getList(['limit' => 100, 'filter' => ['ACTIVE' => 'Y']]) as $user) : ?>
<li>
    <a href="?userId=<?= $user['ID'] ?>">переключиться</a> в
    <?= htmlspecialcharsbx("{$user['ID']} / {$user['LOGIN']} / {$user['EMAIL']}") ?>
</li>
<?php endforeach; ?>
</ul>

</body>
</html>
<?php
require($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/include/epilog_after.php");
?>

