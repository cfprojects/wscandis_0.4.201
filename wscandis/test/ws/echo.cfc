<cfcomponent output="false">

	<cffunction name="echo" access="remote" output="false" returntype="String">
		<cfargument name="message" type="String" required="true" />
		<cfreturn "[#cgi.SERVER_NAME#] " & arguments.message />
	</cffunction>
</cfcomponent>