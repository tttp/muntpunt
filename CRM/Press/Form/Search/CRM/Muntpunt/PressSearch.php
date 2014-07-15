<?php

/**
 * A custom contact search
 */
class CRM_Press_Form_Search_CRM_Muntpunt_PressSearch extends CRM_Contact_Form_Search_Custom_Base implements CRM_Contact_Form_Search_Interface {
  function __construct(&$formValues) {
    $this->criteria = array('functions', 'teams','categories','frequencies','types');
    $this->column = array('functions'=> "journalist.function_32", 'teams' => "journalist.team_31"
      ,'categories'=>"media.categorie_33",'frequencies'=>"media.periodicitei_29",'types'=>"media.perssoort_14");
    parent::__construct($formValues);
    $this->formValues = $formValues;
    $this->getCriteria();
  }

  function assignFilter(&$form,$tplname,$group) {
    $result = civicrm_api3('CustomField', 'getsingle', array('version' => 3,'name' =>$group));

    $group_id=$result["option_group_id"];
    if (!$group_id) {
      die ("can't find options for field $group");
    }
    $params = array ("version"=>3,"sequential"=>1,"option_group_id"=>$group_id,"is_active"=>1);
    $result= civicrm_api3('OptionValue', 'get',array ("version"=>3,"sequential"=>1,"option_group_id"=>$group_id,"option.limit"=>100));
    if (!empty($this->$tplname)) {
      foreach ($result["values"] as &$v) {
        if (in_array($v["name"],$this->$tplname)) {
          $v["checked"] = true;
        } else {    
          $v["checked"] = false;
        }
      }
    }
    $form->assign($tplname,$result["values"]);
//it will not be rendered, but useful to get the result
    $form->addElement("text",$tplname,$tplname);

  }

  function assignLanguageFilter (&$form) {
    $langs=CRM_Contact_BAO_Contact::buildOptions('preferred_language');
    $form->assign ("languages",$langs);
    $form->addElement("text","languages","languages");
  }

  /**
   * Prepare a set of search fields
   *
   * @param CRM_Core_Form $form modifiable
   * @return void
   */
  function buildForm(&$form) {
    CRM_Utils_System::setTitle(ts('Search for journalists'));

    $this->assignLanguageFilter($form);
    $this->assignFilter($form,"functions","function");
    $this->assignFilter($form,"teams","team");
    $this->assignFilter($form,"categories","Categorie");
    $this->assignFilter($form,"frequencies","Periodicitei");
    $this->assignFilter($form,"types","Perssoort");
    $form->assign('elements', $this->criteria);
  }

  /**
   * Get a list of summary data points
   *
   * @return mixed; NULL or array with keys:
   *  - summary: string
   *  - total: numeric
   */
  function summary() {
    return NULL;
    // return array(
    //   'summary' => 'This is a summary',
    //   'total' => 50.0,
    // );
  }

  /**
   * Get a list of displayable columns
   *
   * @return array, keys are printable column headers and values are SQL column names
   */
  function &columns() {
    // return by reference
      //ts('Contact Id') => 'contact_id',
    $columns = array(
      ts('Name') => 'sort_name',
      ts('Job Title') => 'job_title',
      ts('media') => 'current_employer',
    );
    return $columns;
  }

  function count() {
    return CRM_Core_DAO::singleValueQuery($this->sql('count(distinct contact_a.id) as total'));
  }


  /**
   * Construct a full SQL query which returns one page worth of results
   *
   * @return string, sql
   */
  function all($offset = 0, $rowcount = 0, $sort = NULL, $includeContactIDs = FALSE, $justIDs = FALSE) {
//echo ($this->sql($this->select(), $offset, $rowcount, $sort, $includeContactIDs, NULL));
    return $this->sql($this->select(), $offset, $rowcount, $sort, $includeContactIDs, NULL);

  }

  /**
   * Construct a SQL SELECT clause
   *
   * @return string, sql fragment with SELECT arguments
   */
  function select() {
    return "
      contact_a.id           as contact_id  ,
      contact_a.contact_type as contact_type,
      contact_a.sort_name    as sort_name,
      contact_a.job_title    as job_title,
      contact_a.organization_name    as current_employer
    ";
  }

  /**
   * Construct a SQL FROM clause
   *
   * @return string, sql fragment with FROM and JOIN clauses
   */
  function from() {
    return "
      FROM      civicrm_contact contact_a
        LEFT JOIN civicrm_value_media_info_12 journalist ON (contact_a.id = journalist.entity_id)
        LEFT JOIN civicrm_value_diensten_en_producten_4 media ON (contact_a.employer_id = media.entity_id)
      ";

/*
        LEFT JOIN civicrm_contact org ON (contact_a.employer_id = org.id)

"      LEFT JOIN civicrm_address address ON ( address.contact_id       = contact_a.id AND
                                             address.is_primary       = 1 )
      LEFT JOIN civicrm_email           ON ( civicrm_email.contact_id = contact_a.id AND
                                             civicrm_email.is_primary = 1 )
      LEFT JOIN civicrm_state_province state_province ON state_province.id = address.state_province_id
    ";
*/
  }

  function getCriteria() {
    foreach ($this->criteria as $key) {
      $this->$key= array_keys($this->formValues[$key]);
    } 
  }
  /**
   * Construct a SQL WHERE clause
   *
   * @return string, sql fragment with conditional expressions
   */
  function where($includeContactIDs = FALSE) {
    $this->getCriteria();

    $params = array();
    $where = "contact_a.contact_type  = 'Individual'";
    $where .= " AND contact_a.contact_sub_type like '%Pers_Medewerker%'";

//preferred_language
    if (array_key_exists ("languages",$this->formValues)) {
      $lang = implode ("','",array_keys($this->formValues["languages"]));
      $where .= " AND contact_a.preferred_language IN ('$lang')";
    }
    $count  = 1;
    $clause = array();

    foreach ($this->criteria as $section) {
      if (!$this->$section) continue;
      $t = array();
      
      foreach ($this->$section as $i) {
        $t [] = $this->column[$section] . " LIKE '%". $i ."%'";
      }
      $clause[] = " ( ". implode(" OR ",$t ). " ) ";
      $params[$count] = array($this->$section, 'String');
      $count++;
    }

/*
      $params[$count] = array($name, 'String');
      $clause[] = "contact_a.household_name LIKE %{$count}";
      $count++;
*/
    if (!empty($clause)) {
      $where .= ' AND ' . implode(' AND ', $clause);
    }
    return $this->whereClause($where, $params);
  }

  /**
   * Determine the Smarty template for the search screen
   *
   * @return string, template path (findable through Smarty template path)
   */
  function templateFile() {
   return 'CRM/Press/Form/Search/CRM/Muntpunt/PressSearch.tpl';
  }

}
