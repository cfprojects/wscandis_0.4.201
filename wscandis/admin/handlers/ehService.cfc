<cfcomponent name="ehService" extends="eventHandler">

	<cffunction name="dspEdit">
		<cfscript>
			try {
				// get status of wscandis server
				stInfo = getValue("stInfo");
				
				if(Not stInfo.isRunning) 
					throw("WSCandis Server has not been started");

				// get the resource
				serviceName = getValue("service","");
				oResource = getService("app").getResource(serviceName);
				
				// set values
				setValue("service", serviceName);
				if(serviceName eq "") 
					setValue("selectedOption", "Add Service");
				else
					setValue("selectedOption", "Home");
				setValue("oResource", oResource);
				setView("vwService");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>		
	</cffunction>

	<cffunction name="dspEditAddress">
		<cfscript>
			try {
				// get values
				stInfo = getValue("stInfo");
				serviceName = getValue("service");
				index = getValue("index",0);
				
				if(Not stInfo.isRunning) throw("WSCandis Server has not been started");
				if(serviceName eq "") throw("Please select a service");
				
				oResource = getService("app").getResource(serviceName);
				
				if(index gt 0) {
					aAddresses = oResource.getAddresses();
					oAddress = aAddresses[index];				
				} else {
					oAddress = getService("app").getNewAddress();					
				}
				
				// set values
				setValue("service", serviceName);
				setValue("selectedOption", "Home");
				setValue("oResource", oResource);
				setValue("oAddress", oAddress);
				setView("vwAddress");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehService.dspEdit");
			}
		</cfscript>				
	</cffunction>

	<cffunction name="doSave">
		<cfscript>
			try {
				// get values
				stInfo = getValue("stInfo");
				service = getValue("service");
				name = getValue("name");
				description = getValue("description");
				ttl = getValue("ttl",0);
				
				if(Not stInfo.isRunning) throw("WSCandis Server has not been started");
				if(name eq "") throw("Service name cannot be empty");
				if(Not IsNumeric(ttl)) throw("TimeToLive must be a numeric value");
				
				getService("app").saveResource(service, name, description, ttl);
				
				setMessage("info","Service has been updated. Please restart wscandis to apply changes");
				setNextEvent("ehService.dspEdit","service=#name#");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehService.dspEdit");
			}
		</cfscript>		
	</cffunction>

	<cffunction name="doDelete">
		<cfscript>
			try {
				// get values
				stInfo = getValue("stInfo");
				service = getValue("service");
				
				if(Not stInfo.isRunning) throw("WSCandis Server has not been started");
				if(service eq "") throw("Please select a service");
				
				getService("app").deleteResource(service);
				
				setMessage("info","Service has been deleted. Please restart wscandis to apply changes");
				setNextEvent("ehGeneral.dspMain");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehService.dspEdit");
			}
		</cfscript>			
	</cffunction>

	<cffunction name="doSaveAddress">
		<cfscript>
			try {
				// get values
				stInfo = getValue("stInfo");
				service = getValue("service");
				referrer = getValue("referrer");
				href = getValue("href");
				index = getValue("index",0);
				
				if(Not stInfo.isRunning) throw("WSCandis Server has not been started");
				if(referrer eq "") throw("Referrer name cannot be empty");
				if(href eq "") throw("WSDL address cannot be empty");
				
				getService("app").saveAddress(service, index, href, referrer);
				
				setMessage("info","Address has been updated. Please restart wscandis to apply changes");
				setNextEvent("ehService.dspEdit","service=#service#");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehService.dspEditAddress");
			}
		</cfscript>				
	</cffunction>

	<cffunction name="doDeleteAddress">
		<cfscript>
			try {
				// get values
				stInfo = getValue("stInfo");
				service = getValue("service");
				index = getValue("index");
				
				if(Not stInfo.isRunning) throw("WSCandis Server has not been started");
				if(service eq "") throw("Please select a service");
				if(Not IsNumeric(index) or index eq 0) throw("Please select an address to delete");
				
				getService("app").deleteAddress(service, index);
				
				setMessage("info","Address has been deleted. Please restart wscandis to apply changes");
				setNextEvent("ehService.dspEdit","service=#service#");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehService.dspEditAddress");
			}
		</cfscript>			

	</cffunction>

</cfcomponent>