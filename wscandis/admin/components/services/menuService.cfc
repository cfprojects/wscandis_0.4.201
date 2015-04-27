<cfcomponent hint="This component is used to build the navigation menu.">

	<cfset variables.opmlPath = "">
	<cfset variables.xmlDoc = "">
	
	<cffunction name="init" access="public" returnType="menuService">
		<cfargument name="opmlPath" type="string" required="true">
		<cfset variables.opmlPath = arguments.opmlPath>
		<cfset variables.xmlDoc = xmlParse(expandPath(variables.opmlPath))>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMenu" access="public" returntype="query">
		<cfargument name="group" type="string" required="false" default="" hint="Name of the menu group to return, leave empty to retun all menu groups">
		<cfargument name="filter" type="string" required="false" default="" hint="Comma delimited list of IDs to return. If not empty, then only menu items with the given IDs are returned.">
		
		<cfscript>
			// create return query
			var qry = QueryNew("group,label,href,id");
			
			// get configuration for selected authentication method
			var aGroups = variables.xmlDoc.xmlRoot.body.xmlChildren;
			
			for(i=1;i lte arrayLen(aGroups);i=i+1) {
				aOptions = aGroups[i].xmlChildren;
				
				if(arguments.group eq "" or arguments.group eq aGroups[i].xmlAttributes.text) {

					for(j=1;j lte arrayLen(aOptions);j=j+1) {
					
						if(arguments.filter eq "" or listFind(arguments.filter, aOptions[j].xmlAttributes.id)) {
						
							if(Not structKeyExists(aOptions[j].xmlAttributes, "url")) aOptions[j].xmlAttributes.url = "";
							if(Not structKeyExists(aOptions[j].xmlAttributes, "text")) aOptions[j].xmlAttributes.text = "";
							if(Not structKeyExists(aOptions[j].xmlAttributes, "id")) aOptions[j].xmlAttributes.id = "";
						
							QueryAddRow(qry);
 							QuerySetCell(qry, "group",aGroups[i].xmlAttributes.text);
							QuerySetCell(qry, "label",aOptions[j].xmlAttributes.text);
							QuerySetCell(qry, "href",aOptions[j].xmlAttributes.url);
							QuerySetCell(qry, "id",aOptions[j].xmlAttributes.id);
						
						}
					}
				}
			}
			
			return qry;
		</cfscript>
	</cffunction>

</cfcomponent>