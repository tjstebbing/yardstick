[Yardstick Logo](https://raw.githubusercontent.com/iflix/yardstick/master/ysh/yardstick.png)
![Yardstick Logo](/ysh/yardstick.png?raw=true)
##  Stack-agnostic integration testing

Yardstick doesn't care what you've written your services in, if you can
write a bash script you can test it with Yardstick and the same commandline
tools you're already familiar with. 


```bash
yard module 'http'

testGithubWorks() {
  # gets my info from github
  yard get https://api.github.com/users/pomke

  # assert some values in the json response are correct
  assertEquals 'Check that the status is OK' "$STATUS_CODE" 200
  assertEquals 'Location check, am I in AU?'  $(yard j "$BODY" '.location') 'Australia'
  assertEquals 'Check my Github name' $(yard j "$BODY" '.login') 'pomke'
}
```

## Installation 

### OSX

```bash
brew install iflix/yardstick
```

### Linux

```bash
git clone git@github.com:iflix/yardstick.git
./ysh/install.sh
```

