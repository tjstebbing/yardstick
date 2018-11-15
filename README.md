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


## Installation 

```bash
git clone git@github.com:iflix/yardstick.git
./ysh/install.sh
```

##### Requirements

* OSX: _brew_
* Linux: _snap_


## Writing tests

#### Setup & Teardown functions
#### Loading yard modules
#### Environment configuration

## Writing yard modules
