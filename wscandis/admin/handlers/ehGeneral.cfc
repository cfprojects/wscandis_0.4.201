<cfcomponent name="ehGeneral" extends="eventHandler">

	<cffunction name="onApplicationStart" access="public" returntype="void">
	</cffunction>

	<cffunction name="onRequestStart" access="public" returntype="boolean">
		<cfscript>
			var lstPublicEvents = getSetting("publicEventsList","");
			var appTitle = getSetting("applicationTitle", application.applicationName);
			var event = getEvent();
			var hostName = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName();
			var oUserInfo = 0;
			var qryMenu = 0;
			var versionTag = getSetting("versionTag");
			var bContinueProcessing = true;
			
			try {
				// retrieve persistent CFCs from storage
				oUserInfo = getService("cfcStorage").retrieve("userInfo", createInstance("components/services/userInfo.cfc").init() );

				// make sure that we always access everything via events
				if(event eq "") {
					throw("All requests must specify the event to execute. Direct access to views is not allowed");
				}

				// Check that the user is performing an allowed action
				try {
					if(Not getService("permissions").isAllowed(oUserInfo, event)) {
						if(oUserInfo.getUsername() eq "") {
							setMessage("info","Please login to the application");
							setNextEvent("ehGeneral.dspLogin");
						} else {
							setMessage("warning","You do not have the required permissions to perform the requested action [#event#]");
							setNextEvent("ehGeneral.dspMain");
						}
					}
				} catch(any e) {
					setMessage("error",e.message);
					bContinueProcessing = false;		
				}
				
				// get the query with all menu options for the current user
				qryMenu = getService("storage").retrieve("qryMenu", QueryNew(""));

				// get status of wscandis server
				stInfo = getService("app").getDirectoryServiceInfo();
				
				// set generally available values on the request context
				setValue("stInfo", stInfo);
				setValue("hostName", hostName);
				setValue("oUserInfo", oUserInfo);
				setValue("applicationTitle", appTitle);
				setValue("qryMenu", qryMenu);
				setValue("versionTag", versionTag);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				bContinueProcessing = false;
			}
			
			return bContinueProcessing;
		</cfscript>

	</cffunction>

	<cffunction name="onRequestEnd">
		<!--- code to execute at the end of each request --->
	</cffunction>

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			try {
				
				// get status of wscandis server
				stInfo = getValue("stInfo", false);
				
				if(stInfo.isRunning) {
					aResources = getService("app").getResources();
					setValue("aResources", aResources);
				}
				
				// set values
				setValue("selectedOption", "Home");
				setView("vwHome");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspLogin" access="public">
	 	<cfset var authlogin = getService("loginService").config.authlogin>
		<cfset var authType = getService("loginService").config.authType>
		
		<cfif authlogin eq "Challenge">
			<cfset setValue("authType", authType)>
			<cfset setView("vwLoginChallenge")>
		<cfelse>
			<cfset setView("vwLogin")>
		</cfif>	

		<cfset setValue("contactEmail", getSetting("contactEmail"))>
		<cfset setLayout("Layout.Clean")>
	</cffunction>

	<cffunction name="dspSettings" access="public" returntype="void">
		<cfscript>
			var OSPathSeparator = createObject("java","java.lang.System").getProperty("file.separator");
			
			try {
				// set values
				setValue("wscandisPath", getSetting("wscandisPath"));
				setValue("dataProviderConfigHREF", getSetting("wscandisPath") & OSPathSeparator & "server" & OSPathSeparator & "dataProvider-config.xml");
				setValue("logsPath", getSetting("wscandisPath") & OSPathSeparator & "server" & OSPathSeparator & "logs");
				setValue("dataProviderClass", getSetting("dataProviderClass"));
				setValue("selectedOption", "Settings");
				setView("vwSettings");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspStats" access="public" returntype="void">
		<cfscript>
			try {
				// set values
				setValue("selectedOption", "Stats");
				setView("vwStats");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspLogViewer" access="public" returntype="void">
		<cfscript>
			try {
				logName = getValue("logName", "responses");
				
				qryLog = getService("app").getLog(logName, 1);
				
				// set values
				setValue("qryLog", qryLog);
				setValue("selectedOption", "Log Viewer");
				setView("vwLogViewer");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="doLogin" access="public">
		<cfset var username = "">
		<cfset var oLoginMessage = 0>
		<cfset var oUserInfo = 0>
		
		<cflogin>
			<cfscript>
				// this is to make sure we get here only after user entered his login info
				if(Not IsDefined("cflogin")) setNextEvent("ehGeneral.dspLogin");
				
				try {
					// validate data
					if(cflogin.name eq "") throw("Please enter your username","userNotification");
					if(cflogin.password eq "") throw("Please enter your password","userNotification");
					
					// authenticate user
					oLoginMessage = getService("loginService").authenticateUser(cflogin.name, cflogin.password);
					
					if(Not oLoginMessage.authenticated) {
						if(oLoginMessage.errorMessage neq "")
							throw(oLoginMessage.errorMessage);
						else
							throw("Invalid username and/or password.","userNotification");
					}
					
					// set the username format (in case we are using an NT authentication)
					if (getService("loginService").config.authtype eq "NT")
					 	username = getService("loginService").config.domain & "\" & cflogin.name;
					else 
						username = cflogin.name;
	
					// create and populate userInfo object to store user context
					oUserInfo = createInstance("components/services/userInfo.cfc");
					oUserInfo.setUsername(username);
					oUserInfo.setRoles(oLoginMessage.roles);
					oUserInfo.setAttribute("data",oLoginMessage.userData);
	
					// build application menu for current user and store it for later use
					lstUserPermissions = getService("permissions").getPermissions(oUserInfo);
					qryMenu = getService("menu").getMenu("", lstUserPermissions );
					getService("storage").store("qryMenu", qryMenu);

					// store userInfo in persistent storage			
					getService("cfcStorage").store("userInfo", oUserInfo);
					setValue("oUserInfo",oUserInfo);
	
					// go to the application main view
					setNextEvent("ehGeneral.dspMain");
					
				} catch(any e) {
					setMessage("error",e.message);
					if(e.type neq "userNotification") getService("bugTracker").notifyService(e.message, e);
					setNextEvent("ehGeneral.dspLogin");
				}
			</cfscript>
		</cflogin>
	</cffunction>

	<cffunction name="doLogout" access="public">
		<cfscript>
			// clear stored user  data			
			getService("cfcStorage").flush("userInfo");
			getService("storage").flush("qryMenu");
			
			// redirect to login
			setNextEvent("ehGeneral.dspLogin");
		</cfscript>
	</cffunction>

	<cffunction name="doStart" access="public">
		<cfscript>
			try {
				// start service
				getService("app").startDirectoryService();
				setMessage("info","WSCandis has been started!");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}

			setNextEvent("ehGeneral.dspMain");
		</cfscript>	
	</cffunction>
	
	<cffunction name="doStop">
		<cfset getService("app").stopDirectoryService()>
		<cfset setMessage("info","WSCandis has been stopped!")>
		<cfset setNextEvent("ehGeneral.dspMain")>
	</cffunction>

	<cffunction name="doChangePassword" access="public">
		<cfscript>
			var authConfigHREF = getSetting("authConfigHREF");
			var authType = getSetting("authType");
			var old_pwd = getValue("old_pwd");
			var new_pwd = getValue("new_pwd");
			var new_pwd2 = getValue("new_pwd2");
			
			// !!! FOR NOW WE WILL HANDLE THE CHANGE OF PASSWORD HERE
			// SINCE THE LOGIN SERVICE DOES NOT SUPPORT THAT YET
			// BUT THIS NEEDS TO BE CHANGED SOON!!!				
			var x = "5DD77054BFC9046A420187228117A328";
			var y = "26A78071B91DF6855B7A5E5194C88E47";
			var new_pwd_hash = hash(x & new_pwd & y,'SHA-1');
			var old_pwd_hash = hash(x & old_pwd & y,'SHA-1');

			var xmlDoc = 0;
			var aNode = 0;
					
			try {
				// validate form fields
				if(old_pwd eq "") throw("Please enter your current password"); 
				if(new_pwd eq "") throw("The new password cannot be blank"); 
				if(len(new_pwd) lt 6) throw("The new password must be at least 6 characters long");
				if(new_pwd neq new_pwd2) throw("The password confirmation did not match");
					
				// get the node where the current password is stored (this will only work for simple authentication)	
				xmlDoc = xmlParse(expandPath(authConfigHREF));
				aNode = xmlSearch(xmlDoc, "//auth-module[@name='#authType#']");
				if(arrayLen(aNode) eq 0) throw("Authentication type not found on auth config");

				// check if the current password is valid
				if(old_pwd_hash neq aNode[1].spwd.xmlText) throw("Invalid password");
				
				// update with the new password
				aNode[1].spwd.xmlText = xmlFormat(new_pwd_hash);

				// write changes to config xml
				writeFile(expandPath(authConfigHREF), toString(xmlDoc));

				setMessage("info","Password has been changed. Reset application for changes to be effective.");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}

			setNextEvent("ehGeneral.dspSettings");
		</cfscript>	
	</cffunction>

	<cffunction name="doDeleteLog" access="public" returntype="void">
		<cfscript>
			try {
				logName = getValue("logName", "responses");
				
				getService("app").deleteLog(logName);
				
				// set values
				setMessage("information","The log has been deleted");
				setNextEvent("ehGeneral.dspLogViewer");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#">
	</cffunction>

</cfcomponent>