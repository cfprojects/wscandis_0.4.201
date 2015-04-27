<cfcomponent displayname="loginMessage" hint="This component is used only to return login status information about users">
	
	<!--- constructor --->
	<cfset init()>
	
	<cffunction name="init" access="private" returntype="any">
		<cfscript>
			this.authenticated = false;
			this.roles = "";	
			this.errorMessage = "";  //use to return error messages during authentication
			this.userData = "";	
		</cfscript>
	</cffunction>
	
</cfcomponent>