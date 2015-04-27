<cfcomponent>
	
	<cfset variables.wscandisPath = "">
	<cfset variables.wscandisCFCPath = "">
	<cfset variables.dataProviderClass = "">
	<cfset variables.OSPathSeparator = createObject("java","java.lang.System").getProperty("file.separator")>
	<cfset variables.wscandisLogsPath = "">

	<cffunction name="init" access="public" returntype="appService">
		<cfargument name="wscandisPath" type="string" required="true">
		<cfargument name="dataProviderClass" type="string" required="true">
		
		<cfset variables.wscandisPath = arguments.wscandisPath>
		<cfset variables.dataProviderClass = arguments.dataProviderClass>

		<!--- make sure the path ends with a "/" --->
		<cfif right(variables.wscandispath,1) neq "/">
			<cfset variables.wscandispath = variables.wscandispath & "/">
		</cfif>

		<!--- get the path in dot notation --->
		<cfset variables.wscandisCFCPath = replace(variables.wsCandisPath, "/", ".", "ALL")>
		<cfif len(variables.wsCandisCFCPath) gt 1 and left(variables.wsCandisCFCPath,1) eq ".">
			<cfset variables.wscandisCFCPath = right(variables.wscandisCFCPath, len(variables.wscandisCFCPath)-1)>
		<cfelse>
			<cfset variables.wscandisCFCPath = "">
		</cfif>

		<!--- set the correct path to the dataProviderClass in dot notation --->
		<cfif not find(".", variables.dataProviderClass)>
			<cfset variables.dataProviderClass = variables.wscandisCFCPath & "server." & variables.dataProviderClass>
		</cfif>

		<!--- set the path to the logs --->
		<cfset variables.wscandisLogsPath = variables.wscandisPath & "server/logs/">

		<cfreturn this>		
	</cffunction>

	<!--- Interface for Directory Service Running Instance ---->

	<cffunction name="getDirectoryServiceInfo" access="public" returntype="struct">
		<cfscript>
			var stInfo = structNew();
			var oService = createModelObject("server.service").init();
			
			stInfo.isRunning = oService.isRunning();
			stInfo.startedOn = "";
			
			if(stInfo.isRunning) {
				stInfo.startedOn = oService.getService().getStartedOn();
			}
			
			return stInfo;
		</cfscript>
	</cffunction>
	
	<cffunction name="startDirectoryService" access="public" returntype="void">
		<cfscript>
			var oService = createModelObject("server.service").init();
			oService.start( variables.dataProviderClass );
		</cfscript>
	</cffunction>

	<cffunction name="stopDirectoryService" access="public" returntype="void">
		<cfscript>
			var oService = createModelObject("server.service").init();
			oService.stop();
		</cfscript>
	</cffunction>


	<!--- Interface for stored data --->

	<cffunction name="getResources" access="public" returntype="array">
		<cfscript>
			var oDataProvider = 0;
			var aResources = arrayNew(1);

			// create the data provider
			oDataProvider = createObject("component", variables.dataProviderClass);
			oDataProvider.init();
			aResources = oDataProvider.getResources();

			return aResources;
		</cfscript>
	</cffunction>

	<cffunction name="getResource" access="public" returntype="any">
		<cfargument name="resourceName" type="string" required="true">
		<cfscript>
			var oDataProvider = 0;

			if(arguments.resourceName neq "") {
				oDataProvider = createObject("component", variables.dataProviderClass);
				oDataProvider.init();
				
				oResource = oDataProvider.getResource(arguments.resourceName);

			} else {
				oResource = createModelObject("server.resource");
			}
			
			return oResource;
		</cfscript>
	</cffunction>

	<cffunction name="saveResource" access="public" returntype="any">
		<cfargument name="resourceName" type="string" required="true">
		<cfargument name="newName" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="TTL" type="numeric" required="true">
		
		<cfscript>
			var oDataProvider = 0;
			var oResource = 0;

			// create the data provider
			oDataProvider = createObject("component", variables.dataProviderClass);
			oDataProvider.init();

			// now update or insert resource
			if(arguments.resourceName eq "") {
				oResource = createModelObject("server.resource");
				oResource = oResource.init(arguments.newName, arguments.TTL, arguments.description);
				oDataProvider.addResource(oResource);
			} else {
				oResource = oDataProvider.getResource(arguments.resourceName);
				oResource.setName(arguments.newName);
				oResource.setTTL(arguments.ttl);
				oResource.setDescription(arguments.description);
			}
		
			// write data
			oDataProvider.update();
		</cfscript>
	</cffunction>

	<cffunction name="deleteResource" access="public" returntype="any">
		<cfargument name="resourceName" type="string" required="true">
		<cfscript>
			var oDataProvider = 0;

			// create the data provider
			oDataProvider = createObject("component", variables.dataProviderClass);
			oDataProvider.init();

			// remove resource
			oDataProvider.deleteResource(arguments.resourceName);
		
			// write data
			oDataProvider.update();
		</cfscript>
	</cffunction>


	<cffunction name="getNewAddress" access="public" returntype="any">
		<cfreturn createModelObject("server.address")>
	</cffunction>
	
	<cffunction name="saveAddress" access="public" returntype="any">
		<cfargument name="resourceName" type="string" required="true">
		<cfargument name="index" type="numeric" required="true">
		<cfargument name="href" type="string" required="true">
		<cfargument name="referrer" type="string" required="true">

		<cfscript>
			var oDataProvider = 0;
			var oResource = 0;
			var oAddress = 0;
			var aAddresses = arrayNew(1);

			// create the data provider
			oDataProvider = createObject("component", variables.dataProviderClass);
			oDataProvider.init();

			// get resource
			oResource = oDataProvider.getResource(arguments.resourceName);

			// now update or insert address
			if(arguments.index eq 0) {
				oAddress = createModelObject("server.address");
				oAddress = oAddress.init(arguments.href, arguments.referrer);
				oResource.addAddress(oAddress);
			} else {
				aAddresses = oResource.getAddresses();
				oAddress = aAddresses[arguments.index];
				oAddress.setHREF(arguments.href);
				oAddress.setReferrer(arguments.referrer);
			}
		
			// write data
			oDataProvider.update();
		</cfscript>
	</cffunction>

	<cffunction name="deleteAddress" access="public" returntype="any">
		<cfargument name="resourceName" type="string" required="true">
		<cfargument name="index" type="numeric" required="true">
		<cfscript>
			var oDataProvider = 0;
			var oResource = 0;
			var aAddresses = 0;
			var oAddress = 0;

			// create the data provider
			oDataProvider = createObject("component", variables.dataProviderClass);
			oDataProvider.init();

			// get resource
			oResource = oDataProvider.getResource(arguments.resourceName);

			// get address
			aAddresses = oResource.getAddresses();
			oAddress = aAddresses[arguments.index];

			// remove address
			oResource.removeAddress(oAddress.getReferrer());
		
			// write data
			oDataProvider.update();
		</cfscript>
	</cffunction>


	<cffunction name="getLog" access="public" returnType="query">
		<cfargument name="logName" type="string" required="true">
		<cfargument name="startLine" type="numeric" required="false" default="1">
		<cfargument name="LinesToRead" type="numeric" required="false" default="1000">
		
		<cfset var logPath = "">
		<cfset var txtDoc = "">
		<cfset var oFileReader = 0>
		<cfset var aLine = ArrayNew(1)>
		<cfset var i = 0>
		<cfset var j = 0>
		<cfset var lstFields = "Severity,ThreadID,Date,Time,Application,Message">
		<cfset var lstCFLogFields = """Severity"",""ThreadID"",""Date"",""Time"",""Application"",""Message""">
		<cfset var qry = QueryNew(lstFields)>
		
		<!--- append the .log extension if needded --->
		<cfif right(arguments.logName,4) neq ".log">
			<cfset arguments.logname = arguments.logName & ".log">
		</cfif>
		
		<!--- build the full path for the log file --->
		<cfset logPath = expandPath(variables.wscandisLogsPath & arguments.logname)>

		<!--- read file if exists --->
		<cfif fileExists(logPath)>
			<cfscript>
				oFileReader = createObject('component', 'utilities.fileReader').init(logPath, "US-ASCII");
				
				i=0;
				while ( not oFileReader.isEOF() and i-arguments.startLine lt arguments.linesToRead) {
					tmp = oFileReader.readLine();
						
					if(i gte arguments.startLine) {
							tmp = replace(tmp,",,",",&nbsp;,","ALL");
							if(tmp neq "") {
								tmp = replace(tmp,"""","","ALL");
								aLine = listToArray(tmp);
								QueryAddRow(qry);
								for(j=1;j lte listlen(lstFields);j=j+1) {
									QuerySetCell(qry,listGetAt(lstFields,j),aLine[j]);
								}	
							}
					}
					i=i+1;
				}
				oFileReader.close();
			</cfscript>
		</cfif>
		<cfreturn qry>
	</cffunction>

	<cffunction name="deleteLog" access="public" returnType="void">
		<cfargument name="logName" type="string" required="true">
		<cfset var logPath = "">

		<!--- append the .log extension if needded --->
		<cfif right(arguments.logName,4) neq ".log">
			<cfset arguments.logname = arguments.logName & ".log">
		</cfif>

		<!--- build the full path for the log file --->
		<cfset logPath = expandPath(variables.wscandisLogsPath & arguments.logname)>

		<!--- delete file --->
		<cfif fileExists(logPath)>
			<cffile action="delete" file="#expandPath(variables.wscandisLogsPath & arguments.logname)#">
		</cfif>
	</cffunction>

	<!----- Private Methods ---->
	<cffunction name="createModelObject" access="private" returntype="any">
		<cfargument name="cfcPath" type="string" required="true">
		<cfreturn createObject("component", variables.wscandisCFCPath & arguments.cfcPath)>
	</cffunction>
	

</cfcomponent>