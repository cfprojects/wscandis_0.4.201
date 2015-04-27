<cfparam name="request.requestState.service" default="">
<cfparam name="request.requestState.oResource" default="">
<cfset oResource = request.requestState.oResource>
<cfset service = request.requestState.service>


<cfoutput>

	<cfif service eq "">
		<h2>Create Service</h2>
	<cfelse>
		<h2>Edit Service</h2>
	</cfif>

	<form name="frmService" method="post" action="index.cfm">
		<input type="hidden" name="event" value="ehService.doSave">
		<input type="hidden" name="service" value="#service#">
		<table style="font-size:11px;">
			<tr>
				<td>Name:</td>
				<td><input type="text" name="name" value="#oResource.getName()#" class="formField"></td>
			</tr>
			<tr valign="top">
				<td>Description:</td>
				<td>
					<textarea name="description" class="formField" rows="5">#oResource.getDescription()#</textarea>
				</td>
			</tr>
			<tr>
				<td>Time To Live:</td>
				<td><input type="text" name="ttl" value="#oResource.getTTL()#" class="formField" style="width:50px;"> minutes</td>
			</tr>
			<tr><td colspan="2" align="right"><input type="submit" name="btnSave" value="Apply Changes"></td></tr>
		</table>
	</form>
	<br>
	
	<cfif service neq  "">
		<cfset aAddresses = oResource.getAddresses()>
		
		<h2>WSDL Addresses:</h2>
		<table class="browseTable" style="width:100%">	
			<tr class="listTH listingTableHeader">
				<th width="10">No.</th>
				<th width="290">Referrer</th>
				<th>WSDL</th>
				<th width="60">Actions</th>
			</tr>			
			<cfloop from="1" to="#arrayLen(aAddresses)#" index="i">
				<tr class="listingTableCell <cfif i mod 2>listTRWhite</cfif>">
					<td width="10" align="right"><strong>#i#.</strong></td>
					<td width="290">#aAddresses[i].getReferrer()#</td>
					<td width="290"><a href="#aAddresses[i].getHREF()#" target="_blank">#aAddresses[i].getHREF()#</a></td>
					<td align="center">
						<a href="index.cfm?event=ehService.dspEditAddress&service=#service#&index=#i#">
							<img alt="Edit" width="16" height="16" src="images/icons/world_edit.png" border="0" /></a>
						<a href="javascript:if(confirm('Delete Address?')) document.location='index.cfm?event=ehService.doDeleteAddress&service=#service#&index=#i#'">
							<img alt="Delete" width="16" height="16" src="images/icons/world_delete.png" border="0" /></a>
					</td>
				</tr>
			</cfloop>
		</table>
		
		<div style="margin-top:10px;">
			<a href="index.cfm?event=ehService.dspEditAddress&service=#service#">
				<img alt="Add" width="16" height="16" src="images/icons/world_add.png" border="0" align="absmiddle" /></a>
			<a href="index.cfm?event=ehService.dspEditAddress&service=#service#" style="color:##990000;font-weight:bold;">Add WSDL Address</a>
		</div>
		
	</cfif>
		
</cfoutput>
