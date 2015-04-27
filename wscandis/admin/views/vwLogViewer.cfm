<cfparam name="request.requestState.qryLog" default="">
<cfparam name="startRow" default="1">

<cfset qryLog = request.requestState.qryLog>

<cfset rowsPerPage = 15>
<cfset numPages = ceiling( qryLog.recordCount / rowsPerPage)>
<cfset currPage = int(startRow/rowsPerPage)+1>
<cfset endRow = startRow+rowsPerPage-1>
<cfif endRow gt qryLog.recordCount>
	<cfset endRow = qryLog.recordCount>
</cfif>
<cfset pageURL = "index.cfm?event=ehGeneral.dspLogViewer">

<cfquery name="qryLog" dbtype="query">
	SELECT *
		FROM qryLog
		ORDER BY [Date] DESC, [Time] DESC
</cfquery>

<h2>Log Viewer</h2>


<cfoutput>
	<div style="font-size:10px;line-height:20px;margin-top:10px;font-weight:bold;">
		Showing entries #startRow# - #endRow# of #qryLog.recordCount#
	</div>
</cfoutput>
<table class="browseTable" style="width:100%;line-height:14px;">	
	<tr  class="listTH listingTableHeader">
		<th>&nbsp;</th>
		<th width="120">Date/Time</th>
		<th width="120">Referrer</th>
		<th>Message</th>
	</tr>
	<cfset RowIndex = startRow>
	<cfoutput query="qryLog" startrow="#startRow#" maxrows="#rowsPerPage#">
		<cfset imgSrc = replaceList(severity,"information,fatal,warning,error,debug","information,error,error,error,comment")>
		<tr class="listingTableCell <cfif qryLog.currentRow mod 2>listTRWhite</cfif>" style="font-size:11px;">
			<td align="center"><img src="images/icons/#imgSrc#.png" align="absmiddle" alt="#severity#"></td>
			<td align="center" nowrap width="120">#dateFormat(Date,'mm/dd/yy')# #TimeFormat(Time,"medium")#</td>
			<td width="120">
				<cfif listLen(message,"|") gte 3>
					#listGetAt(message,3,"|")#
				</cfif>
			</td>
			<td>
				<cfif listLen(message,"|") gt 1>
					<strong>&raquo;</strong> #listGetAt(message,1,"|")#<br>
					<strong>&laquo;</strong> <a href="#listGetAt(message,2,"|")#" target="_blank">#listGetAt(message,2,"|")#</a><br>
					<cfif listLen(message,"|") gte 4>
						<span style="color:red;"><strong>Error:</strong> #listGetAt(message,4,"|")#</span>
					</cfif>
				<cfelse>
					#message#
				</cfif>
			</td>
		</tr>
		<cfset rowIndex = rowIndex + 1>
	</cfoutput>		
	<cfif qryLog.recordCount eq 0>
		<tr>
			<td colspan="4" class="listingTableCell" style="font-size:11px;">
				<em>The log is empty!</em>
			</td>
		</tr>
	</cfif>
</table>

<cfoutput>
	<div style="font-size:10px;line-height:20px;margin-top:10px;font-weight:bold;">
		Page #currPage# of #numPages#
		&nbsp;&nbsp;&middot;&nbsp;&nbsp;

		<cfif numPages gt 1>
			<cfif currPage gt 1>
				<a href="#pageURL#&startRow=#(currPage-2)*rowsPerPage+1#">Previous Page</a>
				&nbsp;&nbsp;
			</cfif>
			<cfif currPage lt numPages>
				<a href="#pageURL#&startRow=#(currPage)*rowsPerPage+1#">Next Page</a>
				&nbsp;&nbsp;
			</cfif>
			&nbsp;&nbsp;&middot;&nbsp;&nbsp;
		</cfif>

		<cfloop from="1" to="#numPages#" index="i">
			<a href="#pageURL#&startRow=#(i-1)*rowsPerPage+1#">#i#</a>
			&nbsp;&nbsp;
		</cfloop>
	</div>	
</cfoutput>

<br>
<input type="button" name="btnDelete" value="Delete Log" onclick="if(confirm('Are you sure you wish to delete the log file?')) document.location='index.cfm?event=ehGeneral.doDeleteLog'">

