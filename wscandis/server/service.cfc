<cfcomponent>
	
	<cfset variables.serviceName = "_directoryService">
	<cfset variables.logPath = GetDirectoryFromPath(GetCurrentTemplatePath()) & "/logs/">

	<cffunction name="init" returntype="service" access="public" hint="constructor">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="start" returntype="void" access="public" hint="Starts the DirectoryService">
		<cfargument name="dataProviderClass" type="string" required="true" hint="A subclass of dataProvider.cfc to use">
		<cfscript>
			var oDataProvider = 0;
			var oDirectoryService = 0;
			var oLogger = 0;

			// create the data provider
			oDataProvider = createObject("component", arguments.dataProviderClass);
			oDataProvider.init();
			
			// create the directory service
			oDirectoryService = createObject("component", "directoryService");
			oDirectoryService.init(oDataProvider);
			
			// store the directory service on the application scope
			server[variables.serviceName] = oDirectoryService;				

			// log that the service has been started			
			oLogger = createObject("component", "logger").init(variables.logPath, "responses");
			oLogger.logEntry("information","Service started. Instance located at: server.#serviceName#");
		</cfscript>
	</cffunction>

	<cffunction name="stop" returntype="void" access="public" hint="Stops the DirectoryService">
		<cfscript>
			var oLogger = 0;
			
			// remove instance
			structDelete(server, variables.serviceName);
			
			// log that the service has been stopped			
			oLogger = createObject("component", "logger").init(variables.logPath, "responses");
			oLogger.logEntry("information","Service stopped.");
		</cfscript>
	</cffunction>

	<cffunction name="getService" returntype="directoryService" access="public" hint="Returns the currently running instance of the service">
		<cfreturn server[variables.serviceName]>
	</cffunction>

	<cffunction name="isRunning" returntype="boolean" access="public" hint="Returns whether the directory service is running or not">
		<cfreturn structKeyExists(server, variables.serviceName)>
	</cffunction>

</cfcomponent>