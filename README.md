![Alt text](https://raw.githubusercontent.com/pocketvince/Ifsu/main/ifsu_transparent.png?raw=true "logo")

# IFSU (IF a Site has been Updated)
IFSU is a command-line tool for monitoring updates or content changes on a specific website.

It works by computing the MD5 hash of a web page's content and periodically comparing it to detect any changes.

If a change is detected, IFSU can execute a user-specified command.

## Usage

```bash
./ifsu.sh URL "COMMAND" INTERVAL
```
• URL: The URL of the website to monitor.

• COMMAND: The command to execute when a change is detected.

• INTERVAL: The time interval (in seconds) for checking the website.

## Input Example:

• Monitor the price of an item on a sales site

• Follow the evolution and changes of a specific news article

• Know about a new element on a site that does not have RSS

• Follow the reactivation of a temporarily unavailable site

...

## Output Example:

• Trigger a download

• Sending an automatic email

• Adding a task in Notion.so

• Starting an upload

• Shutting down a machine

• Notification on Telegram

...

## Contributing

Readme generator: https://www.makeareadme.com/
Logo: https://openai.com/dall-e-2
