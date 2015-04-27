<cfcomponent extends="loginService" hint="Performs user authentication using a simple user and password">

	<cffunction name="authenticateUser" access="public" returntype="loginMessage">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<cfset var x = "5DD77054BFC9046A420187228117A328">
		<cfset var y = "26A78071B91DF6855B7A5E5194C88E47">
		<cfset var pwd = hash(x & arguments.password & y,'SHA-1')>
		
		<!--- create an instance of loginInfo to return --->		
		<cfset var oLoginMessage = CreateObject("component","loginMessage")>

		<cfscript>
			// authenticate against a fixed user and password
			oLoginMessage.authenticated = (this.config.suser eq arguments.username 
											AND this.config.spwd eq pwd);
			
			// set roles
			oLoginMessage.roles = "user";
			if(isSysAdmin(arguments.username)) 
				oLoginMessage.roles = listAppend(oLoginMessage.roles,"_sysadmin");
		
		</cfscript>

		 <cfreturn oLoginMessage>
	</cffunction>
	
</cfcomponent>