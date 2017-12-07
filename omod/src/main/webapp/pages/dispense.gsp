<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Dispense Drugs"])
	ui.includeJavascript("mdrtbdashboard", "moment.js")
%>

<script>
	jq(function () {
		jq("#session-location ul.select").on('click', 'li', function (event) {
			setTimeout(function() {
				window.location.href = "dispense.page?program=${program.id}";					
			}, 700);
			
		});
		
		jq('#dispenseTable').on('focus', '.qt input', function() {
			var val = jq(this).val().replace(',','').replace(' ','');
			if (isNaN(parseFloat(val)) || isFinite(val) && val == 0) {
				jq(this).val('');
			}
		});

		jq('#dispenseTable').on('change', '.qt input', function() {
			var val = jq(this).val().replace(',','').replace(' ','');
			jq(this).val(val.toString().formatToAccounting()!='NaN'?val.toString().formatToAccounting():'');
		});
		
		jq("#qtr").val(${qtrs});
	});
</script>

<style>
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.name {
		color: #f26522;
	}
	.budget-box{
		border: 1px solid #d3d3d3;
		border-top: 2px solid #363463;
		height: auto;
		margin: 15px 0 0 0;
		padding-bottom: 5px;
	}
	.budget-box div{
		width: 36%;
		display: inline-block;
	}
	.budget-box label{
		display: inherit;
		padding: 2px 10px;
		margin: 10px 0 0 0;
		width: 60px;

	}
	.budget-box  input, .budget-box select, .budget-box ul.select, .budget-box textarea {
		min-width: 0;
		display: inline-block;
		width: 230px;
		height: 38px;
	}
	.budget-box input, .budget-box select, .budget-box textarea, .budget-box ul.select {
		color: #363463;
		padding: 5px 10px;
		background-color: #FFF;
		border: 1px solid #DDD;
	}
	.budget-box textarea{
		resize: none;
		height: 80px;
		margin-top: 2px;
		width: 400px;
	}

	.textable{
		padding:0;
	}
	.textable input {
		background-color: transparent;
		margin: 0px;
		border: none;
		width: 100%;
		height: auto;
		text-align: center;
	}
	#date-created label{
		display: inline-block;
	}
	.button.confirm{
		margin-right:0px;
	}
	.dialog-content .confirmation{
		margin-bottom: 20px;
	}
	#modal-overlay {
		background: #000 none repeat scroll 0 0;
		opacity: 0.3 !important;
	}
</style>


<% if (program.programId == 1){ %>
	${ui.includeFragment("mdrtbpharmacy", "dispensetb")}
<% } else if (program.programId == 2) { %>
	${ui.includeFragment("mdrtbpharmacy", "dispensedr")}
<% } else { %>
	404 - Page Not Found
<% } %>


<div id="confirm-dialog" class="dialog" style="display:none;">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>

        <h3>CONFIRM POSTING</h3>
    </div>

    <div class="dialog-content">
        <div class="confirmation">
            Confirm
        </div>

        <label class="button confirm right">Confirm</label>
        <label class="button cancel">Cancel</label>
    </div>
</div>
