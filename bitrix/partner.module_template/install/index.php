<?php

use \Bitrix\Main\Localization\Loc;
use \Bitrix\Main\ModuleManager;

Loc::loadMessages(__FILE__);

Class partner_module_template extends CModule
{
    public $MODULE_ID;
    public $MODULE_VERSION;
    public $MODULE_VERSION_DATE;
    public $MODULE_NAME;
    public $MODULE_DESCRIPTION;
    public $NEED_MAIN_VERSION = '18.5.0';
    public $NEED_MODULES = ['main'];

    function __construct()
    {
        $arModuleVersion = [];
        include(__DIR__ . "/version.php");

        $this->MODULE_ID = 'partner.module_template';
        $this->MODULE_VERSION = $arModuleVersion["VERSION"];
        $this->MODULE_VERSION_DATE = $arModuleVersion["VERSION_DATE"];
        $this->MODULE_NAME = Loc::getMessage("M--PARTNER_MODULE_TEMPLATE--MODULE_NAME");
        $this->MODULE_DESCRIPTION = Loc::getMessage("M--PARTNER_MODULE_TEMPLATE--MODULE_DESC");

        $this->PARTNER_NAME = Loc::getMessage("M--PARTNER_MODULE_TEMPLATE--PARTNER_NAME");
        $this->PARTNER_URI = Loc::getMessage("M--PARTNER_MODULE_TEMPLATE--PARTNER_URI");
    }

    function DoInstall()
    {

        global $APPLICATION;
        // Проверка установленных модулей и их версий
        if (is_array($this->NEED_MODULES) && !empty($this->NEED_MODULES) && strlen($this->NEED_MAIN_VERSION) >= 0) {
            foreach ($this->NEED_MODULES as $module) {
                if (!ModuleManager::isModuleInstalled($module)) {
                    $APPLICATION->ThrowException(Loc::getMessage('M--PARTNER_MODULE_TEMPLATE--NEED_MODULES', array('#MODULE#' => $module)));
                    return false;
                }
            }
            if (CheckVersion(ModuleManager::getVersion('main'), $this->NEED_MAIN_VERSION)) {
                $this->InstallFiles();
                \Bitrix\Main\ModuleManager::registerModule($this->MODULE_ID);
                // Регистрируем события
                $this->registerEvents();
            } else {
                $APPLICATION->ThrowException(Loc::getMessage('M--PARTNER_MODULE_TEMPLATE--NEED_RIGHT_VER', array('#NEED#' => $this->NEED_MAIN_VERSION)));
                return false;
            }
        } else {
            $APPLICATION->ThrowException(Loc::getMessage('M--PARTNER_MODULE_TEMPLATE--NEED_ERROR'));
            return false;
        }
    }

    function DoUninstall()
    {
        // удаляем события
        $this->unRegisterEvents();

        ModuleManager::unRegisterModule($this->MODULE_ID);
        $this->UnInstallFiles();
        $this->UnInstallDB();
    }

    function InstallFiles($arParams = [])
    {
        return true;
    }

    function UnInstallFiles()
    {
        return true;
    }

    function UnInstallDB($arParams = [])
    {
        return true;
    }

    /**
     * Регистрирует события, необходимые для работы модуля
     */
    protected function registerEvents() {}

    /**
     * Удаляет регистрацию событий используемых модулем
     */
    protected function unRegisterEvents() {}

}
