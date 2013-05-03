# Surely

Surely watches your screenshots directory and upload new files to your imgur account.

## Usage

Get the gem:

```shell
$ gem install surely
```

Configure it (these need to be command line options, but that’ll do for now)

```shell
export IMGUR_CLIENT_ID=…
export IMGUR_CLIENT_SECRET=…
```

Start the daemon:

```shell
$ DIRECTORY=/path/to/screenshots surely
```
