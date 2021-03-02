<?php

namespace tpl;

use Bitrix\Main\Localization\Loc;

if (!defined("B_PROLOG_INCLUDED") || B_PROLOG_INCLUDED!==true) die();

/**
 * @global \CMain $APPLICATION
 * @global \CDatabase $DB
 * @global \CUser $USER
 *
 * @var \CBitrixComponent $component
 * @var string $componentPath Название компонента
 *
 * @var \CBitrixComponentTemplate $this
 * @var string $templateFolder Относительный путь к папке шаблона компонента
 * @var string $templateFile Относительный путь к файлу шаблона компонента
 * @var string $templateName Название шаблона
 *
 * @var array $arResult
 * @var array $arParams
 */

print_r($arResult);
?>
<?php Loc::getMessage('C.EXAMPLE_MINIMAL_COMPONENT.SAMPLE_MESSAGE') ?>
