<cfparam name="username" default="">
<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfparam name="request.requestState.contactEmail" default="">
<cfparam name="request.requestState.versionTag" default="">
<cfset versionTag = request.requestState.versionTag>
<cfset contactEmail = request.requestState.contactEmail>

<link href="includes/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
	body {
		background-image:none;
	}
	.tblLogin {
		border:1px solid #CCCCCC;
		width:500px;
		margin-top:200px;
		margin-bottom:100px;
	}
	.tblLogin th {
		font-weight:bold;
		height:50px;
		line-height:50px;
		padding-top:2px;
		border-top:1px solid #CCCCCC;
		border-bottom:1px solid #CCCCCC;
		background-color:#EEEEEE;
		font-size:16px;
	}
	.info {
		width:150px;
		font-size:12px;
		line-height:14px;
		background-color:#ebebeb;
		border-left:1px solid silver;
		padding:10px;
		font-family:"Trebuchet MS";
	}
</style>
<br>

<cfoutput>
	<form name="frmLogin" action="index.cfm" method="post">
		<input type="hidden" name="event" value="ehGeneral.doLogin">
		
		<table align="center" border="0" cellpadding="2" cellspacing="0" class="tblLogin">
			<tr>
				<th colspan="6" style="background-color:##6b8091;color:##fff;" align="right">
					<img src="images/wscandis_logo.gif" style="margin:3px;;" align="left">					
					#request.requestState.applicationTitle# Login &nbsp;
				</th>
			</tr>
			<tr>
				<td colspan="2" class="headingbar" valign="top">&nbsp;</td>
				<td rowspan="4" class="info">
					If you are experiencing problems with your login or would like to request
					access to this application, please submit an email to <a href="mailto:#contactEmail#">#contactEmail#</a>
				</td>
			</tr>
			<tr>
				<td width="100" valign="middle" style="font-size:11px;" align="right"><b>Username:</b></td>
				<td valign="middle" colspan="2">
					<input style="font-size:11px;width:200px" 
							type="text" name="j_username" 
							required="yes" message="Your email address is required">
				</td>
			</tr>
			<tr>
				<td valign="middle" style="font-size:11px;" align="right"><b>Password:</b></td>
				<td valign="middle">
					<input style="font-size:11px;width:200px"
							type="password" name="j_password" 
							required="yes" message="Your password is required">
				</td>
			</tr>
			<tr><td colspan="2" class="headingbar" valign="top">&nbsp;</td></tr>
			<tr>
				<th colspan="3" style="height:25px;"><input type="image" src="./images/signin.gif" width="76" height="20"></td>
			</tr>
		</table>
		<cfinclude template="../includes/footer.cfm">
	</form>
</cfoutput>

