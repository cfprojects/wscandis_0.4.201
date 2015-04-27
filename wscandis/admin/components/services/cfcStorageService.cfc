<cfcomponent displayname="cfcStorageService" extends="storageService"
				hint="This component provides an interface for storing cfc instance data on a shared scope.
					components that use this service must implement the methods getInstanceData() and setInstanceData()">
	

	<!--- ************************************************************  --->	
	<!--- retrieve													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="retrieve" access="public" returnType="Any"
				hint="Retrieves an object from the persistent storage">
		<cfargument name="key" required="true" type="string" hint="Key to identify the cfc to be retrieved.">
		<cfargument name="obj" type="Any" required="true" hint="An instance of a cfc that will be populated with the retrieved data">

		<cfset var stRet = structNew()>	

		<cfset stRet = super.retrieve(arguments.key, obj.getInstanceData())>
		<cfset arguments.obj.setInstanceData(stRet)>

		<cfreturn arguments.obj>
	</cffunction>	
	

	
	<!--- ************************************************************  --->	
	<!--- store													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="store" access="public" 
				hint="Stores serialized data into the persistent scope">
		<cfargument name="key" required="true" type="string" hint="Key to identify the object to be stored.">
		<cfargument name="obj" type="Any" required="true" hint="An instance of a cfc whose instance data will be stored">
				
		<cfset super.store(arguments.key, arguments.obj.getInstanceData())>
	</cffunction>	

</cfcomponent>