<div class="crm-block crm-form-block crm-contact-custom-search-form-block">
<div class="crm-accordion-wrapper crm-custom_search_form-accordion {if $rows}collapsed{/if}">
    <div class="crm-accordion-header crm-master-accordion-header">
      {ts}Edit Search Criteria{/ts}
    </div><!-- /.crm-accordion-header -->
    <div class="crm-accordion-body">

<table>
<tr>
<td>
<h3>Functie</h3>
{foreach from=$functions item=i}
<br><label><input type="checkbox" name="functions[{$i.value}]" {if $i.checked}checked="checked"{/if}/>{$i.label}</input></label>
{/foreach}
</td>
<td>
<h3>Redactie</h3>
{foreach from=$teams item=i}
<br><label><input type="checkbox" name="teams[{$i.value}]" {if $i.checked}checked="checked"{/if}/>{$i.label}</input></label>
{/foreach}
</td>
<td>
<h3>Taal</h3>
{foreach from=$languages item=i key=k}
<br><label><input type="checkbox" name="languages[{$k}]" {if $i.checked}checked="checked"{/if}/>{$i}</input></label>
{/foreach}
</td>
</tr>
</table>
<h2>Filter the Media</h2>
<table>
<tr>
<td>
<h3>Categorie</h3>
{foreach from=$categories item=i}
<br><label><input type="checkbox" name="categories[{$i.value}]" {if $i.checked}checked="checked"{/if}/>{$i.label}</input></label>
{/foreach}
</td>
<td>
<h3>Persoort</h3>
{foreach from=$types item=i}
<br><label><input type="checkbox" name="types[{$i.value}]" {if $i.checked}checked="checked"{/if}/>{$i.label}</input></label>
{/foreach}
</td>
<td>
<h3>Periodicity</h3>
{foreach from=$frequencies item=i}
<br><label><input type="checkbox" name="frequencies[{$i.value}]" {if $i.checked}checked="checked"{/if}/>{$i.label}</input></label>
{/foreach}
</td>
</tr>
            <tr>
                <td colspan="3">{$form.buttons.html}</td>
            </tr>
        </table>

</table>


</div>

{if $rowsEmpty || $rows}
<div class="crm-content-block">
{if $rowsEmpty}
    {include file="CRM/Contact/Form/Search/Custom/EmptyResults.tpl"}
{/if}

{if $summary}
    {$summary.summary}: {$summary.total}
{/if}

{if $rows}
  <div class="crm-results-block">
    {* Search request has returned 1 or more matching rows. Display results and collapse the search criteria fieldset. *}
        {* This section handles form elements for action task select and submit *}
       <div class="crm-search-tasks">
        {include file="CRM/Contact/Form/Search/ResultTasks.tpl"}
    </div>
        {* This section displays the rows along and includes the paging controls *}
      <div class="crm-search-results">

        {include file="CRM/common/pager.tpl" location="top"}

        {* Include alpha pager if defined. *}
        {if $atoZ}
            {include file="CRM/common/pagerAToZ.tpl"}
        {/if}

        {strip}
        <table class="selector" summary="{ts}Search results listings.{/ts}">
            <thead class="sticky">
                <tr>
                <th scope="col" title="Select All Rows">{$form.toggleSelect.html}</th>
                {foreach from=$columnHeaders item=header}
                    <th scope="col">
                        {if $header.sort}
                            {assign var='key' value=$header.sort}
                            {$sort->_response.$key.link}
                        {else}
                            {$header.name}
                        {/if}
                    </th>
                {/foreach}
                <th>&nbsp;</th>
                </tr>
            </thead>
            {counter start=0 skip=1 print=false}
            {foreach from=$rows item=row}
                <tr id='rowid{$row.contact_id}' class="{cycle values="odd-row,even-row"}">
                    {assign var=cbName value=$row.checkbox}
                    <td>{$form.$cbName.html}</td>
                    {foreach from=$columnHeaders item=header}
                        {assign var=fName value=$header.sort}
                        {if $fName eq 'sort_name'}
                            <td><a href="{crmURL p='civicrm/contact/view' q="reset=1&cid=`$row.contact_id`"}">{$row.sort_name}</a></td>
                        {else}
                            <td>{$row.$fName}</td>
                        {/if}
                    {/foreach}
                    <td>{$row.action}</td>
                </tr>
            {/foreach}
        </table>
        {/strip}

        <script type="text/javascript">
        {* this function is called to change the color of selected row(s) *}
        var fname = "{$form.formName}";
        on_load_init_checkboxes(fname);
        </script>

        {include file="CRM/common/pager.tpl" location="bottom"}

        </p>
    {* END Actions/Results section *}
    </div>
    </div>
{/if}



</div>
{/if}
{literal}
<script type="text/javascript">
cj(function() {
   cj().crmAccordions();
});

function toggleContactSelection( name, qfKey, selection ){
  var Url  = "{/literal}{crmURL p='civicrm/ajax/markSelection' h=0}{literal}";

  if ( selection == 'multiple' ) {
    var rowArr = new Array( );
    {/literal}{foreach from=$rows item=row  key=keyVal}
      {literal}rowArr[{/literal}{$keyVal}{literal}] = '{/literal}{$row.checkbox}{literal}';
    {/literal}{/foreach}{literal}
    var elements = rowArr.join('-');

    if ( cj('#' + name).is(':checked') ){
      cj.post( Url, { name: elements , qfKey: qfKey , variableType: 'multiple' } );
    }
    else {
      cj.post( Url, { name: elements , qfKey: qfKey , variableType: 'multiple' , action: 'unselect' } );
    }
  }
  else if ( selection == 'single' ) {
    if ( cj('#' + name).is(':checked') ){
      cj.post( Url, { name: name , qfKey: qfKey } );
    }
    else {
      cj.post( Url, { name: name , qfKey: qfKey , state: 'unchecked' } );
    }
  }
  else if ( name == 'resetSel' && selection == 'reset' ) {
    cj.post( Url, {  qfKey: qfKey , variableType: 'multiple' , action: 'unselect' } );
    {/literal}
    {foreach from=$rows item=row}{literal}
      cj("#{/literal}{$row.checkbox}{literal}").removeAttr('checked');{/literal}
    {/foreach}
    {literal}
    cj("#toggleSelect").removeAttr('checked');
    var formName = "{/literal}{$form.formName}{literal}";
    on_load_init_checkboxes(formName);
  }
}
</script>

{/literal}

</div>
</div>
