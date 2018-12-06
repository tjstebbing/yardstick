![Yardstick Logo](/ysh/yardstick.png?raw=true)

##  Stack-agnostic integration testing

Yardstick doesn't care what you've written your services in, if you can
write a bash script you can test it with Yardstick and the same commandline
tools you're already familiar with. 

## TL;DR

```bash
yard module 'http' 'json' 

testGithubWorks() {

  # gets my info from github
  yard get https://api.github.com/users/pomke

  # assert some values in the json response are correct
  assert "$STATUS_CODE" equals 200                          'Check that the status is OK'
  assert $(yard j "$BODY" '.location') equals 'Australia'   'Location check, am I in AU?' 
  assert $(yard j "$BODY" '.login') equals 'pomke'          'Check my Github name'

}
```

Run it! 

```bash
> yardstick test_github.sh

[test] testGithubWorks

Ran 1 tests.

OK
```



## Writing tests

yardstick tests are simply bash functions that begin with `test` and are assembled in 
a yard test suite (a bash script, beginning with test_). These tests are executed in
sequence and any assertions are exercised and reported.

#### The `yard` command

Yardstick provides a global `yard` command which has subcommands implemented by yard
modules. By default the `yard` command has one subcommand `module` which is used to 
load further yard modules.

```bash
yard module 'http'
```

will import the builtin 'http' module which wraps httpie and allows you to execute
http requests from your tests.

Yard modules are looked up in two locations, core modules first are available in
`yardstick/ysh/` and local modules are loaded from `./` and should live with your 
test files. 

You can add new `yard` subcommands from your own local modules by writing `yard_*`
functions. the only caveat for writing new modules is that you MUST include  
`export mod_foo=true` where _foo_ is the name of your module. This prevents `yard module`
from loading a module twice if it is required by multiple test suites run together.

#### The `assert` command

The `assert` command provides a simple way to check the validity of values in your
tests. the format is:

```bash
# all comments are optional, but provide better debugging and reporting output.

assert "$v"                       'comment'
assert "$v" equals "$v"           'comment'
assert "$v" not equals "$v2"      'comment'
assert "$v" null                  'comment'
assert "$v" not null              'comment'
```

#### Setup & Teardown functions

Most testing systems provide setup and teardown functionality, however bash already
provides for this with the `trap` command. You can implement setup and teardown
in your own scripts like so: 

```bash

setup() {
  echo "setting up"
}

teardown() {
  echo "tearing down"
}

trap teardown EXIT
setup
```


