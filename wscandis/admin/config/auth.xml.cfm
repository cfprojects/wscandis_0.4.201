<?xml version="1.0" encoding="UTF-8"?>
<auth-config>
	<!-- This xml file is used to store settings
		for user authentication -->
	
	<!-- This setting defines how the application will request
		the user credentials. Use CFLogin to display a form,
		or Challenge to have the browser request for credentials -->
	<authlogin>CFLogin</authlogin>


	<!-- Simple Authentication -->
	<auth-module loginService="SimpleLoginService" name="Simple">
		<suser>admin</suser>
		<spwd>B7A5DFBA0496B822CC15EF488BB751B4074BF22D</spwd>	
	</auth-module>
	
	<!-- Sys admins -->
	<sysadmins>
		<username>admin</username>
	</sysadmins>		

</auth-config>
