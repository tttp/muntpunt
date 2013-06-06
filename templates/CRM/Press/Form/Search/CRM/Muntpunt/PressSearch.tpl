<h2>Filter the journalists</h2>
<table>
<tr>
<td>
<h3>Functie</h3>
{foreach $functions as $function}
<br><input type="checkbox" />{$function.label}
{/foreach}
<br><input type="checkbox" />Freelance
<br><input type="checkbox" />Redactie
...
</td>
<td>
<h3>Redactie</h3>
<br><input type="checkbox" />Allround
<br><input type="checkbox" />Beauty
...
</td>
</tr>
</table>
<h2>Filter the Media</h2>
<table>
<tr>
<td>
<h3>Persoort</h3>
<br><input type="checkbox" />Radio
<br><input type="checkbox" />Online
...
</td>
<td>
<h3>Categorie</h3>
<br><input type="checkbox" />Brussels
<br><input type="checkbox" />Vlaams-Brabant
</td>
</tr>
<tr>
<td>
<h3>Periodicity</h3>
<br><input type="checkbox" />Monthly
<br><input type="checkbox" />Weekly
...
</td>
</tr>
</table>
