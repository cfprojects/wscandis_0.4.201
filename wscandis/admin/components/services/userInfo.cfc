<cfcomponent displayname="userInfo">
	
	<cffunction name="init" access="public" returntype="userInfo">
		<cfscript>
			this.data = structNew();
			this.data.username = "";
			this.data.lstRoles = "";
			this.data.userID = 0;
			this.data.appuser = "";
		</cfscript>
		<cfreturn this>
	</cffunction>

	
	<!------------------------------>
	<!--- set/getRoles         ----->
	<!------------------------------>
	<cffunction name="setRoles" access="public" hint="stores the list of roles to which the user belongs">
		<cfargument name="userRoles" type="string" required="yes">
		<cfset setAttribute("lstRoles",arguments.userRoles)>	
	</cffunction>
	
	<cffunction name="getRoles" access="public" returntype="string" hint="retrieves the user roles list">
		<cfreturn getAttribute("lstRoles")>	
	</cffunction>

	<!------------------------------>
	<!--- set/getUsername      ----->
	<!------------------------------>
	<cffunction name="setUsername" access="public" hint="stores the username">
		<cfargument name="username" type="string" required="yes">
		<cfset setAttribute("username",arguments.username)>	
	</cffunction>
	
	<cffunction name="getUsername" access="public" returntype="string" hint="retrieves the username">
		<cfreturn getAttribute("username")>	
	</cffunction>

	<!------------------------------>
	<!--- set/getAttribute     ----->
	<!------------------------------>
	<cffunction name="setAttribute" access="public" hint="adds an attribute to the current user">
		<cfargument name="attribute" type="any" required="yes">
		<cfargument name="value" type="any" required="yes">
		
		<cfif arguments.attribute eq "">
			<cfthrow message="An attribute name cannot be empty.">
		</cfif>
		
		<cfset this.data[trim(arguments.attribute)] = arguments.value>
	</cffunction>
	
	<cffunction name="getAttribute" access="public" hint="retrieves the value of an attribute" returntype="any">
		<cfargument name="attribute" type="any" required="yes">
		
		<cfif StructKeyExists(this.data, arguments.attribute)>
			<cfreturn this.data[arguments.attribute]>
		<cfelse>
			<cfthrow message="The requested attribute does not exist">
		</cfif>
	</cffunction>
	
	
	<!------------------------------>
	<!--- set/getInstanceData  ----->
	<!------------------------------>
	<cffunction name="setInstanceData" access="public" hint="stores the instance data for this cfc">
		<cfargument name="instanceData" type="any" required="yes">
		<cfset this.data = duplicate(arguments.instanceData)>	
	</cffunction>
	
	<cffunction name="getInstanceData" access="public" returntype="struct" hint="retrieves the instance data for this cfc">
		<cfreturn this.data>	
	</cffunction>	
	
</cfcomponent>