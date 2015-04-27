<cfcomponent name="address">

	<cfscript>
		variables.href = "";
		variables.referrer = "";

		// getters
		function getHREF() 			{return variables.href;}
		function getReferrer() 		{return variables.referrer;}

		// setters
		function setHREF(value) 	{variables.href = arguments.value;}
		function setReferrer(value) {variables.referrer = arguments.value;}
	</cfscript>

	<cffunction name="init" access="public" returntype="address">
		<cfargument name="href" type="string" required="true">
		<cfargument name="referrer" type="string" required="true">
		<cfset variables.href = arguments.href>
		<cfset variables.referrer = arguments.referrer>
		<cfreturn this>
	</cffunction>

	<cffunction name="match" access="public" returntype="boolean">
		<cfargument name="name" type="string" required="true">
		<cfreturn (variables.referrer eq "*" or variables.referrer eq arguments.name)>
	</cffunction>
	
	
</cfcomponent>