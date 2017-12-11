<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Patient Issues"])
	ui.includeCss("uicommons", "datatables/dataTables_jui.css")
	ui.includeJavascript("mdrtbregistration", "jq.dataTables.min.js")
	ui.includeJavascript("mdrtbdashboard", "moment.js")
%>

<script>
	var dispenseTable;
    var dispenseTableObject;
    var dispenseResultsData = [];

    var getDispenseEntries = function(){
        dispenseTableObject.find('td.dataTables_empty').html('<span><img class="search-spinner" src="'+emr.resourceLink('uicommons', 'images/spinner.gif')+'" /></span>');

        var requestData = {
			program:1,
			period: '0'+jq('#qtr').val()+'-'+jq('#yrs').val()
        }

        jq.getJSON('${ ui.actionLink("mdrtbpharmacy", "Dispense", "getPatientIssues") }', requestData)
            .success(function (data) {
                updateDispenseEntriesResults(data);
            }).error(function (xhr, status, err) {
                updateDispenseEntriesResults([]);
            }
        );
    };
	
	var updateDispenseEntriesResults = function(results){
        dispenseResultsData = results || [];
        var dataRows = [];
        _.each(dispenseResultsData, function(result){
			var names = result.programDetails.patientProgram.patient.names.toUpperCase().substring(1, result.programDetails.patientProgram.patient.names.length-1);
			
            dataRows.push([0, result.id, names, result.programDetails.patientProgram.patient.age, result.programDetails.weight, result.rhze, result.rh, result.rhz, result.rhp, '', result.eth, result.iso]);
        });

        dispenseTable.api().clear();

        if(dataRows.length > 0) {
            dispenseTable.fnAddData(dataRows);
        }

        refreshInTable(dispenseResultsData, dispenseTable);
    };
	
    var refreshInTable = function (resultData, dTable) {
        var rowCount = resultData.length;
        if (rowCount == 0) {
            dTable.find('td.dataTables_empty').html("No Records Found");
        }
        dTable.fnPageChange(0);
    };

    var isTableEmpty = function (resultData, dTable) {
        if (resultData.length > 0) {
            return false
        }
        return !dTable || dTable.fnGetNodes().length == 0;
    };
	
	jq(function () {
        dispenseTableObject = jq("#dispenseTable");

        dispenseTable = dispenseTableObject.dataTable({
            autoWidth: false,
            bFilter: true,
            bJQueryUI: true,
            bLengthChange: false,
            iDisplayLength: 25,
            sPaginationType: "full_numbers",
            bSort: false,
            sDom: 't<"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg"ip>',
            oLanguage: {
                "sInfo": "_TOTAL_ Patients",
                "sInfoEmpty": " ",
                "sZeroRecords": "No Patients Found",
                "sInfoFiltered": "(Showing _TOTAL_ of _MAX_ Patients)",
                "oPaginate": {
                    "sFirst": "First",
                    "sPrevious": "Previous",
                    "sNext": "Next",
                    "sLast": "Last"
                }
            },

            fnDrawCallback : function(oSettings){
                if(isTableEmpty(dispenseResultsData, dispenseTable)){
                    return;
                }
            },

            fnRowCallback : function (nRow, aData, index){
                return nRow;
            }
        });

        dispenseTable.on( 'order.dt search.dt', function () {
            dispenseTable.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
                cell.innerHTML = i+1;
            } );
        }).api().draw();

        jq('#filter').on('keyup', function () {
            dispenseTable.api().search( this.value ).draw();
        });
		
		//End of Datatables
		
		jq("#session-location ul.select").on('click', 'li', function (event) {
			setTimeout(function() {
				window.location.href = "issues.page";					
			}, 700);
		});
		
		jq("#qtr, #yrs").change(function(){
			getDispenseEntries();
		});
		
		jq("#qtr").val(${qtrs});
		
		getDispenseEntries();
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
		margin: 3px 0 0 0;
		padding-bottom: 5px;
	}
	.budget-box div{
		width: 100%;
		display: inline-block;
	}
	.budget-box label{
		display: inherit;
		padding: 2px 10px;
		margin: 10px 0 0 0;
		width: 60px;

	}
	input, form input, select, form select, ul.select, form ul.select, textarea {
		min-width: 0;
		display: inline-block;
		width: 230px;
		height: 38px;
	}
	input, select, textarea, form ul.select, .form input, .form select, .form textarea, .form ul.select {
		color: #363463;
		padding: 5px 10px;
		background-color: #FFF;
		border: 1px solid #DDD;
	}
	textarea{
		resize: none;
		height: 120px;
		margin-top: 2px;
		width: 400px;
	}
	#date-created label{
		display: inline-block;
	}
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
	#modal-overlay {
		background: #000 none repeat scroll 0 0;
		opacity: 0.3 !important;
	}
	#locationList{
		font-size: 14px;
		margin-top: 5px;
	}
	.show-icon {
		float: right;
		font-family: "OpenSansBold";
		font-size: 1.5em;
		margin: 0 0 -5px 0;
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
            Patient Issues
        </li>
    </ul>
</div>

<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span><i class="icon-user small"></i>VIEW ISSUES &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>

	<div class="show-icon">
		<i class="icon-globe small"></i>${location.name.toUpperCase()}&nbsp;
	</div>
	<div class="clear both"></div>

	<div class="budget-box">
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
                <option value="${yr}" ${yr==year?'selected':''} >${yr}</option>
                <% } %>
			</select>

			<input class="right" id="filter" type="text" placeholder="Filter Patents" style="margin: 4px 7px 0 0;width: 500px;" />
			<i class="icon-filter small right" style="margin: 5px 2px 0 0;font-size: 1.5em;"></i>
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
		</tbody>
	</table>
</div>
