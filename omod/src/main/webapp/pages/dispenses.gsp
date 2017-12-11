<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Dispenses"])
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
            location:	jq('#locations').val()
        }

        jq.getJSON('${ ui.actionLink("mdrtbpharmacy", "Dispense", "getDispenses") }', requestData)
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
			var icons = '<a href="dispensesedit.page?id='+result.id+'">Edit</a> | <a href="dispensesview.page?id='+result.id+'">View</a> | <a class="icon-remove small" data-uuid="'+result.id+'"></a>';
			var names = '<a href="dispensesview.page?id='+result.id+'">'+result.location.name.toUpperCase()+'</a>';
			
            dataRows.push([0, result.date, result.period, names, result.program.name, result.description==''?'N/A':result.description.toUpperCase(), icons]);
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
                "sInfo": "_TOTAL_ Dispense Entries",
                "sInfoEmpty": " ",
                "sZeroRecords": "No Dispense Entries Found",
                "sInfoFiltered": "(Showing _TOTAL_ of _MAX_ Dispenses)",
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
				window.location.href = "dispenses.page?";					
			}, 700);
		});
		
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
	.show-icon {
	    float: right;
	    font-family: "OpenSansBold";
	    font-size: 1.5em;
	    margin: 0 0 -5px 0;
	}
	#dispenseTable{
		font-size: 14px;
		margin-top: 2px;
	}
	#dispenseTable td:last-child{
		text-align:center;
	}
	a.icon-remove{
		color:#f00;
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
			View Dispense
		</li>
	</ul>
</div>
<div class="clear"></div>

<div class="patient-header new-patient-header">
    <div class="demographics" style="width: 100%;">
        <h1 class="name title" style="border-bottom: 1px solid #ddd; padding-bottom: 2px;padding-top: 5px;">
            <span>VIEW DISPENSES &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
        </h1>
		
		<div class="show-icon">
			<i class="icon-globe small"></i>${location.name.toUpperCase()}
		</div>
    </div>
	<div class="clear"></div>
</div>

<table id="dispenseTable">
	<thead>
		<th style="width:1px">#</th>
		<th style="width:70px;">DATE</th>
		<th style="width:70px;">PERIOD</th>
		<th style="width:150px;">FACILITY</th>
		<th style="width:130px;">PROGRAM</th>
		<th>DESCRIPTION</th>
		<th style="width:110px;">ACTIONS</th>
	</thead>
	
	<tbody>
	</tbody>
</table>

<div id="void-dialog" class="dialog" style="display:none; width:600px">
    <div class="dialog-header">
        <i class="icon-trash"></i>
        <h3>VOID DISPENSE</h3>
    </div>

    <div class="dialog-content">
		<ul>
			<li>
				<label for="facility" style="font-weight: bold;">FACILITY :</label>
			</li>
		</ul>

        <label class="button confirm right">Confirm</label>
        <label class="button cancel">Cancel</label>
    </div>
</div>