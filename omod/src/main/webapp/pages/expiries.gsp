<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Short Expiries"])
	ui.includeCss("uicommons", "datatables/dataTables_jui.css")
	ui.includeJavascript("mdrtbregistration", "jq.dataTables.min.js")
	ui.includeJavascript("mdrtbdashboard", "moment.js")
%>

<script>
	var expiryTable;
    var expiryTableObject;
    var expiryResultsData = [];

    var getShortExpiries = function(){
        expiryTableObject.find('td.dataTables_empty').html('<span><img class="search-spinner" src="'+emr.resourceLink('uicommons', 'images/spinner.gif')+'" /></span>');

        var requestData = {
			expiry: jq('#expiry').val()
        }

        jq.getJSON('${ ui.actionLink("mdrtbpharmacy", "Dispense", "getShortExpiryBatches") }', requestData)
            .success(function (data) {
                updateExpiryEntriesResults(data);
            }).error(function (xhr, status, err) {
                updateExpiryEntriesResults([]);
            }
        );
    };
	
	var updateExpiryEntriesResults = function(results){
        expiryResultsData = results || [];
        var dataRows = [];
        _.each(expiryResultsData, function(result){
			var names = result.item.drug.drug.name+' ('+result.item.drug.formulation.name+result.item.drug.formulation.dosage+')';
			var icons = '<a class="transfer" data-uuid="'+result.id+'">Transfer</a>';
			
			if (result.expired == true){
				icons += ' | <a class="icon-remove small indent" data-uuid="'+result.id+'"></a>';
			}
			
            dataRows.push([0, names, result.item.drug.category.name.toUpperCase(), result.batch, result.expiry, result.receipt, result.available, icons]);
        });

        expiryTable.api().clear();

        if(dataRows.length > 0) {
            expiryTable.fnAddData(dataRows);
        }

        refreshInTable(expiryResultsData, expiryTable);
    };
	
    var refreshInTable = function (resultData, dTable) {
        var rowCount = resultData.length;
        if (rowCount == 0) {
            dTable.find('td.dataTables_empty').html("No Records Found");
        }
        dTable.fnPageChange(0);
		
		jq('#expiryTable > tbody  > tr').each(function(){
		 	if (jq(this).find('td:last').text().trim() != 'Transfer'){
		 		jq(this).addClass('red');
		 	}
		});
    };

    var isTableEmpty = function (resultData, dTable) {
        if (resultData.length > 0) {
            return false
        }
        return !dTable || dTable.fnGetNodes().length == 0;
    };
	
	jq(function () {
        expiryTableObject = jq("#expiryTable");

        expiryTable = expiryTableObject.dataTable({
            autoWidth: false,
            bFilter: true,
            bJQueryUI: true,
            bLengthChange: false,
            iDisplayLength: 25,
            sPaginationType: "full_numbers",
            bSort: false,
            sDom: 't<"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg"ip>',
            oLanguage: {
                "sInfo": "_TOTAL_ Expiries",
                "sInfoEmpty": " ",
                "sZeroRecords": "No Expiries Found",
                "sInfoFiltered": "(Showing _TOTAL_ of _MAX_ Expiries)",
                "oPaginate": {
                    "sFirst": "First",
                    "sPrevious": "Previous",
                    "sNext": "Next",
                    "sLast": "Last"
                }
            },

            fnDrawCallback : function(oSettings){
                if(isTableEmpty(expiryResultsData, expiryTable)){
                    return;
                }
            },

            fnRowCallback : function (nRow, aData, index){
                return nRow;
            }
        });

        expiryTable.on( 'order.dt search.dt', function () {
            expiryTable.api().column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
                cell.innerHTML = i+1;
            } );
        }).api().draw();

        jq('#filter').on('keyup', function () {
            expiryTable.api().search( this.value ).draw();
        });
		
		//End of Datatables
		
		jq("#session-location ul.select").on('click', 'li', function (event) {
			setTimeout(function() {
				window.location.href = "expiries.page";					
			}, 700);
		});
		
		jq("#expiry").change(function(){
			getShortExpiries();
		});
		
		getShortExpiries();
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
		width: 80px;

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
	#modal-overlay {
		background: #000 none repeat scroll 0 0;
		opacity: 0.3 !important;
	}
	#expiryTable{
		font-size: 14px;
		margin-top: 2px;
	}
	#expiryTable th:last-child,
	#expiryTable td:last-child{
		text-align:center;
	}
	.show-icon {
		float: right;
		font-family: "OpenSansBold";
		font-size: 1.5em;
		margin: 0 0 -5px 0;
	}
	tr.red,
	tr.red a{
		color:#f00;
	}
	td a{
		cursor:pointer;
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
            Short Expiries
        </li>
    </ul>
</div>

<div class="patient-header new-patient-header">
	<div class="demographics">
		<h1 class="name" style="border-bottom: 1px solid #ddd;">
			<span><i class="icon-calendar small"></i>SHORT EXPIRIES &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
		</h1>
	</div>

	<div class="show-icon">
		<i class="icon-globe small"></i>${location.name.toUpperCase()}&nbsp;
	</div>
	<div class="clear both"></div>

	<div class="budget-box">
		<div>
			<label>Expires In:</label>
			<select name="disbursement.quarter" id="expiry">
				<option value="${today}">Expired</option>
				<option value="${three}" selected>3 Months</option>
				<option value="${six}">6 Months</option>
				<option value="${nine}">9 Months</option>
				<option value="${year}">12 Months</option>
			</select>

			<input class="right" id="filter" type="text" placeholder="Filter Drug / Batches" style="margin: 4px 7px 0 0;width: 500px;" />
			<i class="icon-filter small right" style="margin: 5px 2px 0 0;font-size: 1.5em;"></i>
		</div>
		
		<span class="clear both"></span>
	</div>
	
	<table id="expiryTable">
	    <thead>
		    <th style="width:1px">#</th>
		    <th>DRUG NAME</th>
		    <th style="width:150px;">CATEGORY</th>
		    <th style="width:80px;">BATCH#</th>
		    <th style="width:80px;">EXPIRY</th>
		    <th style="width:80px">RECEIVED</th>
		    <th style="width:80px">AVAILABLE</th>
		    <th style="width:90px">ACTIONS</th>
	    </thead>
	
	    <tbody>
	    </tbody>
	</table>
</div>


