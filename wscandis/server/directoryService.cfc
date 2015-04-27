<cfcomponent displayname="directoryService">

	<cfset variables.oDataProvider = 0>
	<cfset variables.startedOn = 0>

	<cffunction name="init" access="public" returntype="directoryService">
		<cfargument name="dataProvider" type="dataProvider" required="true">

		<!--- set the reference to the data provider --->
		<cfset variables.oDataProvider = arguments.dataProvider>

		<!--- refresh data provider, this will actually read into memory all the resources --->
		<cfset variables.oDataProvider.refresh()>
	
		<!--- record the date at which the service started --->
		<cfset variables.startedOn = Now()>
	
		<cfreturn this>
	</cffunction>

	<cffunction name="lookup" access="public" returntype="lookupResponseTO">
		<cfargument name="name" type="string" required="true">
		<cfargument name="referrer" type="string" required="true">
		
		<cfscript>
			var oLookupResponseTO = 0;
			var oResource = 0;
			var oAddressSolver = 0;
			var oAddress = 0;
		
			// get the resource information
			oResource = variables.oDataProvider.getResource(arguments.name);

			// create an addressSolver object to resolve the correct address for the given referrer
			oAddressSolver = createObject("Component","addressSolver");
			oAddress = oAddressSolver.solve(arguments.referrer, oResource);

			// create and populate the response object
			oLookupResponseTO = createObject("Component","lookupResponseTO");
			oLookupResponseTO.name = arguments.name;
			oLookupResponseTO.address = oAddress.getHREF();
			oLookupResponseTO.TTL = oResource.getTTL();
			oLookupResponseTO.description = oResource.getDescription();
			oLookupResponseTO.referrer = arguments.referrer;
			oLookupResponseTO.error = false;
			oLookupResponseTO.errorMessage = "";
		
			return oLookupResponseTO;
		</cfscript>
	</cffunction>

	<cffunction name="getStartedOn" access="public" returntype="date">
		<cfreturn variables.startedOn>
	</cffunction>

	<cffunction name="getDataProvider" access="public" returntype="dataProvider">
		<cfreturn variables.oDataProvider>
	</cffunction>
</cfcomponent>