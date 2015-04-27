/**************************************************************/	
/* WebServices Caching and Directory Service (wscandis) v 0.4 */
/* http://wscandis.riaforge.org
/**************************************************************/	
/*
  Copyright 2007 - Oscar Arevalo (http://www.oscararevalo.com)
  
  Licensed under the Apache License, Version 2.0 (the "License"); 
  you may not use this file except in compliance with the License. 
  You may obtain a copy of the License at 
  
	http://www.apache.org/licenses/LICENSE-2.0 
	
  Unless required by applicable law or agreed to in writing, software 
  distributed under the License is distributed on an "AS IS" BASIS, 
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
  See the License for the specific language governing permissions and 
  limitations under the License. 
*/ 

About WSCandis
--------------------------------------------------------------------------------------
WSCandis is a Coldfusion MX application used to facilitate the integration of applications into a Service Oriented Architecture (SOA). 

WSCandis includes a client and a server components. 

The server component allows you to create a directory of webservices that can be queried by other applications to retrieve the correct WSDL to a webservice by using an alias to the webservice. Additionally the server component allows you to specify different WSDLs to return depending on which server is making the request.

The client component provides the mechanism to query the directory service and additionally provides a caching mechanism for directory answers and for webservices instances. This eliminates the need to constantly call the server component and limits the network overhead of using wscandis. The caching of webservice instances is aimed to improve the performance of applications that rely heavily on calling remote methods via webservices.

Please checkout the wiki (http://wscandis.riaforge.org/wiki/) for more details.



Installation and Usage Notes:
--------------------------------------------------------------------------------------
* To install WSCandis just unpack the zip file into your webserver, by default it assumes it will be deployed to a folder named /wscandis located at the root level. This must be an actual location and not just a CF mapping since it requires to access some XML files by path.

* To use WSCandis on a different location, change the following files with the appropriate paths:
	/wscandis/server/dataProvider-config.xml (line 3)
	/wscandis/admin/config.xml (line 16)

* WSCandis includes both server and client components included on the same zip file, you may deploy WSCandis as is on both client and server machines, or if desired you may remove either the /client or /server directories as needed.

* To configure and manage the server component go to /<wscandis-path>/admin.
The default username/password is:
		username: admin
		password: 123456789
		
* To use the client component your application needs to instantiate the wscandis.client.webServiceFactory component passing the WSDL pointing to the server component (wscandis.server.directoryServiceWS), and then use the getService() method to retrieve the webservice instances. Please checkout the wiki for more details.

* For the Administrator application you may also want to setup proper email addresses for sending bug reports. To setup the correct sender and recipient addresses change the following lines:
		/wscandis/admin/Application.cfc (lines 13-14)
		/wscandis/admin/config/config.xml (lines 7-9)

		
Contributors
---------------------------------------------------------------------------
* I want to thank Luis Majano (http://www.luismajano.com) for his ideas and for providing the base code for the logging mechanism, which is based on the logger plugin from Coldbox.



Bugs, suggestions, criticisms, well-wishes, good vibrations, magic spells, and similar
---------------------------------------------------------------------------
Please send to oarevalo@gmail.com or share them on the forum at http://wscandis.riaforge.org/



