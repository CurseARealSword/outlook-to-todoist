(*
create a Todoist task from the currently selected message in outlook for mac.
- Uses Todoist REST v2 /tasks endpoint
- Adds an outlook:// link in the task description
*)

property TODOIST_TOKEN : missing value
property TODOIST_PROJECT_ID : "2312236412"

on run
	set TODOIST_TOKEN to do shell script "security find-generic-password -a $USER -s todoist_api_token -w"
	tell application "Microsoft Outlook"
		set sel to selected objects
		if sel is {} then
			display notification "Select an email in Outlook first." with title "Outlook → Todoist"
			return
		end if
		
		set msg to item 1 of sel
		set msgSubject to subject of msg
		set msgId to id of msg
		set msgSender to sender of msg
		set msgReceived to time received of msg
	end tell
	
	set outlookUrl to "outlook://" & msgId
	set dueString to ""
	try
		set dueDialog to display dialog "Due date/time (optional):" default answer "" buttons {"Skip", "OK"} default button "OK"
		if button returned of dueDialog is "OK" then
			set dueString to my trim_text(text returned of dueDialog)
		end if
	end try
	
	set titleDialog to display dialog "Task title (leave blank to use subject):" default answer msgSubject buttons {"Cancel", "OK"} default button "OK"
	if button returned of titleDialog is "Cancel" then return
	set taskContent to my trim_text(text returned of titleDialog)
	if taskContent is "" then set taskContent to msgSubject
	
	set senderName to ""
	set senderAddress to ""
	try
		set senderName to name of msgSender
	end try
	try
		set senderAddress to address of msgSender
	end try
	set senderLine to senderName
	if senderLine is "" then set senderLine to senderAddress
	if senderLine is "" then set senderLine to (msgSender as string)
	if senderAddress is not "" and senderLine does not contain senderAddress then
		set senderLine to senderLine & " <" & senderAddress & ">"
	end if
	
	set taskDescription to "Email link: " & outlookUrl & return & ¬
		"From: " & senderLine & return & ¬
		"Received: " & (msgReceived as string)
	
	set json to "{\"content\":" & my json_escape(taskContent) & ",\"description\":" & my json_escape(taskDescription)
	if TODOIST_PROJECT_ID is not "" then
		set json to json & ",\"project_id\":\"" & TODOIST_PROJECT_ID & "\""
	end if
	if dueString is not "" then
		set json to json & ",\"due_string\":" & my json_escape(dueString)
	end if
	set json to json & "}"
	
	set cmd to "curl -sS -X POST https://api.todoist.com/rest/v2/tasks " & ¬
		"-H " & quoted form of ("Authorization: Bearer " & TODOIST_TOKEN) & " " & ¬
		"-H " & quoted form of "Content-Type: application/json" & " " & ¬
		"--data " & quoted form of json
	
	try
		do shell script cmd
		display notification "created task in Todoist." with title "Outlook → Todoist"
	on error errMsg number errNum
		display dialog "Failed to create task." & return & return & errMsg buttons {"OK"} default button "OK"
	end try
end run

-- Simple JSON string escaper for AppleScript
on json_escape(s)
	set s to my replace_text("\\", "\\\\", s)
	set s to my replace_text("\"", "\\\"", s)
	set s to my replace_text(return, "\\n", s)
	return "\"" & s & "\""
end json_escape

on trim_text(s)
	repeat while s begins with " " or s begins with tab
		if (length of s) is 0 then exit repeat
		set s to text 2 through -1 of s
	end repeat
	repeat while s ends with " " or s ends with tab
		if (length of s) is 0 then exit repeat
		set s to text 1 through -2 of s
	end repeat
	return s
end trim_text

on replace_text(find, repl, theText)
	set AppleScript's text item delimiters to find
	set parts to every text item of theText
	set AppleScript's text item delimiters to repl
	set theText to parts as text
	set AppleScript's text item delimiters to ""
	return theText
end replace_text
