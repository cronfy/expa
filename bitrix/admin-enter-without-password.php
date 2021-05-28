<?php

// https://dev.1c-bitrix.ru/learning/course/index.php?COURSE_ID=35&LESSON_ID=2161

require($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/include/prolog_before.php");

global $USER;
$USER->Authorize(1);

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

<p>Добро пожаловать в админку <a href="/bitrix/">/bitrix/</a>.</p>

<form method="post">
    <button name="action" value="setLoginAdmin">Сменить логин на admin</button>
</form>

<?php if ($msg) : ?>
    <p><?= htmlspecialcharsbx($msg) ?></p>
<?php endif ?>

</body>
</html>
<?php
require($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/include/epilog_after.php");
?>

