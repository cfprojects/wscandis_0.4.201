<cfcomponent hint="Provides a placeholder to store references to services. Acts as a singleton">
	<cfset variables.name = "_appServices">

	<cffunction name="init" access="public" returntype="map">
		<cfreturn this>
	</cffunction>

	<cffunction name="registerService" access="public" returntype="void" hint="registers a service">
		<cfargument name="key" type="string" required="true">	
		<cfargument name="instance" type="WEB-INF.cftags.component" required="true">	
		<cfif Not structKeyExists(application, variables.name)>
			<cfset application[variables.name] = structNew()>
		</cfif>
		<cfset application[variables.name][arguments.key] = arguments.instance>
	</cffunction>	

	<cffunction name="getService" access="public" returnType="WEB-INF.cftags.component" hint="returns the requested service instance">
		<cfargument name="key" type="string" required="true">
		<cfif structKeyExists(application[variables.name], arguments.key)>
			<cfreturn application[variables.name][arguments.key]>
		<cfelse>
			<cfthrow message="Service not registered" type="serviceRegistry.invalidService">
		</cfif>
	</cffunction>			
	
</cfcomponent>