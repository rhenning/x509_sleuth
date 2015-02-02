[![Build Status](https://travis-ci.org/rhenning/x509_sleuth.svg?branch=master)](https://travis-ci.org/rhenning/x509_sleuth)

# x509_sleuth

A tool to remotely scan for and investigate X.509 certificates used in SSL/TLS

# Usage

Clone this repo and install the gem
```
cd x509_sleuth
bundle install
bundle exec rake install
```

## Run the example script

```
cd examples
bundle install
bundle exec ./example.rb
```
You should see output similar to:

```
+----------------+--------------------------------------------------------------------+---------------------+-------------------------+-------------------------+
| host           | subject                                                            | serial              | not_before              | not_after               |
+----------------+--------------------------------------------------------------------+---------------------+-------------------------+-------------------------+
| www.google.com | /C=US/ST=California/L=Mountain View/O=Google Inc/CN=www.google.com | 5727081030881357105 | 2015-01-14 13:14:16 UTC | 2015-04-14 00:00:00 UTC |
+----------------+--------------------------------------------------------------------+---------------------+-------------------------+-------------------------+
```

## Use the command line tool

```
x509_sleuth scan --target www.google.com
```

You should see output like the script example above.

# Contributors

* [Richard Henning](https://github.com/rhenning)
* [Travis Truman](https://github.com/trumant)
