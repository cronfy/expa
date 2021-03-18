<?php

namespace itweb\vasilich\bitrix;

class View
{
    /** @var string */
    public $templateName;
    /** @var \CBitrixComponentTemplate */
    public $componentTemplate;
    /** @var string */
    public $componentPath;
    /** @var \CBitrixComponent */
    public $component;

    public function __construct($definedVars = [], $bitrixTemplateObject = null) {
        $this->templateName = @$definedVars['templateName'];
        $this->componentTemplate = $bitrixTemplateObject;
        $this->componentPath = @$definedVars['componentPath'];
        $this->component = @$definedVars['component'];
    }

    public function render($file, $params = [], &$return = null) {
        $params = array_merge(
            [
                'templateName' => $this->templateName,
                'componentTemplate' => $this->componentTemplate,
                'componentPath' => $this->componentPath,
                'component' => $this->component,
                'view' => $this,
            ],
            $params
        );

        $file = static::resolveFilePath($file);

        return static::renderPhpFile($file, $params, $return);

        // стандартный хедер для подключенного файла:

        /**
         * @global \CMain $APPLICATION
         * @var \CBitrixComponent $component
         * @var \CBitrixComponentTemplate $componentTemplate
         * @var string $templateName
         * @var string $componentPath
         * @var \itweb\vasilich\bitrix\View $view
         */
    }

    protected static function resolveFilePath($file) {
        // определяем путь до файла, который нужно подключить, относительно файла, откуда
        // был произведен вызов
        if (strpos($file, '/') !== 0) {
            $bt =  debug_backtrace();
            $callerFile = $bt[1]['file'];
            $file = dirname($callerFile) . '/' . $file;
        }

        if (substr($file, -4) !== '.php') {
            $file .= '.php';
        }

        return $file;
    }

    public static function renderPhpFile($_file_, $_params_ = [], &$return = null) {
        $_file_ = static::resolveFilePath($_file_);

        $_params_ = $_params_ ?: [];

        $_params_['arResult'] = @$_params_['arResult'] ?: [];
        $_params_['arParams'] = @$_params_['arParams'] ?: [];

        unset($_params_['this']);

        extract($_params_, EXTR_OVERWRITE);

        /** @var $APPLICATION \CMain */
        // required in templates
        global $APPLICATION;

        ob_start();
        $return = require $_file_;
        return ob_get_clean();
    }

    /**
     * Для подключения компонентов, которые сами используют функции ob_*, в результате чего возникает конфликт с нашей
     * буферизацией (например, catalog.section в режиме AJAX в component_epilog)
     *
     * @param $_file_
     * @param array $_params_
     * @param null $return
     * @return mixed
     */
    public static function outputPhpFile($_file_, $_params_ = []) {
        if (strpos($_file_, '/') !== 0) {
            $bt =  debug_backtrace();
            $callerFile = $bt[0]['file'];
            $_file_ = dirname($callerFile) . '/' . $_file_;

            unset($bt, $callerFile);
        }

        $_params_ = $_params_ ?: [];

        $_params_['arResult'] = @$_params_['arResult'] ?: [];
        $_params_['arParams'] = @$_params_['arParams'] ?: [];

        unset($_params_['this']);

        extract($_params_, EXTR_OVERWRITE);

        /** @var $APPLICATION \CMain */
        // required in templates
        global $APPLICATION;

        return require $_file_;
    }

}