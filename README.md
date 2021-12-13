# LG WebOS Developer Mode Extender
This app can extend developer mode timer for the LG TV (you'll need the session token for that)

You can obtain the developer mode session token by logging into your TV via SSH and executing this command:

```shell
cat /var/luna/preferences/devmode_enabled
```

## Building

Run `make all`. You will need Docker for that.

## Usage

Run the binary with following arguments:

```shell
devmode-extender_{arch} --token={devmode session token}
```

Not very useful, huh? That's because it is supposed to run periodically.
Cron example:

```shell
# Runs every day at 03:00
0 3 * * * /root/devmode-extender --token=token
```
