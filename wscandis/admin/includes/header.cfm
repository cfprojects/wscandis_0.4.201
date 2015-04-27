<cfparam name="request.requestState.hostName" default="">
<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfparam name="request.requestState.oUserInfo" default="0">

<cfoutput>
<table width="100%">
	<tr>
		<td>
			<img src="images/wscandis_logo.gif" 
					style="margin-top:3px;margin-bottom:5px;margin-left:10px;" >
		</td> 
		<td align="right" style="padding-right:10px;">
			<div style="line-height:25px;font-weight:bold;">
				#request.requestState.applicationTitle#
			</div>

			<span style="font-size:10px;color:##fff;font-weight:bold;">
				<cfif Not IsSimpleValue(request.requestState.oUserInfo)>
					#request.requestState.oUserInfo.getUsername()#
				</cfif>
			</span>

			<cfif request.requestState.hostName neq "">
				<span style="font-size:10px;color:##fff;font-weight:bold;">
					&nbsp;&nbsp;|&nbsp;&nbsp;
					#request.requestState.hostName#
				</span>
			</cfif>
			
			&nbsp;&nbsp;|&nbsp;&nbsp;
			<a href="javascript:if(confirm('Exit application?')) document.location='index.cfm?event=ehGeneral.doLogout'"><img src="images/icons/door_in.png" align="absmiddle" border="0"></a>
			<a href="javascript:if(confirm('Exit application?')) document.location='index.cfm?event=ehGeneral.doLogout'" style="color:##fff;font-size:10px;"><b>Log Out</b></a>
		</td>
	</tr>
</table>
</cfoutput>
