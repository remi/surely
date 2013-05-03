# Surely

Surely watches your screenshots directory and upload new files to your [imgur](http://imgur.com/) account.

## Usage

```bash
# Install the gem
$ gem install surely

# Configure it (this sucks but that’ll do for now)
# Create an imgur application here: https://api.imgur.com/oauth2/addclient
export IMGUR_CLIENT_ID=…
export IMGUR_CLIENT_SECRET=…

# Start the watcher (OS X screenshots directory by default)
$ surely
```
