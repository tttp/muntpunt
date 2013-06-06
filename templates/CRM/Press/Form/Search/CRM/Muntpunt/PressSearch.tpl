<h2>Filter the journalists</h2>
{debug}
<table>
<tr>
<td>
<h3>Functie</h3>
{foreach from=$functions item=i}
<br><input type="checkbox" name="function[{$i.id}]"/>{$i.label}
{/foreach}
</td>
<td>
<h3>Redactie</h3>
{foreach from=$teams item=i}
<br><input type="checkbox" name="team[{$i.id}]"/>{$i.label}
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
<br><input type="checkbox" name="categorie[{$i.id}]"/>{$i.label}
{/foreach}
</td>
<td>
<h3>Persoort</h3>
{foreach from=$types item=i}
<br><input type="checkbox" name="type[{$i.id}]"/>{$i.label}
{/foreach}
</td>
<td>
<h3>Periodicity</h3>
{foreach from=$frequencies item=i}
<br><input type="checkbox" name="frequency[{$i.id}]"/>{$i.label}
{/foreach}
</td>
</tr>
</table>
