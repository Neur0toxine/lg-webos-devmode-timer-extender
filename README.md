# LG WebOS Developer Mode Extender
This app can extend developer mode timer for the LG TV (you'll need the session token for that)

You can obtain the developer mode session token by logging into your TV and executing this command:

```shell
cat /var/luna/preferences/devmode_enabled
```

## Building

Run `make all`. You will need Docker for that.
