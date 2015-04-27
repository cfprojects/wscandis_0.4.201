<cfcomponent name="directoryServiceClient">
	
	<cfset variables.directoryServiceWSDL = "">
	<cfset variables.wsDirectoryService = 0>
	<cfset variables._inited = false>
	<cfset variables.hostName = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName()>

	<cffunction name="init" access="public" returntype="directoryServiceClient">
		<cfargument name="wsdl" type="string" required="true">
		
		<cfscript>
			// Set the Directory Service WSDL
			variables.directoryServiceWSDL = arguments.wsdl;
			
			// create instance of directory service webservice 
			// (useful if client wants to keep single instance of this component)
			variables.wsDirectoryService = createObject("webservice", variables.directoryServiceWSDL);

			// flag component as initialized
			variables._inited = true;
			
			return this;
		</cfscript>
		
	</cffunction>

	<cffunction name="lookup" access="public" returntype="any">
		<cfargument name="name" type="string" required="true">
		<cfargument name="referrer" type="string" required="false" default="">

		<cfscript>
			// check that component is initialized
			if(not variables._inited) init();
			
			// only check non-empty strings
			if(name eq "") throw("The name to resolve cannot be empty");
			
			// if hostname is not being explicitly passed, then get the hostname
			// from the machine itself 
			if(arguments.referrer eq "") {
				arguments.referrer = variables.hostName;				
			}

			// resolve requested name
			oResponse = variables.wsDirectoryService.lookup(arguments.name, arguments.referrer);
			
			return oResponse;
		</cfscript>
	</cffunction>

	<cffunction name="throw" access="private">
		<cfargument name="message" type="string" required="true">
		<cfthrow message="#arguments.message#">
	</cffunction>
	
</cfcomponent>