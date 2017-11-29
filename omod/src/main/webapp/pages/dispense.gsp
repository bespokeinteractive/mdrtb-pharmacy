<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Dispense Drugs"])
%>

<style>
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.name {
		color: #f26522;
	}
</style>


<% if (program.programId == 1){ %>
	${ui.includeFragment("mdrtbpharmacy", "dispensetb")}
<% } else if (program.programId == 2) { %>
	${ui.includeFragment("mdrtbpharmacy", "dispensedr")}
<% } else { %>
	404 - Page Not Found
<% } %>
