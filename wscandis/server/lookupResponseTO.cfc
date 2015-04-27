<cfcomponent name="lookupResponseTO" hint="this is a transfer object that contains the response of directory service lookup">
	
	<!--- All setters and getters will be created automatically for the given properties --->
	
	<cfproperty name="name" type="string" hint="TThe requested name" required="true">
	<cfproperty name="address" type="string" hint="The resolved address for the requested name" required="true">
	<cfproperty name="TTL" type="numeric" hint="This is the number of minutes for which the resolved address should be considered valid." required="true">
	<cfproperty name="description" type="string" hint="Description of the service" required="true">
	<cfproperty name="error" type="boolean" default="false" hint="This flag is used to determine if an error ocurred" required="true">
	<cfproperty name="errorMessage" type="string" hint="Description of error message" required="true">
	<cfproperty name="referrer" type="string" hint="Echoes the referrer used to resolve the address" required="true">

</cfcomponent>