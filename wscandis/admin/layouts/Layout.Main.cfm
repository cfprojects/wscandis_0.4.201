<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfoutput>
	<html>
		<head>
			<title>#request.requestState.applicationTitle#</title>
			<link href="style.css" rel="stylesheet" type="text/css">
		</head>
		<body>
			<div id="header">
				<cfinclude template="../includes/header.cfm">
			</div>
			<div id="mainBody">
				<div id="menu">
					<cfinclude template="../includes/menu.cfm">
				</div>
				<div id="statusBar"></div>
				<div id="content">
					<cfinclude template="../includes/message.cfm">

					<table style="width:90%;font-size:11px;" align="center">
						<tr>	
							<td>
								<cftry>
									<cfif request.requestState.view neq "">
										<cfinclude template="../views/#request.requestState.view#.cfm">
									</cfif>
									<cfcatch type="any">
										<b>#cfcatch.Message#</b><br>
										#cfcatch.Detail#
									</cfcatch>
								</cftry>
							</td>
						</tr>
					</table>
				</div>
				<cfinclude template="../includes/footer.cfm">
			</div>
		</body>
	</html>
</cfoutput>





