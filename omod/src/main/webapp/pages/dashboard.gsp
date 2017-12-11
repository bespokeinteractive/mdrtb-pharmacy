<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Dashboard"])	
    ui.includeCss("mdrtbpharmacy", "dashboard.css")
%>

<script>
	jq(function () {
		var redirectLink = '';
		
		jq('#queue, #dispense, #patient, #stock, #expired, #accounts, #indent').on('click', function(){
			if (jq(this).attr('id') == 'queue'){
				redirectLink = 'dispense.page?program=1';
			}
			else if (jq(this).attr('id') == 'dispense'){
				redirectLink = 'dispenses.page';
			}
			else if (jq(this).attr('id') == 'patient'){
				redirectLink = 'issues.page';
			}
			else if (jq(this).attr('id') == 'accounts'){
				redirectLink = 'drugcalculations.page';
			}
			else if (jq(this).attr('id') == 'stock'){
				redirectLink = 'drugstock.page';
			}
			else if (jq(this).attr('id') == 'expired'){
				redirectLink = 'expiries.page';
			}
			else if (jq(this).attr('id') == 'indent'){
				redirectLink = '#';
			}
			else{
				return false;
			}
			
			window.location.href = redirectLink;
		});
		
		jq(window).resize(function(){
			var d=jq('#main-dashboard');
			var m=0.5306122;
			
			d.height((d.width()*m));
		}).resize();
		
	});
</script>

<div class="clear"></div>
<div class="container">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('referenceapplication','home')}">
				<i class="icon-home small"></i></a>
			</li>
			
			<li>
				<i class="icon-chevron-right link"></i>
				Pharmacy Dasboard
			</li>
		</ul>
	</div>
</div>


<div id='main-dashboard'>
	<div id="queue">
		<i class="icon-medicine"></i><br/>
		<span>DISPENSE DRUGS</span>	
	</div>	

	<div id="dispense">
		<i class="icon-group"></i><br/>
		<span>VIEW DISPENSES</span>	
	</div>
	
	<div id="patient">
		<i class="icon-user"></i><br/>
		<span>PATIENT ISSUES</span>	
	</div>
	
	<div id="stock">
		<i class="icon-copy"></i><br/>
		<span>DRUG STOCK</span>
	</div>
	
	<div id="expired">
		<i class="icon-calendar"></i><br/>
		<span>SHORT EXPIRIES</span>
	</div>
	
	<div id="accounts">
		<i class="icon-briefcase"></i><br/>
		<span>DRUG CALCULATION</span>
	</div>
	
	<div id="indent">
		<i class="icon-retweet"></i><br/>
		<span>ORDER DRUGS</span>
	</div>
</div>