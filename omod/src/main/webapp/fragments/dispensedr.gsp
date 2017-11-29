<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Dispensing Dashboard"])

%>

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
<table id="dispense">
    <thead>
    <th>#</th>
    <th>ACTIVE</th>
    <th>RIF</th>
    <th>ISO</th>
    <th>PYR</th>
    <th>ETHA</th>
    <th>RIF</th>
    <th>ISO</th>
    </thead>
</table>