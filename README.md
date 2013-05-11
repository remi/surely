# Surely

Surely is a daemon that watches your screenshots directory and upload new files to your [imgur](http://imgur.com/) account.

## Usage

```bash
# Install the gem
$ gem install surely

# Start it
# The first time you run it, it will open a browser window and ask you to
# enter the OAuth credentials that you will obtain after allowing your imgur app
$ surely start

# After that, you can kill it (^C) (or `ps -ef | grep surely` and `kill` its PID) and start it as a real daemon
$ surely start -d
```

## Taking a screenshot

When you take a screenshot, Surely does three things:

1. Upload it to your imgur account
2. Copy the uploaded file URL into the clipboard
3. Say *Uploaded!* out loud (using the `say` utility)
