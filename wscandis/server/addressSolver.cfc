<cfcomponent name="addressSolver">

	<cffunction name="solve" access="public" returnType="address">
		<cfargument name="referrer" type="string" required="true">
		<cfargument name="resource" type="resource" required="true">
		
		<cfscript>
			var aAddresses = arguments.resource.getAddresses();
			var i = 1;
			
			for(i=1; i lte arrayLen(aAddresses); i=i+1) {
				if(aAddresses[i].match(arguments.referrer)) {
					return aAddresses[i];
				}
			}
		</cfscript>
		<cfthrow message="Address could not be resolved. Check referrer rules">
	</cffunction>

</cfcomponent>