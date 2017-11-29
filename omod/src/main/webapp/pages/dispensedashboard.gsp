<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Finance Dashboard"])
%>

<style>
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.name {
		color: #f26522;
	}
</style>


<% if (view == "srs"){ %>
	${ui.includeFragment("mdrtbpharmacy", "dispensedr")}
<% } else if (view == "2") { %>
	${ui.includeFragment("mdrtbpharmacy", "dispensetb")}
<% } else { %>
	404 - Page Not Found
<% } %>
