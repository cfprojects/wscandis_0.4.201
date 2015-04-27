<!--- this template contains the application's main menu --->
<cfparam name="request.requestState.qryMenu" default="QueryNew('')">
<cfparam name="request.requestState.selectedOption" default="">
<cfparam name="request.requestState.oUserInfo" default="0">

<cfset oUserInfo = request.requestState.oUserInfo>

<cfif isObject(oUserInfo) and oUserInfo.getUsername() neq "">
	<cfset qryMenu = request.requestState.qryMenu>
	<cfset selectedOption = request.requestState.selectedOption>
	
	<ul>
		<cfoutput query="qryMenu" group="group">
			<li>
				<strong>#group#</strong>
				<ul>
					<cfoutput>
						<li>
							<a href="#href#" <cfif selectedOption eq label>class="selected"</cfif>>
								<cfif selectedOption eq label>
									<div style="float:right;margin-right:10px;margin-top:0px;">&raquo;</div>
								</cfif>
								#label#</a>
						</li>
					</cfoutput>
				</ul>
			</li>
		</cfoutput>
	</ul>
</cfif>
