<?php
require_once('/var/www/magento/app/Mage.php');
Mage::app()->setCurrentStore(Mage::getModel('core/store')->load(Mage_Core_Model_App::ADMIN_STORE_ID));
$installer = new Mage_Eav_Model_Entity_Setup('core_setup');
$installer->startSetup();
$installer->addAttribute('catalog_product', 'att_generado', array(
            'group'           => 'General',
            'label'           => 'Atributo Generado',
            'input'           => 'text',
            'type'            => 'varchar',
            'required'        => 0,
            'visible_on_front'=> 1,
            'visible'         => 1,
            'visible_in_advanced_search'  => 1,
            'is_html_allowed_on_front' => 1,
            'filterable'      => 0,
            'searchable'      => 0,
            'comparable'      => 0,
            'user_defined'    => 1,
            'is_configurable' => 0,
            'global'          => Mage_Catalog_Model_Resource_Eav_Attribute::SCOPE_GLOBAL,
            'note'            => '',
));
$installer->endSetup();
?>
