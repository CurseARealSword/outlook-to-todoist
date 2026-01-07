# outlook to todoist (macos)


## overview

- small macos automation that creates todoist tasks from selected emails in microsoft outlook (legacy)
- designed for environments where the official todoist outlook add-in cannot be used (outlook add-ins disallowed because of corporate policy)
- implemented in applescript and run locally via automator (or similar)
- creates a todoist task using the email subject as the task title
- adds an outlook deep link to the task description to jump back to the original email
- uses the todoist rest api (no browser automation, no add-ins)
- stores the todoist api token securely in macos keychain
- intended to be simple  and easy to extend incrementally

## roadmap

- add guide for storing secrets in keychain
- create functionality to add time, date & alternative title directly from outlook
- automate conversion from .applescript in repo to .script in the correct local folder (`~/Library/Scripts`)

