# IFSU (IF a Site has been Updated)
IFSU is a command-line tool for monitoring updates or content changes on a specific website.

It works by computing the MD5 hash of a web page's content and periodically comparing it to detect any changes.

If a change is detected, IFSU can execute a user-specified command.

## Usage

```bash
./ifsu.sh URL COMMAND INTERVAL
```
• URL: The URL of the website to monitor.

• COMMAND: The command to execute when a change is detected.

• INTERVAL: The time interval (in seconds) for checking the website.

## Notes
20231029: Doesn't seem to work properly on sites with dynamic content (cookie analysis, video, ads, etc.), need to add a switch and another method for this type of site

## Contributing

Readme generator: https://www.makeareadme.com/
