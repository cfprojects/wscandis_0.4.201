<!---
Name:  logger.cfc

This component allows to maintain a log file of events. Supports automatic rotation
and archiving of the log files. All filesystem access is done via Java methods
to improve performance. Requires fileWriter.cfc and zip.cfc to be present on the 
same directory.

* This component is based on the coldbox logger plugin by Luis Majano

History:
6/29/07 - oarevalo - created

--->

<cfcomponent name="logger" hint="maintains a log file">
	
	<cfscript>
		variables.validSeverities = "information|fatal|warning|error|debug";
		variables.LogFileEncoding = "ISO-8859-1";
		variables.LogFileBufferSize = 32768;
		variables.LogFileMaxSize = 5000;
		variables.LogFileName = "messages";
		variables.LogFullPath = "";
	</cfscript>
	
	<cffunction name="init" access="public" returntype="logger">
		<cfargument name="logPath" type="string" required="true">
		<cfargument name="logName" type="string" required="false" default="#variables.LogFileName#">
		<cfargument name="encoding" type="string" required="false" default="#variables.LogFileEncoding#">
		<cfargument name="bufferSize" type="numeric" required="false" default="#variables.LogFileBufferSize#">
		<cfargument name="maxSize" type="numeric" required="false" default="#variables.LogFileMaxSize#">
		
		<cfscript>
			variables.LogFileName = arguments.logName;
			variables.LogFullPath = arguments.logPath & variables.LogFileName & ".log";
			variables.LogFileEncoding = arguments.encoding;
			variables.LogFileBufferSize = arguments.bufferSize;
			variables.LogFileMaxSize = arguments.maxSize;
		</cfscript>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="logEntry" access="public" returntype="void" hint="Adds a line to the log">
		<cfargument name="Severity" 		type="string" 	required="yes">
		<cfargument name="Message" 			type="string"  	required="yes" hint="The message to log.">
		<cfargument name="ExtraInfo"		type="string"   required="no"  default="" hint="Extra information to append.">

		<cfset var FileWriter = "">
		
		<!--- Check for Severity via RE --->
		<cfif not reFindNoCase("^(#variables.validSeverities#)$", arguments.Severity)>
			<cfthrow type="wscandis.logger.InvalidSeverityException" message="The severity you entered: #arguments.severity# is an invalid severity. Valid severities are #variables.validSeverities#.">
		</cfif>

		<!--- Check for Log File --->
		<cfif not FileExists(variables.logFullPath)>
			<!--- File has been deleted, reinit the log location --->
			<cfset initLogLocation()>
			<!--- Log the occurrence recursively--->
			<cfset logEntry("warning","Log Location had to be reinitialized. The file: #variables.logFullPath# was not found when trying to do a log.")>
		</cfif>

		<!--- Check Rotation --->
		<cfset checkRotation()>

		<cflock type="exclusive" name="LogFileWriter" timeout="120">
			<!--- Init FileWriter --->
			<cftry>
				<cfset FileWriter = createObject("component","fileWriter").setup(variables.logFullPath, variables.LogFileEncoding, variables.LogFileBufferSize, true)>
				<cfcatch type="lock">
					<cfthrow type="wscandis.logger.CreatingFileWriterException" message="An error occurred creating the java FileWriter utility." detail="#cfcatch.Detail#<br>#cfcatch.message#">
				</cfcatch>
			</cftry>

			<!--- Log a new Entry --->
			<cftry>
				<cfset FileWriter.writeLine(formatLogEntry(arguments.severity, arguments.message, arguments.extraInfo))>
				<cfset FileWriter.close()>
				<cfcatch type="any">
					<!--- Close FileWriter First --->
					<cfset FileWriter.close()>
					<cfthrow type="wscandis.logger.WritingFirstEntryException" message="An error occurred writing the first entry to the log file." detail="#cfcatch.Detail#<br>#cfcatch.message#">
				</cfcatch>
			</cftry>
		</cflock>

	</cffunction>


	<!--- ************************************************************* --->
	<!--- Private method 											    --->
	<!--- ************************************************************* --->
	<cffunction name="formatLogEntry" access="private" hint="Format a log request into the specified entry format." output="false" returntype="string">
		<cfargument name="Severity" 		type="string" 	required="yes" hint="error|warning|info">
		<cfargument name="Message" 			type="string"  	required="yes" hint="The message to log.">
		<cfargument name="ExtraInfo"		type="string"   required="no" default="" hint="Extra information to append.">
		<cfscript>
			var LogEntry = "";
			//Manipulate entries
			arguments.severity = trim(lcase(arguments.severity));
			arguments.message = trim(arguments.message) & trim(arguments.extrainfo);
			arguments.message = replace(arguments.message,'"','""',"all");
			arguments.message = replace(arguments.message,"#chr(13)##chr(10)#",'  ',"all");
			arguments.message = replace(arguments.message,chr(13),'  ',"all");
			LogEntry = '"#arguments.Severity#","wscandis-logger","#dateformat(now(),"MM/DD/YYYY")#","#timeformat(now(),"HH:MM:SS")#",,"#arguments.message#"';
			return logEntry;
		</cfscript>		
	</cffunction>

	<cffunction name="checkRotation" access="private" hint="Checks the log file size. If too big then zip and rotate." output="false" returntype="void">
		<cfset var zipFileName = getDirectoryFromPath(variables.logFullPath) & variables.LogFileName & "." & dateformat(now(),"MM.DD.YY") & timeformat(now(),".HH.MM") & ".zip">
		
		<!--- Verify FileSize --->
		<cfif getLogSize() gt (variables.LogFileMaxSize * 1024)>
		
			<!--- Archive file and rotate log --->
			<cftry>
				<!--- Zip Log File --->
				<cflock name="LogFileWriter" type="exclusive" timeout="120">
					<cfset createObject("component","zip").AddFiles(zipFileName, variables.logFullPath, "", "", false, 9, false )>
				</cflock>
				
				<!--- remove old file --->
				<cfset removeLogFile()>

				<!--- reinitialize log --->
				<cfset initLogLocation()>

				<cfcatch type="any">
					<cfset logEntry("error","Could not zip and rotate log files.","#cfcatch.Detail# #cfcatch.Message#")>
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>

	<cffunction name="initLogLocation" access="public" hint="Initialize the log location." output="false" returntype="void">
		<cfset var FileWriter = "">
		<cfset var InitString = "">

		<cflock name="LogFileWriter" type="exclusive" timeout="120">
			<!--- Create Log File if It does not exist and initialize it. --->
			<cfif not fileExists( variables.LogFullPath )>

				<cftry>
					<!--- Create Log File --->
					<cfset createLogFile()>
					
					<!--- Check if we can write to the file --->
					<cfif not logFileCanWrite()>
						<cfthrow type="wscandis.logger.LogFileNotWritableException" message="The log file: #variables.logFullPath# is not a writable file. Please check your operating system's permissions.">
					</cfif>
					<cfcatch type="any">
						<cfthrow type="wscandis.logger.CreatingLogFileException" message="An error occurred creating the log file at #variables.logFullPath#." detail="#cfcatch.Detail#<br>#cfcatch.message#">
					</cfcatch>
				</cftry>

				<cftry>
					<!--- Init the Log File, with framework's default encoding and buffer size --->
					<cfset FileWriter = createObject("component","fileWriter").setup(variables.logFullPath, variables.LogFileEncoding, variables.LogFileBufferSize)>
					<cfcatch type="any">
						<cfthrow type="wscandis.logger.CreatingFileWriterException" message="An error occurred creating the java FileWriter utility." detail="#cfcatch.Detail#<br>#cfcatch.message#">
					</cfcatch>
				</cftry>

				<cftry>
					<!---
						Log Format
						"[severity]" "[ThreadID]" "[Date]" "[Time]" "[Application]" "[Message]"
					--->
					<cfset InitString = '"Severity","ThreadID","Date","Time","Application","Message"'>
					<cfset FileWriter.writeLine(InitString)>
					<cfset FileWriter.writeLine(formatLogEntry("information","The log file has been initialized successfully.","Log file: #variables.logFullPath#; Encoding: #variables.LogFileEncoding#; BufferSize: #variables.LogFileBufferSize#"))>
					<cfset FileWriter.close()>
					<cfcatch type="any">
						<!--- Close FileWriter First --->
						<cfset FileWriter.close()>
						<cfthrow type="wscandis.logger.WritingFirstEntryException" message="An error occurred writing the first entry to the log file." detail="#cfcatch.Detail#<br>#cfcatch.message#">
					</cfcatch>
				</cftry>

			</cfif>
		</cflock>
	</cffunction>

	<cffunction name="removeLogFile" access="public" hint="Removes the log file" output="false" returntype="void">
		<cfset var oFile = 0>
		<cflock name="LogFileWriter" type="exclusive" timeout="120">
			<cfset oFile = createObject("java","java.io.File").init(JavaCast("string", variables.logFullPath))>
			<cfset oFile.delete()>
		</cflock>
	</cffunction>
	
	<cffunction name="getLogSize" access="public" returntype="numeric" output="false" hint="Get the filesize of the log file.">
		<cfset oFile = createObject("java","java.io.File").init(JavaCast("string", variables.logFullPath))>
		<cfreturn oFile.length()>
	</cffunction>

	<cffunction name="logFileCanWrite" access="public" returntype="boolean" output="false" hint="Checks if the log file can be written to.">
		<cfset oFile = createObject("java","java.io.File").init(JavaCast("string", variables.logFullPath))>
		<cfreturn oFile.canWrite()>
	</cffunction>

	<cffunction name="createLogFile" access="public" returntype="string" output="false" hint="creates a new empty file">
		<cfset oFile = createObject("java","java.io.File").init(JavaCast("string", variables.logFullPath))>
		<cfset oFile.createNewFile()>
	</cffunction>
				
</cfcomponent>