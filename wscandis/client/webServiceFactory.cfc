<cfcomponent name="webServiceFactory">

	<cfset variables._inited = false>
	<cfset variables.oDirectoryServiceClient = 0>
	<cfset variables.oWebServiceCache = 0>

	<cffunction name="init" access="public" returntype="webServiceFactory">
		<cfargument name="directoryServiceWSDL" type="string" required="true">
		
		<cfscript>
			// create and initialize directory service client
			variables.oDirectoryServiceClient = createObject("component","directoryServiceClient").init(arguments.directoryServiceWSDL);

			// create and initialize web services cache
			variables.oWebServiceCache = createObject("component","webServiceCache").init();
			
			// flag component as initialized
			variables._inited = true;
			
			return this;
		</cfscript>
	</cffunction>


	<cffunction name="getService" access="public" returntype="Any">
		<cfargument name="wsName" type="string" required="true">
		
		<cfset var ws = 0>
		<cfset var wsdl = "">
		<cfset var oLookupResponseTO = 0>

		<!--- check that component is initialized --->
		<cfif not variables._inited>
			<cfthrow message="WebServiceFactory instance not initialized." type="webServiceFactory.notInitialized">
		</cfif>
		
		<cflock name="wsfactory_#arguments.wsName#" timeout="100">
		<cfscript>
			// check if webservice is already on the cache and still valid
			if(variables.oWebServiceCache.contains(arguments.wsName)) {
			
				// webservice is cached and valid, so get it from the cache
				ws = variables.oWebServiceCache.get(arguments.wsName);
			
			} else {
			
				// webservice is not cached, so get its location from the wsdl 
				oLookupResponseTO = variables.oDirectoryServiceClient.lookup(arguments.wsName);
				
				// check if there was an error on the server side
				if(oLookupResponseTO.error) {
					throw(oLookupResponseTO.errorMessage);
				}
				
				// create instance of the webservic
				ws = createObject("webservice", oLookupResponseTO.getAddress());
				
				// store the webservice instance into the cache
				variables.oWebServiceCache.store(arguments.wsName, ws, oLookupResponseTO.getTTL(), oLookupResponseTO.getDescription(), oLookupResponseTO.getAddress(), oLookupResponseTO.getReferrer());
			
			}
		</cfscript>
		</cflock>
		
		<cfreturn ws>
	</cffunction>


	<cffunction name="getWebServiceCache" access="public" returntype="webServiceCache">
		<cfreturn variables.oWebServiceCache>
	</cffunction>

	<cffunction name="getDirectoryServiceClient" access="public" returntype="directoryServiceClient">
		<cfreturn variables.oDirectoryServiceClient>
	</cffunction>

	<cffunction name="throw" access="private">
		<cfargument name="message" type="string" required="true">
		<cfthrow message="#arguments.message#">
	</cffunction>
	
</cfcomponent>