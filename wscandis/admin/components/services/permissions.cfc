<cfcomponent displayname="permissions" hint="This component is provides an interface to map application actions to user roles. Use this component to check if users are allowed to perform certain actions.">

	<cfset variables.configHREF = "">
	<cfset variables.permissionsMap = structNew()>
	
	<cffunction name="init" access="public" returnType="permissions">
		<cfargument name="xmlConfigHREF" type="string" required="true">
		<cfscript>
			var xmlDoc = 0;
			
			variables.configHREF = arguments.xmlConfigHREF;
			xmlDoc = xmlParse(expandPath(arguments.xmlConfigHREF));

			aTasks = xmlDoc.xmlRoot.xmlChildren;
			
			for(i=1;i lte arrayLen(aTasks);i=i+1) {
				variables.permissionsMap[aTasks[i].xmlAttributes.name] = aTasks[i].xmlAttributes.roles;
			}
			
		</cfscript>
		
		<cfreturn this>
	</cffunction>
		

	<!------------------------------>
	<!--- getPermissions       ----->
	<!------------------------------>
	<cffunction name="getPermissions" access="public" returntype="string" hint="Returns a list of all permissions for the given user">
		<cfargument name="userInfo" type="userInfo" required="yes" hint="Information about current user">
		
		<cfscript>
			var lstUserTasks = "";
			var lstTaskRoles = "";
			var aUserRoles = listToArray(arguments.userInfo.getRoles());
			
			// loop through all available tasks
			for(task in variables.permissionsMap) {
				// get list of roles that can access this task
				lstTaskRoles = variables.permissionsMap[task];				

				// now check if user belongs to one of the allowed roles
				for(i=1;i lte arrayLen(aUserRoles);i=i+1) {
					if(listFindNoCase(lstTaskRoles, aUserRoles[i])) {
						lstUserTasks = ListAppend(lstUserTasks, task);
					}
				}
			}
			
			return lstUserTasks;
		</cfscript>
	</cffunction>


	<!------------------------------>
	<!--- isAllowed            ----->
	<!------------------------------>
	<cffunction name="isAllowed" access="public" hint="Returns whether the given user is allowed to perform a given task" returntype="boolean">
		<cfargument name="userInfo" type="userInfo" required="yes" hint="Information about current user">
		<cfargument name="task" type="string" required="yes">
		
		<cfscript>
			var aUserRoles  = ArrayNew(1);
			var lstTaskRoles  = "";
			var i  = 0;
			
			// get list of roles to which the user belongs
			aUserRoles = listToArray(arguments.userInfo.getRoles());
			
			// get list of roles that can access the requested task
			lstTaskRoles = variables.permissionsMap[arguments.task];
			
			// if there are no roles defined then this is open to the anyone
			if(lstTaskRoles eq "") return true;
			
			// now check if user belongs to one of the allowed roles
			for(i=1;i lte arrayLen(aUserRoles);i=i+1) {
				if(listFindNoCase(lstTaskRoles, aUserRoles[i])) {
					return true;
				}
			}
			
			// role not found
			return false;
		</cfscript>
	</cffunction>	


</cfcomponent>