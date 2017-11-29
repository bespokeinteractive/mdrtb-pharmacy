<style>
	#dispenseTable {
		margin-top: 2px;
		font-size: 14px;
	}
	#dispenseTable th:nth-child(7),
	#dispenseTable td:nth-child(7){
		width:1px;
		padding:0;
	}
</style>

<div class="clear"></div>
<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                Dispense
            </li>
        </ul>
    </div>
    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>DISPENSE DASHBOARD &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>
    </div>
</div>
<table id="dispenseTable">
    <thead>
		<th style="width:1px">#</th>
		<th>ACTIVE</th>
		<th>RIF</th>
		<th>ISO</th>
		<th>PYR</th>
		<th>ETHA</th>
		<th style="width:1px"></th>
		<th>RIF</th>
		<th>ISO</th>
    </thead>
	
	<tbody>
		<tr>
			<td></td>
			<td colspan=8>NO PATIENTS FOUND</td>
		</tr>
	</tbody>
</table>