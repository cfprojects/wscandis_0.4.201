<cfset authType = getValue("authType","")>

<cfheader statuscode="401">
<cfheader name="www-Authenticate" value="Basic realm=""Sandals #authtype# Authentication""">	