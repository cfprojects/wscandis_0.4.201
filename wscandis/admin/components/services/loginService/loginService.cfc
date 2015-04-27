<cfcomponent hint="Base component for the user authentication service">
	<cfset variables.aSysAdmins = arrayNew(1)>

	<cffunction name="init" access="public" description="Component constructor">
		<cfargument name="authType" type="string" required="yes">
		<cfset this.config = structNew()>
		<cfset this.config = duplicate(arguments)>
	</cffunction>


	<cffunction name="setSysAdmins" access="public" description="Sets the usernames that have the sysadmin role">
		<cfargument name="aSysAdmins" type="array" required="yes">
		<cfset variables.aSysAdmins = arguments.aSysAdmins>
	</cffunction>


	<cffunction name="authenticateUser" access="public" returntype="loginMessage" description="Authenticates a user">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">

		<!--- create an empty instance of loginMessage to return --->		
		<cfset var obj = CreateObject("component","loginMessage")>
	
		<cfreturn obj>		
	</cffunction>


	<cffunction name="isSysAdmin" access="public" returntype="boolean" description="Checks whether the given username belongs to the sysadmin role">
		<cfargument name="username" type="string" required="yes">
		<cfset var rtn = false>
		<cfloop from="1" to="#arrayLen(variables.aSysAdmins)#" index="i">
			<cfif arguments.username eq variables.aSysAdmins[i]>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfreturn false>
	</cffunction>

</cfcomponent>