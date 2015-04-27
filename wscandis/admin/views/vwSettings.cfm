<cfparam name="request.requestState.wscandisPath" default="">
<cfparam name="request.requestState.dataProviderClass" default="">
<cfparam name="request.requestState.dataProviderConfigHREF" default="">
<cfparam name="request.requestState.logsPath" default="">

<cfset wscandisPath = request.requestState.wscandisPath>
<cfset dataProviderClass = request.requestState.dataProviderClass>
<cfset dataProviderConfigHREF = request.requestState.dataProviderConfigHREF>
<cfset logsPath = request.requestState.logsPath>

<h2>Settings</h2>

<cfoutput>
	<table style="font-size:11px;">
		<tr>
			<td width="150"><b>Path to WSCandis CFCs:</b></td>
			<td>#wscandisPath#</td>
		</tr>
		<tr>
			<td><b>Data Provider Class:</b></td>
			<td>#dataProviderClass#</td>
		</tr>
		<tr>
			<td><b>Data Provider Config:</b></td>
			<td><a href="#dataProviderConfigHREF#" target="_blank">#dataProviderConfigHREF#</a></td>
		</tr>
		<tr>
			<td><b>Logs Path:</b></td>
			<td><a href="#logsPath#" target="_blank">#logsPath#</a></td>
		</tr>
	</table>
</cfoutput>
<br />


<h2>Change Password:</h2>
<form name="frm" action="index.cfm" method="post">
	<input type="hidden" name="event" value="ehGeneral.doChangePassword">
	<table style="font-size:11px;">
		<tr>
			<td>Old Password:</td>
			<td><input type="password" name="old_pwd" value="" class="formField"></td>
		</tr>
		<tr>
			<td>New Password:</td>
			<td><input type="password" name="new_pwd" value="" class="formField"></td>
		</tr>
		<tr>
			<td>Confirm New Password:</td>
			<td><input type="password" name="new_pwd2" value="" class="formField"></td>
		</tr>
		<tr><td colspan="2" align="right"><input type="submit" name="btnSave" value="Change Password"></td></tr>
	</table>
</form>