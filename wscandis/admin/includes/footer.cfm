<cfparam name="request.requestState.versionTag" default="">
<cfset versionTag = request.requestState.versionTag>

<div style="width:200px;font-size:9px;margin:0 auto;text-align:center;line-height:15px;">
	wscandis - v.<cfoutput>#versionTag#</cfoutput>
</div>
