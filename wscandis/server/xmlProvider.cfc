<cfcomponent name="xmlProvider" extends="dataProvider">

	<cfscript>
		variables.settings.xmlDocHREF = "";
	</cfscript>

	<cffunction name="refresh" access="public" returntype="void">
		<cfscript>
			var xmlDoc = 0;
			var aResources = ArrayNew(1);
			var i = 0;
			var j = 0;
			var xmlNode = 0;
			var xmlChildNode = 0;
			
			// read xml file
			xmlDoc = xmlParse(expandPath(variables.settings.xmlDocHREF));
			
			// set default TTL
			variables.defaultTTL = val(xmlDoc.xmlRoot.defaultTTL.xmlText);

			// get resource nodes
			aResources = xmlDoc.xmlRoot.resources.xmlChildren;
			
			for(i=1;i lte arrayLen(aResources);i=i+1) {
				xmlNode = aResources[i];

				// create and initialize a resource
				oResource = createObject("component","resource");
				oResource.init(xmlNode.xmlAttributes.name, variables.defaultTTL, "");


				// process nodes
				for(j=1;j lte arrayLen(xmlNode.xmlChildren);j=j+1) {
					xmlChildNode = xmlNode.xmlChildren[j];
					
					switch(xmlChildNode.xmlName) {
					
						case "TTL": 
							oResource.setTTL(xmlChildNode.xmlText);
							break;
						
						case "description":
							oResource.setDescription(xmlChildNode.xmlText);
							break;
							
						case "address":
							oAddress = createObject("component","address");
							oAddress.init(xmlChildNode.xmlAttributes.href, xmlChildNode.xmlAttributes.referrer);
							oResource.addAddress(oAddress);
							break;
						
					}
	
				}
				
				// append resource to resources struct
				addResource(oResource);
			}	
		</cfscript>
	</cffunction>

	<cffunction name="update" access="public" returntype="void" hint="Updates the persistent storage with current data">
		<cfset var xmlDoc = toXML()>
		<cffile action="write" file="#expandPath(variables.settings.xmlDocHREF)#" output="#tostring(xmlDoc)#">
	</cffunction>
	
	<cffunction name="toXML" access="private" returntype="xml">
		<cfscript>
			var xmlDoc = xmlNew();
			var xmlNode = 0;
			var aResources = getResources();
			
			xmlDoc.xmlRoot = xmlElemNew(xmlDoc, "directory");

			// add defaultTTL node
			xmlNode = xmlElemNew(xmlDoc, "defaultTTL");
			xmlNode.xmlText = val(getDefaultTTL());
			arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);
			
			// add resources node
			xmlNode = xmlElemNew(xmlDoc, "resources");
			arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);

			// add all resources
			for(i=1; i lte arrayLen(aResources);i=i+1) {
				tmpName = aResources[i].getName();
				tmpDesc = aResources[i].getDescription();
				tmpTTL = aResources[i].getTTL();
				aAddresses = aResources[i].getAddresses();
				
				// create resource node
				xmlNode = xmlElemNew(xmlDoc, "resource");
				xmlNode.xmlAttributes["name"] = tmpName;
				
				// append description (if any)
				if(tmpDesc neq "") {
					xmlNode2 = xmlElemNew(xmlDoc, "description");
					xmlNode2.xmlText = xmlFormat(tmpDesc);
					arrayAppend(xmlNode.xmlChildren, xmlNode2);
				}

				// append TTL (if any)
				if(val(tmpTTL) gt 0) {
					xmlNode2 = xmlElemNew(xmlDoc, "TTL");
					xmlNode2.xmlText = val(tmpTTL);
					arrayAppend(xmlNode.xmlChildren, xmlNode2);
				}
				
				// append addresses
				for(j=1;j lte arrayLen(aAddresses);j=j+1) {
					xmlNode2 = xmlElemNew(xmlDoc, "address");
					xmlNode2.xmlAttributes["href"] = xmlFormat( aAddresses[j].getHREF() );
					xmlNode2.xmlAttributes["referrer"] = xmlFormat( aAddresses[j].getReferrer() );
					arrayAppend(xmlNode.xmlChildren, xmlNode2);
				}
				
				// add resource node to main tree
				arrayAppend(xmlDoc.xmlRoot.resources.xmlChildren, xmlNode);
			}
			
			return xmlDoc;
		</cfscript>
	</cffunction>
	
</cfcomponent>