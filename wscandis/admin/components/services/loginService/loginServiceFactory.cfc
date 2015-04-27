<cfcomponent displayname="loginServiceFactory" hint="This component is used to create an instance of the component that will handle user authentication.">
	
	<cfset variables.configHREF = GetDirectoryFromPath(GetCurrentTemplatePath()) & "/default.xml">
	<cfset variables.defaultAuthLogin = "CFLogin">
	
	<cffunction name="init" access="public" returnType="loginService" hint="Initializes the service and returns an instance of the loginService for the requested login type">
		<cfargument name="xmlConfigHREF" type="string" required="true">
		<cfargument name="authType" type="string" default="Simple">
		
		<!--- if a config doc has been passed then override default configuration --->
		<cfif arguments.xmlConfigHREF neq "">
			<cfset variables.configHREF = ExpandPath(arguments.xmlConfigHREF)>
		</cfif>
		
		<!--- return the requested login service --->
		<cfreturn getLoginService(arguments.authType)>
		
	</cffunction>
	
	<cffunction name="getLoginService" access="private" returntype="loginService" hint="Returns an initialized loginService instance for the requested login type">
		<cfargument name="authType" type="string" default="Simple">
	
		<!--- declare variables and set defaults --->
		<cfset var xmlDoc = 0>
		<cfset var authLogin = variables.defaultAuthLogin>
		<cfset var aAuthModule = arrayNew(1)>
		<cfset var aNodes = arrayNew(1)>
		<cfset var i = 0>
		<cfset var stConfig = StructNew()>
		<cfset var oLoginService = 0>
		<cfset var aSysAdmins = arrayNew(1)>
		
		<!--- read the auth configuration --->
		<cfset xmlDoc = xmlParse(variables.configHREF)>
		
		<!--- get the login type for the application ---->
		<cfif structKeyExists(xmlDoc.xmlRoot, "authLogin")>
			<cfset authLogin = xmlDoc.xmlRoot.authLogin.xmlText>
		</cfif>
		
		<!--- get configuration for selected authentication method --->
		<cfset aAuthModule = xmlSearch(xmlDoc, "//auth-module[@name='#arguments.authType#']")>
		
		<cfif ArrayLen(aAuthModule) gt 0>
			
			<!--- create a structure with the config settings for this auth module --->
			<cfset stConfig = StructNew()>
			<cfset stConfig.authType = arguments.authType>
			<cfset stConfig.authLogin = authLogin>
			<cfloop from="1" to="#arrayLen(aAuthModule[1].xmlChildren)#" index="i">
				<cfset stConfig[aAuthModule[1].xmlChildren[i].xmlName] = aAuthModule[1].xmlChildren[i].xmlText>
			</cfloop>

			<!--- create the instance of the loginService object for this auth method --->
			<cfset oLoginService = createObject("component", aAuthModule[1].xmlAttributes.loginService)>
			
			<!--- initialize loginService instance --->
			<cfset oLoginService.init(argumentCollection = stConfig)>

			<!--- read usernames for the sysadmin role --->
			<cfscript>
				aNodes = xmlSearch(xmlDoc, "//sysadmins/username");
				
				for(i=1;i lte arrayLen(aNodes);i=i+1) {
					arrayAppend(aSysAdmins, aNodes[i].xmlText);	
				}
			</cfscript>
			
			<!--- notify the loginService of users defined as system administrators --->
			<cfset oLoginService.setSysAdmins(aSysAdmins)>
		<cfelse>
			<cfthrow message="The requested authentication module was not found.">
		</cfif>


		<cfreturn oLoginService>
	</cffunction>

	<cffunction name="getSysAdmins" access="private" returntype="array" hint="Returns an array with the registered usernames that have the sysadmin role">
		<cfreturn variables.aSysAdmins>
	</cffunction>
</cfcomponent>