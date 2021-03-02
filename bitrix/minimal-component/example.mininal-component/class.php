<?php

namespace developer\components\example;

if (!defined("B_PROLOG_INCLUDED") || B_PROLOG_INCLUDED !== true) {
    die();
}

/**
 * Описание компонента.
 */
// тут может быть любое название класса, оно не обязано совпадать с названием компонента, 
// можно оставить название Component
class Component extends \CBitrixComponent
{

    public function executeComponent()
    {
        $this->arResult = [
            1,
            2,
            3
        ];

        $this->includeComponentTemplate();
    }

}
