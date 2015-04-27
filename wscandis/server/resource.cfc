<cfcomponent name="resource">

	<cfscript>
		variables.name = "";
		variables.description = "";
		variables.TTL = 0;
		variables.aAddresses = ArrayNew(1);

		// getters
		function getName() 			{return variables.name;}
		function getDescription() 	{return variables.description;}
		function getTTL() 			{return variables.TTL;}

		// setters
		function setName(value) 	{variables.name = arguments.value;}
		function setDescription(value) {variables.description = arguments.value;}
		function setTTL(value) 		{variables.TTL = arguments.value;}
	</cfscript>

	<cffunction name="init" access="public" returntype="resource">
		<cfargument name="name" type="string" required="true">
		<cfargument name="TTL" type="numeric" required="true">
		<cfargument name="description" type="string" required="true">
		<cfset variables.name = arguments.name>
		<cfset variables.TTL = arguments.TTL>
		<cfset variables.description = arguments.description>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addAddress" access="public" returnType="void">
		<cfargument name="address" type="address" required="true">
		<cfset arrayAppend(variables.aAddresses, arguments.address)>
	</cffunction>

	<cffunction name="removeAddress" access="public" returnType="void">
		<cfargument name="referrer" type="string" required="true">
		<cfscript>
			var i = 0;
			
			for(i=1;i lte arrayLen(variables.aAddresses);i=i+1) {
				if(variables.aAddresses[i].getReferrer() eq arguments.referrer) {
					arrayDeleteAt(variables.aAddresses, i);
					break;
				}
			}
		</cfscript>
	</cffunction>

	<cffunction name="getAddresses" access="public" returnType="array">
		<cfreturn variables.aAddresses>
	</cffunction>

	<cffunction name="toHTML" access="public" returntype="string">
		<cfset var tmpHTML = "">
		<cfset var i = 1>
		
		<cfsavecontent variable="tmpHTML">
			<cfoutput>
				<tr>
					<td>#variables.name#</td>
					<td align="center">#variables.TTL#</td>
					<td>#variables.description#</td>
					<td>
						<cfloop from="1" to="#arrayLen(aAddresses)#" index="i">
							<li><a href="#aAddresses[i].getHREF()#" target="_blank">#aAddresses[i].getHREF()#</a> [#aAddresses[i].getReferrer()#]</li>
						</cfloop>
					</td>
				</tr>
			</cfoutput>
		</cfsavecontent>

		<cfreturn tmpHTML>
	</cffunction>


</cfcomponent>