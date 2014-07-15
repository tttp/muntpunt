<?php
// This file declares a managed database record of type "CustomSearch".
// The record will be automatically inserted, updated, or deleted from the
// database as appropriate. For more details, see "hook_civicrm_managed" at:
// http://wiki.civicrm.org/confluence/display/CRMDOC42/Hook+Reference
return array (
  0 => 
  array (
    'name' => 'Muntpunt press search',
    'entity' => 'CustomSearch',
    'params' => 
    array (
      'version' => 3,
      'label' => 'CRM_Muntpunt_PressSearch',
      'description' => 'Search for muntpunt pressgroup',
      'class_name' => 'CRM_Press_Form_Search_CRM_Muntpunt_PressSearch',
    ),
  ),
);
