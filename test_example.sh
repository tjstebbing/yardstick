

yard module 'http' 'json' 

testStuffWorks() {

  # gets my info from github
  yard get https://api.github.com/users/pomke


  # lets assert some stuff
  assert true                                                'Check the world is right way up'

  assert 123 equals 123                                      'Check that number comparison works'
  assert 'foo' equals 'foo'                                  'Check that string comparison works'
 
  assert "$STATUS_CODE" not equals 500
  assert "$STATUS_CODE" equals 200                           'Check that the status is OK'
  assert "$(yard j "$BODY" '.location')" equals 'Australia'  'Location check, am I in AU?' 
  assert "$(yard j "$BODY" '.login')" equals 'pomke'         'Check my Github name is pomke'
  assert "$(yard j "$BODY" '.login')" not equals 'tjs'       'Check my github name is nt somethibng'

}
