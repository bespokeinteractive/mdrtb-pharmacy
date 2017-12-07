<%
    ui.decorateWith("appui", "standardEmrPage", [ title: ui.message("referenceapplication.home.title") ])

    def htmlSafeId = { extension ->
        "${ extension.id.replace(".", "-") }-${ extension.id.replace(".", "-") }-extension"
    }
	
	def htmlAppId = { extension ->
        "${ extension.id.replace(".", "-") }"
    }
%>

<script>
	jq(function () {
		jq("#session-location ul.select").on('click', 'li', function (event) {
			setTimeout(function() {
				window.location.href = "home.page";					
			}, 700);
			
		});
	
		jq('#mdrtbFindPatient').click(function(){
			var active = false;			
			if (jq('#onlyMdrtbPatients:checked').length == 1){
				active = true;
			}
			
			window.location.href = emr.pageLink("mdrtbregistration", "search", {
				phrase: jq('#searchBox').val(),
				active: active
			});
		});
		
		jq('#searchBox').keydown(function (e) {
			var active = false;			
			if (jq('#onlyMdrtbPatients:checked').length == 1){
				active = true;
			}
			
			var key = e.keyCode || e.which;
			if (key == 13) {
				window.location.href = emr.pageLink("mdrtbregistration", "search", {
					phrase: jq('#searchBox').val(),
					active: active
				});
			}
		});
		
		jq('#mdrtbRegisterPatient').click(function(){
			var gender = jq('#gender:checked').val();
			
			if (typeof gender === 'undefined'){
				gender = '';
			}	
			
			window.location.href = emr.pageLink("mdrtbregistration", "register", {
				names: 		jq('#personName').val(),
				birthdate: 	jq('#birthdate').val(),
				estimate:	jq('#birthdateEstimated').val(),
				gender: 	gender,
			});
		});
		
		jq('#birthdate').datepicker({
            yearRange: 'c-100:c',
            maxDate: '0',
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            constrainInput: false
        }).on("change", function (dateText) {
            jq("#birthdate").val(this.value);
            checkBirthDate();
        });
		
		jq('a.cohort').click(function(){
			jq('#reportName').val('COHORT REPORT');
			jq('#reportIdnt').val('cohort');
			
			reportDialog.show();			
		});
		
		jq('a.casefinding').click(function(){
			jq('#reportName').val('CASE-FINDING REPORT');
			jq('#reportIdnt').val('casefinding');
			
			reportDialog.show();			
		});
		
		jq('a.distribution').click(function(){
			jq('#reportName').val('AGE/GENDER DISTRIBUTION REPORT');
			jq('#reportIdnt').val('distribution');
			
			reportDialog.show();			
		});
		
		jq('#reportYear').on('change blur', function(){
			var value = jq(this).val();
			if (jq.isNumeric(value) && value.length == 2){
				value = Number(value);
				
				if (value < 50){
					value += Number(2000);
				} else {
					value += Number(1900);
				}
				
				jq(this).val(value);
			}			
		});
		
		jq('a.defaulting').click(function(){
			jq('#reportName').val('DEFAULTERS REPORT');
			jq('#reportIdnt').val('defaulting');
			
			reportDialog.show();			
		});
		
		var reportDialog = emr.setupConfirmationDialog({
			dialogOpts: {
				overlayClose: false,
				close: true
			},
			selector: '#report-dialog',
			actions: {
				confirm: function() {
					if (!(jq.isNumeric(jq('#reportQuarter').val()) && Number(jq('#reportQuarter').val()) <= 4)){
						jq().toastmessage('showErrorToast', 'Invalid Quarter. Kindly provide the correct value for the quarter');
						return false;
					}
				
					if (!(jq.isNumeric(jq('#reportYear').val()) && jq('#reportYear').val().length == 4)){
						jq().toastmessage('showErrorToast', 'Invalid Year. Kindly provide the correct value for the year');
						return false;
					}
					
					if (jq('#facility').val() == ''){
						jq().toastmessage('showErrorToast', 'Invalid Facility. Kindly provide the correct value for the facility');
						return false;
					}
					
					window.location.href = "${ui.pageLink('mdrtbdashboard','reports')}?report="+ jq('#reportIdnt').val() +"&period=" + jq('#reportYear').val() +"0"+jq('#reportQuarter').val() + "&facility=" + jq('#facility').val();					
				},
				cancel: function() {
					reportDialog.close();
				}
			}
		});
		
		getLocationFacilities();
		getLocationTransferCount();
		
	});
	
	function checkBirthDate() {
		var submitted = jq("#birthdate").val();
		jq.ajax({
			type: "GET",
			url: '${ ui.actionLink("mdrtbregistration", "registrationUtils", "processPatientBirthDate") }',
			dataType: "json",
			data: ({
				birthdate: submitted
			}),
			success: function (data) {
				if (data.datemodel.error == undefined) {
					if (data.datemodel.estimated) {
						jq("#estimatedAge").html(data.datemodel.age + '<span> (Estimated)</span>');
						jq("#birthdateEstimated").val("true")
					} else {
						jq("#estimatedAge").html(data.datemodel.age);
						jq("#birthdateEstimated").val("false");
					}

					jq("#summ_ages").html(data.datemodel.age);
					jq("#estimatedAgeInYear").val(data.datemodel.ageInYear);
					jq("#birthdate").val(data.datemodel.birthdate);
					jq("#calendar").val(data.datemodel.birthdate);

				} else {
					jq().toastmessage('showErrorToast', 'Birth date/age is in wrong format');
					jq("#birthdate").val("");
					jq("#estimatedAge").html("");
				}
			},
			error: function (xhr, ajaxOptions, thrownError) {
				alert(thrownError);
			}

		});
	}
	
	function getLocationFacilities(){
		jq.ajax({
			type: "GET",
			url: '${ ui.actionLink("mdrtbdashboard", "header", "getLoginLocations") }',
			dataType: "json",
			success: function (data) {
				jq('#facility').empty();
				jq('#facility').append('<option value=""></option>');
				
				for (index in data.locations) {
					var item = data.locations[index];
					
					var row = '<option value="' + item.id + '">' + item.name + '</option>';
					jq('#facility').append(row);
				}
			},
			error: function (xhr, ajaxOptions, thrownError) {
				alert(thrownError);
			}
		});
	}
	
	function getLocationTransferCount(){
		jq.ajax({
			type: "GET",
			url: '${ ui.actionLink("mdrtbdashboard", "dashboard", "getTransfersCount") }',
			dataType: "json",
			success: function (value) {
				if (value == 0){
					jq('.transferPatients .patients span').text('No Patients');
				}
				else if (value == 1){
					jq('.transferPatients .patients span').text('One Patient');
				}
				else {
					jq('.transferPatients .patients span').text(value + ' Patients');
				}
			},
			error: function (xhr, ajaxOptions, thrownError) {
				alert(thrownError);
			}
		});
	}
</script>

<style>
	#body-wrapper {
		background-color: #EEE;
		border-radius: 0px;
		margin-top: 0px;
		padding: 0px;
	}
	#home-container{
		margin-top: 10px;
	}
	.home-welcome{
		background: #ffad5c url("${ui.resourceLink('referenceapplication', 'images/home-banner.png')}") no-repeat scroll right bottom / auto 100%;
		box-shadow: 0 6px 5px -3px rgba(0, 0, 0, 0.2);
		margin: 0;
		padding-left: 20px;
	}
	.home-welcome i{
		color: #363463;
		font-size: 120px;
		padding: 0;
	}
	.home-welcome h1{
		color: #fff;
		font-family: "OpenSansBold",Arial,sans-serif;
		font-size: 250%;
		font-weight: bold;
		margin: 0 0 5px;
		text-shadow: 2px 2px 2px #555;
	}
	.home-welcome .descr{
		color: #fff;
	}
	.button.app, button.app, input.app[type="submit"], input.app[type="button"], input.app[type="submit"], a.button.app {
		background: #fff none repeat scroll 0 0;
		box-shadow: 0 6px 5px -3px rgba(0, 0, 0, 0.2);
		border-radius: 0px;
		margin: 10px 5px 0 0;
	}
	.button.app:nth-child(5), button.app:nth-child(5), input.app[type="submit"]:nth-child(5), input.app[type="button"]:nth-child(5), input.app[type="submit"]:nth-child(5), a.button.app:nth-child(5),
	.button.app:nth-child(10), button.app:nth-child(10), input.app[type="submit"]:nth-child(10), input.app[type="button"]:nth-child(10), input.app[type="submit"]:nth-child(10), a.button.app:nth-child(10),
	.button.app:nth-child(15), button.app:nth-child(15), input.app[type="submit"]:nth-child(15), input.app[type="button"]:nth-child(15), input.app[type="submit"]:nth-child(15), a.button.app:nth-child(15) {
		margin: 10px -5px 0 0;
	}	
	#dashboard{
		box-shadow: 0 6px 5px -3px rgba(0, 0, 0, 0.2);
		background: #fff;
		margin-top: 10px;
		min-height: 300px;
		padding: 1%;
		width: 98%;
	}	
	.logout a:hover{
		text-decoration: none;
	}
	#searchBox {
		box-sizing: border-box;
		height: 38px;
		padding: 0 10px;
		width: 67%;
	}
	.info-body.searchPatients label,
	.info-body.registerPatients label{
		display: inline-block;
		width: 70px;
		padding: 0 6px;
	}
	input{
		background-color: #FFF;
		border: 1px solid #DDD;
	}
	input:focus {
		background: #fffdf7;
	}
	.info-body.registerPatients input[type="text"]{
		box-sizing: border-box;
		height: 38px;
		padding: 0 10px;
		width: 74%;
	}
	.info-body.registerPatients div{
		margin-top: 5px;
	}
	.info-body.registerPatients input[type="radio"] {
		-webkit-appearance: checkbox;
		-moz-appearance: checkbox;
		-ms-appearance: checkbox;
	}
	.info-body.registerPatients span {
		color: #f26522;
		margin: 2px 0 10px 5px;
		display: inline-block;
	}
	#estimatedAge{
		display: inline-block;
		float: right;
		margin-top: -5px;
		margin-right: 10px;
	}
	.dashboard .info-header h3 {
		color: #f26522;
	}	
	#whv .col1, #whv .col2 {
		border: 1px solid #808080;
		display: inline-block;
		min-height: 20px;
		padding: 5px;
		width: 96%;
	}
	#whv .col1 .tital, 
	#whv .col2 .tital {
		border-bottom: 1px solid #808080;
		display: inline-block;
		font-family: "Myriad Pro",Arial,Helvetica,Tahoma,sans-serif;
		font-weight: bold;
		min-height: 5px;
		padding-bottom: 2px;
		padding-left: 10px;
		width: 95%;
	}
	.entry {
		background: rgba(0, 0, 0, 0) url("${ui.resourceLink('mdrtbdashboard', 'images/arrow_grey_right.png')}") no-repeat scroll 0 center;
		color: 			#0088cc;
		display: 		inline-block;
		font-size: 		14px;
		font-weight: 	bold;
		padding-left: 	12px;
	}
	.value {
		cursor: pointer;
		display: inline-block;
	}
	#report-dialog.dialog {
		width: 500px;
	}
	.dialog .dialog-content li {
		margin-bottom: 0;
	}
	.dialog-content ul li label {
		display: inline-block;
		width: 150px;
	}
	.dialog-content ul li input[type="text"], .dialog-content ul li select, .dialog-content ul li textarea {
		border: 1px solid #ddd;
		display: inline-block;
		height: 40px;
		margin: 1px 0;
		min-width: 20%;
		padding: 5px 0 5px 10px;
		width: 64%;
	}
	.dialog select option {
		font-size: 1em;
	}
	.dialog ul {
		margin-bottom: 20px;
	}
	.button.confirm {
		margin-right: 6px;
	}
	#modal-overlay {
		background: #000 none repeat scroll 0 0;
		opacity: 0.4!important;
	}
	a.icons {
		border: 1px solid #f26522;
		color: #333;
		cursor: pointer;
		display: inline-block;
		margin-top: 5px;
		padding: 10px;
		text-align: center;
		text-decoration: none;
		width: 88px;
		font-size: 0.7em;
	}
	a.icons:hover{	
		background-color: #f26522;
		color: #fff;
	}
	a.icons img {
		margin-bottom: 10px;
	}
</style>

<div id="home-container">
	<div class="home-welcome">
		<div style="float: left; text-align: center;">
			<img src="${ui.resourceLink('referenceapplication', 'images/endtb-logo-small.png')}" style="height:105px; margin:10px 10px 10px 0;">
			<div class="clear"></div>
		</div>
		
		<div style="float: left; margin: 10px;">
			<h1>Welcome to NTP Somali</h1>
			<div class="descr">
				This is your Application Dashboard, where you can access the most important areas of the system.
			</div>
			
			<div class="clear"></div>
		</div>
		
		<div class="clear"></div>		
	</div>
	
	<div id="dashboard">
		<div style="width: 70%; float:left;">
			<div class="dashboard" style="width:45%; float:right;">
				<div class="info-header">
					<i class="icon-search"></i>
					<h3>FIND PATIENT</h3>
				</div>

				<div class="info-body searchPatients">
					<input id="searchBox" name="searchBox" type="text" placeholder="Find Patients" />
					<button id="mdrtbFindPatient" value="task" class="button task">Search</button>
					
					<label for="searchBox" style="padding: 0;width: auto;margin: 4px 0;">
						<input name="onlyMdrtbPatients" id="onlyMdrtbPatients" checked="" value="true" type="checkbox">
						Only Active TB/MDR-TB patients
					</label>					
				</div>
				
				<div class="info-header" style="margin-top: 5px;">
					<i class="icon-retweet"></i>
					<h3>TRANSFERS</h3>
				</div>
				
				<div class="info-body transferPatients" style="padding-bottom: 30px; min-height: 101px;">
					<i class="icon-angle-right small"></i>
					<a class="patients" href="${ui.pageLink('mdrtbregistration','transfers')}"><span>No Patients</span> Found</a><br/>
					
					<i class="icon-angle-right small"></i>
					<a class="drugs" href="${ui.pageLink('mdrtbregistration','transfers')}"><span>No Inventory</span> Transfer</a><br/>
				</div>
			</div>
			
			<div class="dashboard" style="width:54%;">
				<div class="info-header">
					<i class="icon-pencil"></i>
					<h3>REGISTER NEW PATIENT</h3>
				</div>

				<div class="info-body registerPatients" style="min-height: 240px;">
					<span>Provide the patient's information below.</span>				
					
					<div>
						<label for="addName">Names:</label>
						<input type="text" name="addName" id="personName" placeholder="Full Names" />
					</div>
						
					<div>
						<label for="addBirthdate">DoB/Age:</label>
						<input id="birthdate" name="addBirthdate" type="text" placeholder="Date of Birth/Age" />
						<input id="birthdateEstimated" name="addBirthdateEstimated" type="hidden" />
					</div>
					
					<div>
						<label>Gender :</label>
						<label style="padding:0; cursor:pointer;width:25%;">
							<input name="addGender" id="gender" value="M" type="radio">
							Male
						</label>
						
						<div id="estimatedAge"></div>
						<br/>
						
						<label>&nbsp;</label>
						<label style="padding:0; cursor:pointer;width:25%;">
							<input name="addGender" id="gender" value="F" type="radio">
							Female
						</label>
					</div>
					
					<div>
						<label>&nbsp;</label>
						<button id="mdrtbRegisterPatient" value="confirm" class="button confirm">Register Patient</button>					
					</div>					
				</div>
			</div>
			
			<div class="dashboard" style="margin-top: 15px;">
				<div class="info-header">
				</div>

				<div class="" style="min-height: 240px; padding-left:2px;">
					<a class="icons" href="${ui.pageLink('mdrtbmanagement','financedashboard', ['view':'srs'])}">
						<img src="${ui.resourceLink('mdrtbmanagement', 'images/00-meeting.png')}"><br/>
						<span>MANAGEMENT DASHBOARD</span>
					</a>
					
					<a class="icons" href="${ui.pageLink('mdrtbmanagement','financebudget')}">
						<img src="${ui.resourceLink('mdrtbmanagement', 'images/00-budget.png')}"><br/>
						<span>SUBRECIPIENT BUDGET</span>
					</a>
	
					<a class="icons" href="${ui.pageLink('mdrtbmanagement','cashdisbursement')}">
						<img src="${ui.resourceLink('mdrtbmanagement', 'images/00-wallet-1.png')}"><br/>
						<span>CASH DISBURSEMENT</span>
					</a>
					
					<a class="icons" href="${ui.pageLink('mdrtbinventory','main')}">
						<img src="${ui.resourceLink('mdrtbmanagement', 'images/00-first-aid.png')}"><br/>
						<span>INVENTORY MANAGER</span>
					</a>
					
					<a class="icons" href="${ui.pageLink('mdrtbpharmacy','dashboard')}">
						<img src="${ui.resourceLink('mdrtbmanagement', 'images/00-drugs.png')}"><br/>
						<span>PHARMACY MANAGEMENT</span>
					</a>
					
					<a class="icons" href="${ui.pageLink('mdrtbpharmacy','dispense', ['program':'1'])}">
						<img src="${ui.resourceLink('mdrtbmanagement', 'images/00-pills.png')}"><br/>
						<span>DISPENSE DRUGS</span>
					</a>
				</div>

				
			</div>
			
					
		</div>
		
		<div id="whv" style="width: 28%; float:right;">
			<div class="col1 first-item" style="margin-top: 24px;">
				<div class="tital">PATIENT LIST</div>
				<div style="width: 100%; margin-top: 5px;">
					<span class="entry">&nbsp;</span>
					<a class="value" href="${ui.pageLink('mdrtbregistration','active', ['program':1])}">Active TB Patients</a>
				</div>
				
				<div style="width: 100%; padding-bottom: 5px;">
					<span class="entry">&nbsp;</span>
					<a class="value" href="${ui.pageLink('mdrtbregistration','active', ['program':2])}">Active MDR-TB Patients</a>
				</div>
				
				<div class="tital" style="min-height: 1px; margin-bottom: 3px;"></div>
				
				<div style="width: 95%;">
					<span class="entry">&nbsp;</span>
					<a class="value" href="${ui.pageLink('mdrtbregistration','viewTbRegister')}">View BMU TB Register</a>
				</div>
				
				<div style="padding-bottom:5px;">
					<span class="entry">&nbsp;</span>
					<a class="value" href="${ui.pageLink('mdrtbregistration','viewDrRegister')}">View MDR TB Register</a>
				</div>
			</div>
			
			<div class="col2 second-item" style="margin-top: 10px; height: 245px;">
				<div class="tital">REPORTS</div>
				<div style="width: 100%; margin-top: 5px;">
					<span class="entry">&nbsp;</span>
					<a class="value cohort">Cohort Report</a>
				</div>
				
				<div style="width: 100%">
					<span class="entry">&nbsp;</span>
					<a class="value casefinding">Case-finding Report</a>
				</div>
				
				<% if (context.authenticatedUser?.userId == 1) {%>
					<div class="tital" style="margin-top: 15px;">ADMINISTRATION</div>
					<div style="width: 100%; margin-top: 5px;">
						<span class="entry">&nbsp;</span>
						<a class="value" href='../admin/index.htm'>Admin Console</a>
					</div>
					
					<div style="width: 100%">
						<span class="entry">&nbsp;</span>
						<a class="value" href="${ui.pageLink('mdrtbdashboard','users')}">Manage Users</a>
					</div>
					
					<div style="width: 100%">
						<span class="entry">&nbsp;</span>
						<a class="value" href="${ui.pageLink('mdrtbdashboard','locations')}">Manage Locations</a>
					</div>				
				
				<% } %>
				
				
				
				<div class="clear"></div>
			</div>
			
		</div>
		
		<div class="clear"></div>
    </div>
</div>

<div id="report-dialog" class="dialog" style="display:none;">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>
        <h3>REPORT DIALOG</h3>
    </div>

    <div class="dialog-content">
        <ul>
			<li>
				<label for="reportName">
					Report Name :
				</label>
				<input type="text" name="report.name" id="reportName" />
				<input type="hidden" name="report.name" id="reportIdnt" />
			</li>
			
			<li>
				<label for="">
					Report Period :
				</label>
				<input id="reportQuarter" name="report.quarter" type="text" placeholder="QTR" style="width: 20%">
				<input id="reportYear" name="report.year" type="text" placeholder="YEAR (YY/YYYY)" style="width: 43%;">
			</li>
			
			<li>
				<label for="facility">
					TB Facility :
				</label>
				
				<select id="facility" class="required" name="report.outcome">
					<option value="">&nbsp;</option>
				</select>
			</li>
        </ul>

        <label class="button confirm right">Confirm</label>
        <label class="button cancel">Cancel</label>
    </div>
</div>