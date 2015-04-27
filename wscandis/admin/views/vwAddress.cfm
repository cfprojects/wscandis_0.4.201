<cfparam name="request.requestState.service" default="">
<cfparam name="request.requestState.oResource" default="">
<cfparam name="request.requestState.oAddress" default="">
<cfparam name="request.requestState.index" default="0">

<cfset service = request.requestState.service>
<cfset oResource = request.requestState.oResource>
<cfset oAddress = request.requestState.oAddress>
<cfset index = request.requestState.index>

<cfoutput>

	<cfif index eq 0>
		<h2>Add WSDL Address</h2>
	<cfelse>
		<h2>Edit WSDL Address</h2>
	</cfif>

	<form name="frmService" method="post" action="index.cfm">
		<input type="hidden" name="event" value="ehService.doSaveAddress">
		<input type="hidden" name="service" value="#service#">
		<input type="hidden" name="index" value="#index#">

		<table style="font-size:11px;">
			<tr>
				<td><strong>Referrer:</strong></td>
				<td>
					<input type="text" name="referrer" value="#oAddress.getReferrer()#" class="formField" style="width:500px;"><br>
					<span style="font-size:10px;">Use * to match any server</span>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td><strong>WDSL:</strong></td>
				<td><input type="text" name="href" value="#oAddress.getHREF()#" class="formField" style="width:500px;"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" name="btnSave" value="Apply Changes">&nbsp;
					<input type="button" name="btnCancel" value="Return" onclick="document.location='index.cfm?event=ehService.dspEdit&service=#service#'">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>