<script>
	jq(function () {
		var getActivePatients = function(){
			var requestData = {
				program:${program.id},
				qtr: 	jq('#qtr').val(),
				year:	jq('#yrs').val(),
			}
			
			jq.getJSON('${ ui.actionLink("mdrtbpharmacy", "Dispense", "getActiveUsers") }', requestData)
				.success(function (data) {
					var rows = data || [];
					var count = 1;
					jq('#dispenseTable > tbody').empty();
					
					_.each(rows, function(data){
						jq('#dispenseTable > tbody').append("<tr><td>" + count + "</td><td>"+data.tbmuNumber+"</td><td>"+data.patientProgram.patient.names.substring(1, data.patientProgram.patient.names.length-1).toUpperCase()+"</td><td>"+data.patientProgram.patient.age+"</td><td>"+data.weight+"</td><td class='textable qt' style='width:50px;'><input name='drug.3."+data.patientProgram.id+"' /></td><td class='textable qt' style='width:50px;'><input name='drug.11."+data.patientProgram.id+"' /></td><td class='textable qt' style='width:50px;'><input name='drug.12."+data.patientProgram.id+"' /></td><td class='textable qt' style='width:50px;'><input name='drug.15."+data.patientProgram.id+"' /></td><td></td><td class='textable qt' style='width:50px;'><input name='drug.2."+data.patientProgram.id+"' /></td><td class='textable qt' style='width:50px;'><input name='drug.1."+data.patientProgram.id+"' /></td></tr>")
						count++;
					});
					
					if (count == 1){
						jq('#dispenseTable > tbody').append("<tr><td>&nbsp;</td><td colspan='11'>NO PATIENTS FOUND</td></tr>");
					}
				}).error(function (xhr, status, err) {
					jq('#dispenseTable > tbody').append("<tr><td>&nbsp;</td><td colspan='11'>NO PATIENTS FOUND</td></tr>");
					jq().toastmessage('showErrorToast', 'Error Loading Details. ' + err);
				}
			);
		}
		
		var confirmDialog = emr.setupConfirmationDialog({
			dialogOpts: {
				overlayClose: false,
				close: true
			},
			selector: '#confirm-dialog',
			actions: {
				confirm: function () {
					var dataString = jq('form').serialize();
			
					jq.ajax({
						type: "POST",
						url: '${ui.actionLink("mdrtbpharmacy", "Dispense", "dispenseForTbPatients")}',
						data: dataString,
						dataType: "json",
						success: function (data) {
							if (data.status == "success") {
								jq().toastmessage('showSuccessToast', data.message);
								window.location.href = "dashboard.page";
							}
							else {
								jq().toastmessage('showErrorToast', 'Post failed. ' + data.message);
							}
						},
						error: function (data) {
							jq().toastmessage('showErrorToast', "Post failed. " + data.statusText);
						}
					});
					confirmDialog.close();
				},
				cancel: function () {
					confirmDialog.close();
				}
			}
		});	
		
		jq('#addRequest').click(function(){
			var verified = false;
			
			jq("table .qt input").each(function(){
				val = jq(this).val().replace(',','').replace(' ','');
				if (!isNaN(parseFloat(val)) && isFinite(val) && val > 0) {
					verified = true;
					return false;
				}
			});
			
			if (!verified){
				jq().toastmessage('showErrorToast', 'Post failed. Failed to verify input');
				return false;
			}
	
			jq('.dialog-content .confirmation').html("Confirm posting drug Dispense Request for <b>${location.name} Facility?</b>");
			confirmDialog.show();
		});
		
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
	#dispenseTable th:nth-child(10),
	#dispenseTable td:nth-child(10){
		width:2px;
		padding:0px;
	}
	#dispenseTable td:nth-child(4),
	#dispenseTable td:nth-child(5){
		text-align:center;
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
            <a href="dashboard.page">Pharmacy</a>
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
			${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'dispense.date', id: 'date-created', label: 'Date:', useTime: false, defaultToday: true])}
			<input type="hidden" value="${program.id}" name="dispense.program" />
		</div>

		<div style="width: 63%; float: right">
			<label style="display: inline-block">Notes</label>
			<textarea name="dispense.notes" style="min-width: 0;display: inline-block;margin-top: 5px;"></textarea>
		</div>

		<div>
			<label>Quarter</label>
			<select name="dispense.quarter" id="qtr" style="width:70px">
				<option value="1">01</option>
				<option value="2">02</option>
				<option value="3">03</option>
				<option value="4">04</option>
			</select>

			<select name="dispense.year" id="yrs" style="width:157px">
				<% years.eachWithIndex { yr, index -> %>
					<option value="${yr}" ${yr==year?'selected':''}>${yr}</option>
				<% } %>
			</select>
		</div>			
		<span class="clear both"></span>
	</div>
	
	<table id="dispenseTable">
		<thead>
			<th style="width:1px">#</th>
			<th style="width:110px;">IDENTIFIER</th>
			<th>PATIENTS</th>
			<th style="width:30px;">AGE</th>
			<th style="width:50px;">WEIGHT</th>
			<th style="width:50px;">RHZE</th>
			<th style="width:50px;">RH</th>
			<th style="width:50px;">RHZ</th>
			<th style="width:55px;">RH(PEDI)</th>
			<th style="width:2px;"></th>
			<th style="width:50px;">ETHA</th>
			<th style="width:50px;">INH</th>
		</thead>
		
		<tbody>
			<tr>
				<td></td>
				<td colspan=11>NO PATIENTS FOUND</td>
			</tr>
		</tbody>
	</table>
	
	<div style="margin: 5px 0 10px;">
		<span class="button confirm right" id="addRequest">
			<i class="icon-save small"></i>
			Save
		</span>

		<span class="button cancel" id="cancelButton">
			<i class="icon-remove small"></i>
			Cancel
		</span>
	</div>
</form>
