<?php

$currentSiteId = \Bitrix\Main\Application::getInstance()->getContext()->getSite();
$currentSiteSettings = \Bitrix\Main\SiteTable::getById($currentSiteId)->fetch();

echo "Привет.\nID сайта: {$currentSiteId}\nНазвание сайта: {$currentSiteSettings['NAME']}\n";