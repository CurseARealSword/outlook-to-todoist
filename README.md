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
- prompts for an optional due date/time (e.g. `tomorrow 3pm`, `2026-01-09 09:00`)
- prompts for a task title with the email subject as the default (leave blank to keep subject)

## due date/time examples

Todoist accepts natural language. Examples you can enter in the prompt:

- `today`
- `tomorrow 9am`
- `next monday 14:30`
- `2026-01-09`
- `2026-01-09 09:00`

## install the script locally

Compile the source `.applescript` into a `.scpt` file and place it in your Scripts folder so it can be run from the macOS Script menu.

```sh
mkdir -p ~/Library/Scripts
osacompile -o ~/Library/Scripts/OutlookToTodoist.scpt scripts/OutlookToTodoist.applescript
```

If you want the script to appear under Outlook’s Script menu, place it in the Outlook-specific Scripts folder instead:

```sh
mkdir -p ~/Library/Scripts/Applications/Microsoft\ Outlook
osacompile -o ~/Library/Scripts/Applications/Microsoft\ Outlook/OutlookToTodoist.scpt scripts/OutlookToTodoist.applescript
```


If you prefer a one-liner install, use the helper script:

```sh
scripts/install.sh
```

To install into the Outlook Script menu location instead:

```sh
scripts/install.sh --outlook
```

(or use `OUTLOOK_MENU=1 scripts/install.sh`)

## automator (short how‑to)

Assuming you already have a shortcut set up, you can point it to the compiled `.scpt`:

1. Open Automator and your existing workflow.
2. Add (or update) a “Run AppleScript” action.
3. Replace the default script with `run script (POSIX file "~/Library/Scripts/OutlookToTodoist.scpt")`.
4. Save the workflow.

## uninstall

Remove the compiled script from whichever location you installed it:

```sh
rm -f ~/Library/Scripts/OutlookToTodoist.scpt
rm -f ~/Library/Scripts/Applications/Microsoft\ Outlook/OutlookToTodoist.scpt
```

## roadmap

- add guide for storing secrets in keychain
- create functionality to add time, date & alternative title directly from outlook
- automate conversion from .applescript in repo to .script in the correct local folder (`~/Library/Scripts`)
