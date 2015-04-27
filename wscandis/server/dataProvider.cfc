<cfcomponent name="dataProvider">

	<cfscript>
		variables.defaultTTL = 0;
		variables.resources = structNew();
		variables.lastRefresh = Now();
		variables.configHREF = GetDirectoryFromPath(GetCurrentTemplatePath()) & "/dataProvider-config.xml";
		variables.settings = structNew();
	</cfscript>

	<!--- Abstract Methods --->
	<cffunction name="init" access="public" returntype="dataProvider" hint="This is the constructor">
		<cfscript>
			var xmlDoc = 0;

			// read settings
			xmlDoc = xmlParse(variables.configHREF);
			
			for(i=1;i lte arrayLen(xmlDoc.xmlRoot.xmlChildren);i=i+1) {
				xmlNode = xmlDoc.xmlRoot.xmlChildren[i];
				variables.settings[xmlNode.xmlName] = xmlNode.xmlText;
			}

			// populate data
			refresh();		
			
			return this;		
		</cfscript>
	</cffunction>

	<cffunction name="refresh" access="public" returntype="void" hint="Reloads data from the persistent storage">
		<cfthrow message="This method must be overloaded by a child">
	</cffunction>

	<cffunction name="update" access="public" returntype="void" hint="Updates the persistent storage with current data">
		<cfthrow message="This method must be overloaded by a child">
	</cffunction>


	<!--- Public Methods --->
	<cffunction name="getDefaultTTL" access="public" returntype="numeric">
		<cfreturn variables.defaultTTL>
	</cffunction>

	<cffunction name="setDefaultTTL" access="public" returntype="void">
		<cfargument name="TTL" type="numeric" required="true">
		<cfset variables.defaultTTL = arguments.TTL>
	</cffunction>

	<cffunction name="getResource" access="public" returntype="resource">
		<cfargument name="name" type="string" required="true">
		<cfif structKeyExists(variables.resources, arguments.name)>
			<cfreturn variables.resources[arguments.name]>
		<cfelse>
			<cfthrow message="Resource '#arguments.name#' does not exist!">
		</cfif>
	</cffunction>

	<cffunction name="getResources" access="public" returntype="array">
		<cfscript>
			var aResources = arrayNew(1);
			
			for(r in variables.resources) {
				arrayAppend(aResources, variables.resources[r]);
			}
			
			return aResources;
		</cfscript>
	</cffunction>
	
	<cffunction name="addResource" access="public" returntype="void">
		<cfargument name="oResource" type="resource" required="true">
		<cfset variables.resources[arguments.oResource.getName()] = arguments.oResource>
	</cffunction>

	<cffunction name="deleteResource" access="public" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfset structDelete(variables.resources, arguments.name)>
	</cffunction>
	
	<cffunction name="toHTML" access="public" returntype="string">
		<cfset var tmpHTML = "">
		<cfset var tmpBody = "">
		
		<cfloop collection="#variables.resources#" item="item">
			<cfset tmpBody = tmpBody & variables.resources[item].toHTML()>
		</cfloop>

		<cfsavecontent variable="tmpHTML">
			<table style="border-collapse:collapse;font-size:11px;font-family:arial;" cellspacing="0" width="90%" border="1">
				<tr>
					<th>Service Name</th>
					<th>TTL</th>
					<th>Description</th>
					<th>Addresses</th>
				</tr>
				<cfoutput>#tmpBody#</cfoutput>
			</table>
		</cfsavecontent>

		<cfreturn tmpHTML>
	</cffunction>
	
</cfcomponent>
