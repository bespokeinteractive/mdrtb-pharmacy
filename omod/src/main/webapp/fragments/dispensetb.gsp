<script>
	jq(function () {
		var getActivePatients = function(){
			var requestData = {
				program:${program.id}
				qtr: 	jq('#qtr').val(),
				year:	jq('#yrs').val(),
			}
			
			jq.getJSON('${ ui.actionLink("mdrtbpharmacy", "Dispense", "getActiveUsers") }', requestData)
				.success(function (data) {
					var rows = data || [];
					var count = 1;
					jq('#dispenseTable > tbody').empty();
					
					_.each(rows, function(data){
						var regimen = 'N/A';
						
						if (data.regimen != null){
							regimen = data.regimen.name.toUpperCase();
						}
						
						jq('#dispenseTable > tbody').append("<tr><td>" + count + "</td><td>"+data.tbmuNumber+"</td><td>"+data.patientProgram.patient.names.substring(1, data.patientProgram.patient.names.length-1).toUpperCase()+"</td><td>"+regimen+"</td><td class='notable'></td></tr>")
						count++;
					});
					
					//Add Summaries
					jq('#locationList > tbody').append("<tr><td>&nbsp;</td><td colspan='2'><b>TOTALS</b></td><td style='padding:0'><input id='totals' style='font-weight:bold;' name='disbursement.amount' readonly='' value='0.00' /></td><td><b>N/A</b></td></tr>");
					jq('#locationList > tbody').append("<tr><td>&nbsp;</td><td colspan='2'>ADJUSTMENT ESTIMATE</td><td style='padding:0'><input id='estimate' name='disbursement.estimate' value='0.00' /></td><td class='notable'><input name='note.' /></td></tr>");
				}).error(function (xhr, status, err) {
					jq('#locationList > tbody').append("<tr><td>&nbsp;</td><td colspan='4'>NO DATA FOUND</td></tr>");
					jq().toastmessage('showErrorToast', 'Error Loading Details. ' + err);
				}
			);		
		}
		jq('#qtr, #yrs').change(function(){
			getActivePatients();
		});
		
		getActivePatients();
	});
</script>

<style>
	#dispenseTable {
		margin-top: 2px;
		font-size: 12px;
	}
	#dispenseTable th:nth-child(9),
	#dispenseTable td:nth-child(9){
		width:1px;
		padding:0;
	}
</style>

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
<div class="clear"></div>
<form class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span>DISPENSE DASHBOARD &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>
	
	<div id="show-icon">
		&nbsp;
	</div>
	
	<div class="budget-box">
		<div>
			${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'disbursement.date', id: 'date-created', label: 'Date:', useTime: false, defaultToday: true])}
		</div>

		<div style="width: 63%; float: right">
			<label style="display: inline-block">Notes</label>
			<textarea name="disbursement.description" style="min-width: 0;display: inline-block;margin-top: 5px;"></textarea>
		</div>

		<div>
			<label>Quarter</label>
			<select name="disbursement.quarter" id="qtr" style="width:70px">
				<option value="1">01</option>
				<option value="2">02</option>
				<option value="3">03</option>
				<option value="4">04</option>
			</select>

			<select name="disbursement.year" id="yrs" style="width:157px">
				<% years.eachWithIndex { yr, index -> %>
					<option value="${yr}" ${yr==year?'selected':''}  '>${yr}</option>
				<% } %>
			</select>
		</div>			
		<span class="clear both"></span>
	</div>
	
	<table id="dispenseTable">
		<thead>
			<th style="width:1px">#</th>
			<th style="width:120px;">IDENTIFIER</th>
			<th>PATIENTS</th>
			<th style="width:150px;">REGIMEN</th>
			<th>RIF</th>
			<th>ISO</th>
			<th>PYR</th>
			<th>ETHA</th>
			<th style="width:1px"></th>
			<th>NOTES</th>
		</thead>
		
		<tbody>
			<tr>
				<td></td>
				<td colspan=8>NO PATIENTS FOUND</td>
			</tr>
		</tbody>
	</table>
</form>
