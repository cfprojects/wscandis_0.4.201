<cfcomponent name="lookupResponseTOLogger" extends="logger" hint="maintains a log file of lookupResponseTO objects">
	
	<cffunction name="logTO" access="public" returntype="void" hint="adds an entry to the log based on the contents of the give transfer object">
		<cfargument name="TO" type="lookupResponseTO" required="true">
		<cfscript>
			var msg = "";
			var msgSeverity = "information";

			// create the base log message
			msg = arguments.TO.name & " | " & arguments.TO.address & " | " & arguments.TO.referrer;	

			// if this TO carries an error, then log it as an error		
			if(arguments.TO.error) {
				msgSeverity = "error";
				msg = msg & " | " & arguments.TO.errorMessage;			
			} 
			
			// write to log
			logEntry(msgSeverity, msg);
		</cfscript>
	</cffunction>

	
</cfcomponent>