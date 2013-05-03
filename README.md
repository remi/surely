# Surely

Surely is a daemon that watches your screenshots directory and upload new files to your [imgur](http://imgur.com/) account.

## Usage

```bash
# Install the gem
$ gem install surely

# Configure it (environment variables sucks but that’ll do for now)
# Create an imgur application here: https://api.imgur.com/oauth2/addclient
export IMGUR_CLIENT_ID=…
export IMGUR_CLIENT_SECRET=…

# Start it
# The first time you run it, it will open a browser window and ask you to
# enter the OAuth credentials that you will obtain after allowing your imgur app
$ surely start

# After that, you can kill it (^C) and start it as a real daemon
$ surely start -d
```
