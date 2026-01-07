(*
create a Todoist task from the currently selected message in outlook for mac.
- Uses Todoist REST v2 /tasks endpoint
- Adds an outlook:// link in the task description
*)

set TODOIST_TOKEN to do shell script "security find-generic-password -a $USER -s todoist_api_token -w"
property TODOIST_PROJECT_ID : "2312236412"

on run
	tell application "Microsoft Outlook"
		set sel to selected objects
		if sel is {} then
			display notification "Select an email in Outlook first." with title "Outlook → Todoist"
			return
		end if
		
		set msg to item 1 of sel
		set msgSubject to subject of msg
		set msgId to id of msg
	end tell
	
	set outlookUrl to "outlook://" & msgId
	
	set taskContent to msgSubject
	set taskDescription to "Email link: " & outlookUrl
	
	set json to "{\"content\":" & my json_escape(taskContent) & ",\"description\":" & my json_escape(taskDescription)
	if TODOIST_PROJECT_ID is not "" then
		set json to json & ",\"project_id\":\"" & TODOIST_PROJECT_ID & "\""
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

on replace_text(find, repl, theText)
	set AppleScript's text item delimiters to find
	set parts to every text item of theText
	set AppleScript's text item delimiters to repl
	set theText to parts as text
	set AppleScript's text item delimiters to ""
	return theText
end replace_text

