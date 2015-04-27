<!--- Start --->
<cfparam name="request.requestState.stInfo" default="structNew()">
<cfparam name="request.requestState.txtSearch" default="">
<cfparam name="request.requestState.aResources" default="#arrayNew(1)#">

<cfset stInfo = request.requestState.stInfo>
<cfset txtSearch = request.requestState.txtSearch>
<cfset aResources = request.requestState.aResources>

<cfset qryResources = QueryNew("name,ttl,description")>
<cfloop from="1" to="#arrayLen(aResources)#" index="i">
	<cfset queryAddRow(qryResources)>
	<cfset querySetCell(qryResources, "name", aResources[i].getName())>
	<cfset querySetCell(qryResources, "ttl", aResources[i].getTTL())>
	<cfset querySetCell(qryResources, "description", aResources[i].getDescription())>
</cfloop>
<cfquery name="qryResources" dbtype="query">
	SELECT *
		FROM qryResources
		ORDER BY name
</cfquery>

<cfoutput>
	<table width="100%">
		<tr>	
			<td>
				<!--- Search:
				<input type="text" name="txtSearch" value="#txtSearch#">
				<input type="submit" name="btnSearch" value="Go"> --->
				<h2>Registered Services</h2>
			</td>
			<td align="right" width="300">
				<b>WSCandis Service is: </b>
				<cfif stInfo.isRunning>
					<span style="color:green;font-weight:bold;">Running</span>
					<span style="font-size:12px;">(<a href="index.cfm?event=ehGeneral.doStop">Stop</a>)</span>
					<div style="font-size:9px;">
						<strong>Last Start:</strong> 
						#lsdateformat(stInfo.startedOn)# #lstimeformat(stInfo.startedOn)#
					</div>
				<cfelse>
					<span style="color:red;font-weight:bold;">Stopped</span>
					<span style="font-size:12px;">(<a href="index.cfm?event=ehGeneral.doStart">Start</a>)</span>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfif stInfo.isRunning>
					<table class="browseTable" style="width:100%">	
						<tr class="listTH listingTableHeader">
							<th width="10">No.</th>
							<th width="290">Service Name</th>
							<th width="50">TTL</th>
							<th>Description</th>
							<th width="60">Actions</th>
						</tr>
					<cfloop query="qryResources">
						<tr class="listingTableCell <cfif qryResources.currentRow mod 2>listTRWhite</cfif>">
							<td width="10" align="right"><strong>#qryResources.currentRow#.</strong></td>
							<td width="290">
								<a href="index.cfm?event=ehService.dspEdit&service=#qryResources.name#">#qryResources.name#</a>
							</td>
							<td width="50" align="center">#qryResources.ttl#</td>
							<td>#qryResources.description#</td>
							<td align="center" width="60">
								<a href="index.cfm?event=ehService.dspEdit&service=#qryResources.name#">
									<img alt="Edit" width="16" height="16" src="images/icons/cog_edit.png" border="0" /></a>
								<a href="javascript:if(confirm('Delete Service?')) document.location='index.cfm?event=ehService.doDelete&service=#qryResources.name#'">
									<img alt="Delete" width="16" height="16" src="images/icons/cog_delete.png" border="0" /></a>
							</td>
						</tr>
					</cfloop>
					</table>
				<cfelse>
					<b>Service not started.</b>	
				</cfif>
			
			</td>
		</tr>
	</table>
</cfoutput>
