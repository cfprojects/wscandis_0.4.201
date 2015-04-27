<cfcomponent name="webServiceInfo">

	<cfset variables.ws = 0>
	<cfset variables.wsName = "">
	<cfset variables.TTL = 0>
	<cfset variables.wsdl = 0>
	<cfset variables.addedOn = Now()>
	<cfset variables.description = "">
	<cfset variables.expiresOn = Now()>
	<cfset variables.hitCount = 0>
	<cfset variables.referrer = "">
	
	<cffunction name="init" access="public" returntype="webServiceInfo">
		<cfargument name="wsName" type="string" required="true">
		<cfargument name="ws" type="any" required="true">
		<cfargument name="TTL" type="numeric" required="true">
		<cfargument name="description" type="string" required="false">
		<cfargument name="wsdl" type="string" required="false">
		<cfargument name="referrer" type="string" required="false">
		
		<cfset variables.ws = arguments.ws>
		<cfset variables.wsName = arguments.wsName>
		<cfset variables.TTL = arguments.TTL>
		<cfset variables.description = arguments.description>
		<cfset variables.wsdl = arguments.wsdl>
		<cfset variables.addedOn = Now()>
		<cfset variables.expiresOn = DateAdd("n", arguments.TTL, Now())>
		<cfset variables.hitCount = 0>
		<cfset variables.referrer = arguments.referrer>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isExpired" access="public" returntype="boolean">
		<cfreturn (DateCompare(variables.expiresOn, Now(), "n") lte 0)>
	</cffunction>

	<cffunction name="getWS" access="public" returntype="any">
		<cfset variables.hitCount = variables.hitCount + 1>
		<cfreturn variables.ws>
	</cffunction>

	<cffunction name="toHTML" access="public" returntype="string">
		<cfset var tmpHTML = "">
		
		<cfsavecontent variable="tmpHTML">
			<cfoutput>
				<tr>
					<td>#variables.wsName#</td>
					<td align="center">#variables.TTL#</td>
					<td align="center" nowrap>#lsDateFormat(variables.addedOn)#<br>#lsTimeFormat(variables.addedOn)#</td>
					<td align="center" nowrap>#lsDateFormat(variables.expiresOn)#<br>#lsTimeFormat(variables.expiresOn)#</td>
					<td align="center">#variables.hitCount#</td>
					<td>#variables.referrer#</td>
					<td><a href="#variables.wsdl#" target="_blank">#variables.wsdl#</a></td>
				</tr>
			</cfoutput>
		</cfsavecontent>

		<cfreturn tmpHTML>
	</cffunction>

</cfcomponent>