<!--- This template is used to test the wscandis webservice --->

<cfparam name="directoryServiceWSDL" default="http://#cgi.server_name#/wscandis/server/directoryServiceWS.cfc?wsdl">
<cfparam name="pathToFactory" default="wscandis.client.webServiceFactory">
<cfparam name="wsName" default="">
<cfparam name="action" default="">
<cfset bError = false>
<cfset aResources = arrayNew(1)>

<!--- Refresh the webservice stub in case there was any change ---->
<cfobject type="JAVA" action="Create" name="factory" class="coldfusion.server.ServiceFactory">
<cfset RpcService = factory.XmlRpcService>
<cfset RpcService.refreshWebService(directoryServiceWSDL)>


<cftry>
	<!--- Call the webservice to get a list of all defined services in the directory --->
	<cfset oDS = createObject("webservice",directoryServiceWSDL)>
	<cfset aResources = oDS.listResources()>

	<cfswitch expression="#action#">
		
		<cfcase value="startFactory">
			<cfset application.oWebServiceFactory = createObject("component",pathToFactory).init(directoryServiceWSDL)>
		</cfcase>
	
		<cfcase value="getService">
			<cfset ws = application.oWebServiceFactory.getService(wsName)>
		</cfcase>
	
	</cfswitch>

	<cfcatch type="any">
		<cfset bError = true>
		<cfset errorDump = cfcatch>
	</cfcatch>	
</cftry>

<cfoutput>
	<html>
		<head>
			<title>Web Service Caching and Directory Service : Test Client</title>
			<link rel="stylesheet" type="text/css" href="includes/style.css"/>
			<style type="text/css">
				body, table, input {
					font-size:11px;
					font-family:verdana, arial;
				}
				.frmField {
					border:1px solid silver;
					padding:2px;
				}
			</style>
		</head>
			<body>

				<div id="header">
					<table width="100%">
						<tr>
							<td>
								<img src="includes/wscandis_logo.gif" 
										style="margin-top:3px;margin-bottom:5px;margin-left:10px;" >
							</td> 
							<td align="right" style="padding-right:10px;">
								<div style="line-height:25px;font-weight:bold;">
									WebServiceFactory Test
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div id="content">
					<table align="center" class="tblContent">
						<tr>	
							<td>						
			
							<form name="frm" action="index.cfm" method="post">
								<table>
									<tr>
										<td><strong>WSCandis WSDL:</strong></td>
										<td><input type="text" name="directoryServiceWSDL" value="#directoryServiceWSDL#"  style="width:360px;" class="frmField"></td>
									</tr>
									<tr>
										<td><strong>WebServiceFactory path:</strong></td>
										<td><input type="text" name="pathToFactory" value="#pathToFactory#"  style="width:360px;" class="frmField"></td>
									</tr>
									<tr>
										<td><strong>Service Name:</strong></td>
										<td>
											<select name="wsName" class="frmField" style="width:360px;">
												<cfloop from="1" to="#arrayLen(aResources)#" index="i">
													<option value="#aResources[i]#">#aResources[i]#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<tr><td colspan="2" align="center">&nbsp;</td></tr>
									<tr>
										<td colspan="2" align="center">
											<input type="submit" name="action" value="getService">
											<input type="submit" name="action" value="startFactory">
										</td>
									</tr>
								</table>
							</form>
							</td>
						</tr>
					</table>

					<div class="tblBottomContent">
						<cfif bError>
							<B>ERROR:</B> #errorDump.message#<br>
							#errorDump.detail#
						</cfif>
					
						<h2>Cached WebService Stubs:</h2>
						<cfif structKeyExists(application, "oWebServiceFactory")>
							#application.oWebServiceFactory.getWebServiceCache().toHTML()#
						<cfelse>
							<b>Factory not started.</b>	
						</cfif>
				
						<cfif isDefined("ws")>
							<h2>Service:</h2>
							Returned service is of class:  <u>#ws.getClass().getName()#</u>
						</cfif>
					
					</div>			
				</div>
			</body>
		</head>
	</html>

</cfoutput>
