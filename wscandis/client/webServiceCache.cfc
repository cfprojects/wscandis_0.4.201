<cfcomponent name="webServiceCache">
	
	<cfset variables._inited = false>
	<cfset variables.serviceCache = structNew()>
	
	<cffunction name="init" access="public" returntype="webServiceCache">
		
		<cfscript>
			// initialize data structure for the cache
			variables.serviceCache = structNew();

			// flag component as initialized
			variables._inited = true;
		
			return this;
		</cfscript>
	
	</cffunction>


	<cffunction name="contains" access="public" returntype="boolean">
		<cfargument name="wsName" type="string" required="true">
		
		<cfreturn structKeyExists(variables.serviceCache, arguments.wsName) 
					and isObject(variables.serviceCache[arguments.wsName])
					and Not variables.serviceCache[arguments.wsName].isExpired()>
		
	</cffunction>


	<cffunction name="get" access="public" returntype="any">
		<cfargument name="wsName" type="string" required="true">
		<cfreturn variables.serviceCache[arguments.wsName].getWS()>
	</cffunction>


	<cffunction name="store" access="public" returntype="void">
		<cfargument name="wsName" type="string" required="true">
		<cfargument name="ws" type="any" required="true">
		<cfargument name="TTL" type="numeric" required="true">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="address" type="string" required="false" default="">
		<cfargument name="referrer" type="string" required="false" default="">
			
		<cfscript>
			var oWebServiceInfo = createObject("component","webServiceInfo");
			
			// initialize webServiceInfo object
			oWebServiceInfo.init(arguments.wsName, arguments.ws, arguments.TTL, arguments.description, arguments.address, arguments.referrer);
		
			// add object to cache
			variables.serviceCache[arguments.wsName] = oWebServiceInfo;
		
		</cfscript>	
				
	</cffunction>


	<cffunction name="flush" access="public" returntype="void">
		<cfargument name="wsName" type="string" required="false" default="">
		
		<cfif arguments.wsName neq "">
			<cfset structDelete(variables.serviceCache, arguments.wsName)>
		<cfelse>
			<cfset variables.serviceCache = structNew()>
		</cfif>
	</cffunction>


	<cffunction name="flushExpired" access="public" returntype="void">
		<cfloop collection="#variables.stCache#" item="wsName">
			<cfif variables.serviceCache[wsName].isExpired()>
				<cfset structDelete(variables.serviceCache, wsName)>
			</cfif>
		</cfloop>
	</cffunction>


	<cffunction name="toHTML" access="public" returntype="string">
		<cfset var tmpHTML = "">
		<cfset var tmpBody = "">
		
		<cfloop collection="#variables.serviceCache#" item="wsItem">
			<cfset tmpBody = tmpBody & variables.serviceCache[wsItem].toHTML()>
		</cfloop>

		<cfsavecontent variable="tmpHTML">
			<table style="border-collapse:collapse;font-size:11px;font-family:arial;" cellspacing="0" width="90%" border="1">
				<tr>
					<th>Service Name</th>
					<th>TTL</th>
					<th>Added On</th>
					<th>Expires On</th>
					<th>Hits</th>
					<th>Referrer</th>
					<th>WSDL</th>
				</tr>
				<cfoutput>#tmpBody#</cfoutput>
			</table>
		</cfsavecontent>

		<cfreturn tmpHTML>
	</cffunction>

</cfcomponent>