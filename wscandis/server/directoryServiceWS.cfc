<cfcomponent name="directoryServiceWS">

	<cfset variables.dataProviderClass = "xmlProvider">
	<cfset variables.logPath = GetDirectoryFromPath(GetCurrentTemplatePath()) & "/logs/">

	<cffunction name="lookup" access="remote" output="false" returntype="lookupResponseTO">
		<cfargument name="name" type="string" required="true">
		<cfargument name="referrer" type="string" required="true">
		
		<cfset oDirectoryService = 0>		
		<cfset oLookupResponseTO = 0>		
		<cfset oService = 0>		
		
		
		<!--- Handle service initialization if necessary --->
		<cfset oService = createObject("component", "service").init()>
		
		<!--- check that the directory service has been started, if not then start it --->
		<cfif Not oService.isRunning()>
			<cflock name="wscandis_start" timeout="5">
				<!--- use double-checked locking to make sure there is only one initialization --->
				<cfif Not oService.isRunning()>
					<cfset oService.start( variables.dataProviderClass )>
				</cfif>
			</cflock>
		</cfif>

	
		<!--- Do lookup --->
		<cfscript>
			try {
				// get handle to directory service
				oDirectoryService = oService.getService();
				
				// Define who is the referrer server, 
				// the referrer argument allows the caller to override the referrer, 
				// otherwise get it from the CGI variables
				if(arguments.referrer eq "") {
					if(cgi.remote_host eq "")  // If there is no hostname then use the IP address
						arguments.referrer = cgi.remote_addr;
					else
						arguments.referrer = cgi.remote_host;
				}
				
				// lookup requested name
				oLookupResponseTO = oDirectoryService.lookup(arguments.name, arguments.referrer);
				
			} catch(any e) {
				// create a blank TO just to send the error back
				oLookupResponseTO = createObject("component","lookupResponseTO");
				oLookupResponseTO.name = arguments.name;
				oLookupResponseTO.address = "";
				oLookupResponseTO.TTL = 0;
				oLookupResponseTO.description = "";
				oLookupResponseTO.referrer = arguments.referrer;
				oLookupResponseTO.error = true;
				oLookupResponseTO.errorMessage = e.message;
			}

			// log request
			oTOLogger = createObject("component", "lookupResponseTOLogger").init(variables.logPath, "responses");
			oTOLogger.logTO(oLookupResponseTO);

			return oLookupResponseTO;
		</cfscript>
	</cffunction>

	<cffunction name="listResources" access="remote" returntype="array" hint="Returns a list of all available resources on the directory">
		<cfscript>
			var aResources = arrayNew(1);
			var oService = 0;
			var oDirectoryService = 0;
	
			// get a reference to service deamon
			oService = createObject("component", "service").init();
			
			// check that the directory service has been started, if not then start it
			if(Not oService.isRunning()) {
				oService.start( variables.dataProviderClass );
			}
			
			aTemp = oService.getService().getDataProvider().getResources();
			
			for(i=1;i lte arrayLen(aTemp);i=i+1) {
				arrayAppend(aResources, aTemp[i].getName());
			}
				
			return aResources;
		</cfscript>
	</cffunction>



</cfcomponent>