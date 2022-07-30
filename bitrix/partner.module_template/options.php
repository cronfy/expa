<?php
/** @global CMain $APPLICATION */

use Bitrix\Main\Localization\Loc;

CModule::IncludeModule($mid);
IncludeModuleLangFile($_SERVER['DOCUMENT_ROOT'] . BX_ROOT . '/modules/main/options.php');
$module_id = $mid;

$showAccessBlock = false;

$params = [
    [
        'tab'     => [
            "DIV"   => "tab_base_settings",
            "TAB"   => GetMessage('M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--NAME'),
            "TITLE" => GetMessage("M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--TITLE"),
        ],
        'options' => [
            'checkbox_1'         => [
                'title' => Loc::getMessage("M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--GROUP_GENERAL--CHECKBOX_1"),
                'field' => ['type' => "checkbox"],
            ],

            'string_1' => [
                'title' => Loc::getMessage("M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--GROUP_ADDITIONAL--STRING_1"),
                'field' => ['type' => "text", 'params' => ['size' => 50, 'maxlength' => 100]],
            ],

            'string_2' => [
                'title' => Loc::getMessage('M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--GROUP_ADDITIONAL--STRING_2'),
                'field' => ['type' => "text", 'params' => ['size' => 50, 'maxlength' => 50]],
            ],
        ],

        'groups'  => [
            GetMessage('M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--GROUP_GENERAL--NAME')    => [
                'checkbox_1',
            ],
            getMessage("M--PARTNER_MODULE_TEMPLATE--TAB_BASE_SETTINGS--GROUP_ADDITIONAL--NAME") => [
                'string_1',
                'string_2',
            ],
        ],
    ],
];

foreach ($params as $tabParams) {
    foreach ($tabParams['options'] as $key => $tabParam) {
        if (!preg_match('/^[\w_]+$/', $key)) {
            throw new InvalidArgumentException("Ключ опции может содержать только символы a-zA-Z0-9 и _");
        }
    }
}

$aTabs = array_column($params, 'tab');
$tabControl = new CAdminTabControl("tabControl", $aTabs);

$context = \Bitrix\Main\Context::getCurrent();
$request = $context->getRequest();
if ($context->getServer()->getRequestMethod() == 'POST' && check_bitrix_sessid()) {
    foreach ($params as $tabData) {
        foreach ($tabData['options'] as $optionName => $optionValue) {
            if (array_key_exists('field', $optionValue)) {
                COption::SetOptionString(
                    $mid,
                    $optionName,
                    htmlspecialcharsbx($request->get($optionName))
                );
            } else {
                foreach ($optionValue['fields'] as $field) {
                    COption::SetOptionString(
                        $mid,
                        $field['name'],
                        htmlspecialcharsbx($request->get($field['name']))
                    );
                }
            }
        }
    }
}

$urlParams = [
    'mid'  => $mid,
    'lang' => LANGUAGE_ID,
];
$formActionUrl = $APPLICATION->GetCurPage() . '?' . http_build_query($urlParams);
$MOD_RIGHT = $APPLICATION->GetGroupRight($mid);
?>
<form method="post" action="<?php echo $formActionUrl ?>">
    <?php
    echo bitrix_sessid_post();
    $tabControl->Begin();
    foreach ($params as $tabData) {
        $tabControl->BeginNextTab();
        $groups = $tabData['groups'] ?? ['' => array_keys($tabData['options'])];
        foreach ($groups as $title => $options) {
            if ($title) { ?>
                <tr class="heading">
                    <td colspan="3"><b><?php echo $title ?></b></td>
                </tr>
            <?php }

            foreach ($options as $optionKey => $optionName) {
                if ($optionKey === 'custom_header') {
                    ?><tr><?
                    foreach ($optionName as $name) {
                        ?>
                        <td>
                            <label>
                                <?php echo $name ?>
                            </label>
                        </td>
                        <?
                    }
                    ?></tr><?
                }
                $option = $tabData['options'][$optionName];
                if (array_key_exists('field', $option)) {
                    $field = $option['field'];
                    $value = COption::GetOptionString($mid, $optionName);
                    $params = [
                        'type="' . $field['type'] . '"',
                        'id="' . $optionName . '"',
                        'name="' . $optionName . '"',
                    ];
                    foreach ($field['params'] as $paramName => $paramValue) {
                        $params[] = is_int($paramName) ? $paramValue : "{$paramName}=\"{$paramValue}\"";
                    }
                    $hintTagAttr = null;
                    if (isset($option['hint'])) {
                        $hintTagAttr = 'title="' . $option['hint'] . '"';
                        $params[] = $hintTagAttr;
                        $hintTagAttr .= ' ' . $hintTagAttr;
                    }

                    if (in_array($field['type'], ['text', 'number', 'checkbox'])) {
                        if ($field['type'] === 'checkbox' && $value) {
                            $params[] = 'checked';
                        }
                        if (empty($value) && $field['type'] === 'checkbox') {
                            $value = 1;
                        }
                        $params[] = 'value="' . $value . '"';
                    }
                    ?>
                    <?php if ($option['note_top']): ?>
                        <tr>
                            <td colspan="2" align="center">
                                <div class="adm-info-message-wrap" align="center">
                                    <div class="adm-info-message">
                                        <?=$option['note_top']; ?>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    <?php endif;?>
                    <tr>
                        <td width="40%">
                            <label for="<?php echo $optionName ?>"<?php echo $hintTagAttr ?>>
                                <?php echo $option['title'] ?>
                            </label>:
                        </td>
                        <td colspan="2" width="60%">
                            <?php if (in_array($field['type'], ['text', 'number', 'checkbox'])) { ?>
                                <input <?php echo implode(' ', $params) ?>>
                            <?php } ?>
                        </td>
                    </tr>
                    <?php if ($option['note_bottom']): ?>
                    <tr>
                        <td colspan="2" align="center">
                            <div class="adm-info-message-wrap" align="center">
                                <div class="adm-info-message">
                                    <?=$option['note_bottom']; ?>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <?php endif;?>
                <?php } else {
                    if (array_key_exists('fields', $option)) {
                        ?>
                        <tr>
                            <td>
                                <label for="<?php echo $optionName ?>"<?php echo $hintTagAttr ?>>
                                    <?php echo $option['title'] ?>
                                </label>:
                            </td>

                            <?
                            $fields = $option['fields'];
                            foreach ($fields as $field) {
                                ?>
                                <td class="adm-detail-content-cell-r"><?
                                $value = COption::GetOptionString($mid, $field['name']);
                                $params = [
                                    'type="' . $field['type'] . '"',
                                    'id="' . $field['name'] . '"',
                                    'name="' . $field['name'] . '"',
                                ];
                                foreach ($field['params'] as $paramName => $paramValue) {
                                    $params[] = is_int($paramName) ? $paramValue : "{$paramName}=\"{$paramValue}\"";
                                }
                                $hintTagAttr = null;
                                if (isset($option['hint'])) {
                                    $hintTagAttr = 'title="' . $option['hint'] . '"';
                                    $params[] = $hintTagAttr;
                                    $hintTagAttr .= ' ' . $hintTagAttr;
                                }
                                if (in_array($field['type'], ['text', 'number', 'checkbox'])) {
                                    if ($field['type'] === 'checkbox' && $value) {
                                        $params[] = 'checked';
                                    }
                                    if (empty($value) && $field['type'] === 'checkbox') {
                                        $value = 1;
                                    }
                                    $params[] = 'value="' . $value . '"';
                                }
                                ?>
                                <?php if (in_array($field['type'], ['text', 'number', 'checkbox'])) { ?>
                                    <input <?php echo implode(' ', $params) ?>>
                                <?php } ?>
                                </td>
                                <?
                            }
                            ?>
                        </tr>
                        <?
                    }
                }
            }
        }
    }

    if ($showAccessBlock) {
        // Доступ к модулю
        require_once($_SERVER['DOCUMENT_ROOT'] . '/bitrix/modules/main/admin/group_rights.php');
    }

    $tabControl->Buttons();
    ?>
    <input type="submit"
           name="Update"<?php echo ($MOD_RIGHT < 'W') ? " disabled" : null ?>
           value="<?php echo GetMessage('MAIN_SAVE') ?>"
           class="adm-btn-save">
    <input type="reset"
           name="reset"
           value="<?php echo GetMessage('MAIN_RESET') ?>">
    <?php
    echo bitrix_sessid_post();
    $tabControl->End();
    ?>
</form>
