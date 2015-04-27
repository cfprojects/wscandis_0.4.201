<cfcomponent displayname="storageService"
				hint="This component provides an interface for storing data on a shared scope.
					This component takes care of serializing and de-serializing the data in order to be stored.
					Use this component to avoid explicit dependency on a shared scope such as client or session">
	
	<cfscript>
		variables.dataStoreName = "myDataStorage";
		variables.storageScope = "client";
		variables.useWDDX = true;
	</cfscript>
	

	<!--- ************************************************************  --->	
	<!--- init														    --->	
	<!--- ************************************************************* --->			
	<cffunction name="init" access="public" hint="Constructor" returntype="storageService">
		<cfargument name="storageScope" type="string" required="false" default="#variables.storageScope#" hint="The CFMX shared scope that will be used to store the data">
		<cfargument name="dataStoreName" type="string" required="false" default="#variables.dataStoreName#" hint="The name that will be used for the structure that will hold the stored data">
		<cfset variables.storageScope = arguments.storageScope>
		<cfset variables.dataStoreName = arguments.dataStoreName>
		<cfset setVariable("#variables.storageScope#.#variables.dataStoreName#","")>
		<cfreturn this>
	</cffunction>


	<!--- ************************************************************  --->	
	<!--- retrieve													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="retrieve" access="public" returnType="Any"
				hint="Retrieves an object from the persistent storage">
		<cfargument name="key" required="true" type="string" hint="Key to identify the object to be retrieved.">
		<cfargument name="default" type="any" required="false">

		<cfset var rtn = 0>	
		<cfset var stStorage = getStorage()>

		<!--- check if requested key exists --->
		<cfif StructKeyExists(stStorage, arguments.key)>
			<!--- get data from storage scope --->
			<cfset rtn = stStorage[arguments.key]>
	
		<cfelseif structKeyExists(arguments, "default")>
			<!--- return default (if given) --->
			<cfset rtn = arguments.default>
		</cfif>

		<cfreturn rtn>
	</cffunction>	
	

	
	<!--- ************************************************************  --->	
	<!--- store													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="store" access="public" 
				hint="Stores serialized data into the persistent scope">
		<cfargument name="key" required="true" type="string" hint="Key to identify the object to be stored.">
		<cfargument name="data" type="any" required="true">
				
		<cfset var serData = 0>
		<cfset var stStorage = getStorage()>
		
		<cfset stStorage[arguments.key] = arguments.data>
		<cfset saveStorage(stStorage)>
	</cffunction>	


	
	<!--- ************************************************************  --->	
	<!--- flush													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="flush" access="public" hint="Removes the requested data from the storage">
		<cfargument name="key" type="string" required="true">
		<cfset var stStorage = getStorage()>
		<cfset StructDelete(stStorage, arguments.key)>
		<cfset saveStorage(stStorage)>
	</cffunction>	
	

	<!--- ************************************************************  --->	
	<!--- dump														    --->	
	<!--- ************************************************************* --->			
	<cffunction name="dump" access="public" hint="Dumps the stored data">
		<cfdump var="#getStorage()#" label="#variables.dataStoreName# [#variables.storageScope#]">
	</cffunction>	
					
	<!--- ************************************************************  --->	
	<!--- getStorageScopeName										    --->	
	<!--- ************************************************************* --->			
	<cffunction name="getStorageScopeName" access="public" hint="Returns the name of the scope used for data storage">
		<cfreturn variables.storageScope>
	</cffunction>	
					
	<!--- ************************************************************  --->	
	<!--- contains													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="contains" access="public" returnType="boolean"
				hint="Checks whether the given key exists on the storage">
		<cfargument name="key" required="true" type="string" hint="Key to identify the object to be retrieved.">
		<cfreturn StructKeyExists(getStorage(), arguments.key)>
	</cffunction>						
					
					
	
	<!------   P R I V A T E     F U N C T I O N S     -------->
	
	
	<!--- ************************************************************  --->	
	<!--- getScope													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="getScope" returntype="Any" access="private">
		<cfreturn evaluate(variables.storageScope)>
	</cffunction>


	<!--- ************************************************************  --->	
	<!--- getStorage													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="getStorage" returntype="struct" access="private">
		<cfset var strStore = "#variables.storageScope#.#variables.dataStoreName#">
		<cfset var stRet = structNew()>
		<cfset var unwddx = "">
		
		<cfif isDefined(strStore)>
			<cfset tmp = evaluate(strStore)>
			<cfif tmp neq "">
				<cfset stRet = deserialize(tmp)>
				<cfif variables.useWDDX>
					<cfwddx action="wddx2cfml" input="#stRet#" output="unwddx">
					<cfset stRet = unwddx>
				</cfif>
			</cfif>
		<cfelse>
			<cfset setVariable(strStore,"")>
		</cfif>
		
		<cfreturn stRet>
	</cffunction>
	
	
	<!--- ************************************************************  --->	
	<!--- saveStorage													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="saveStorage" returntype="void" access="private">
		<cfargument name="storageStruct" type="struct" required="true">

		<cfset var serData = 0>
		<cfset var strStore = "#variables.storageScope#.#variables.dataStoreName#">
		<cfset var srcData = "">
		
		<cfif variables.useWDDX>
			<cfwddx action="cfml2wddx" input="#arguments.storageStruct#" output="srcData">
		<cfelse>
			<cfset srcData = arguments.storageStruct>
		</cfif>
		
		<cfset serData = serialize(srcData)>
		<cfset setVariable(strStore, serData)>
	</cffunction>	
	
	
	<!--- ************************************************************  --->	
	<!--- serialize													    --->	
	<!--- ************************************************************* --->			
	<cffunction name="serialize" returntype="Any" access="private">
		<cfargument name="myObject" type="Any" required="true">
		<cfscript>
			var byteOut = CreateObject("Java", "java.io.ByteArrayOutputStream");
			var objOut = CreateObject("Java", "java.io.ObjectOutputStream");
			
			// Create the underlying ByteArrayOutputStream
			byteOut.init();
			
			// Create the ObjectOutputStream to which the object will be written
			objOut.init(byteOut);
			
			// Write the object to and close the stream
			objOut.writeObject(arguments.myObject);
			objOut.close();
			
			return toBase64(byteOut.toByteArray());
		</cfscript>
	</cffunction>


	<!--- ************************************************************  --->	
	<!--- deserialize												    --->	
	<!--- ************************************************************* --->			
	<cffunction name="deserialize" returntype="Any" access="private">
		<cfargument name="mySerializedObject" type="Any" required="true">
		<cfscript>
			var objIn = CreateObject("Java", "java.io.ObjectInputStream");
			var byteIn = CreateObject("Java", "java.io.ByteArrayInputStream");

			byteIn.init(binaryDecode(arguments.mySerializedObject,'base64'));

			// Create the ObjectInputStream to which the object will be read in from
			objIn.init(byteIn);
			
			return objIn.readObject();
		</cfscript>
	</cffunction>
	
</cfcomponent>