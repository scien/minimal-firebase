
###
# jsom 3.x documentation: http://bit.ly/1OROksU
###

# dependencies
expect = require 'expect.js'
fs = require 'fs'
jsdom = require 'jsdom'

# locals
FB_ROOT = 'https://fb-sync.firebaseio.com'
firebase = null
window = null

# tests
describe 'Minimal Firebase', ->

  # setup jsdom
  before (done) ->
    jsdom.env {
      html: '<html><body></body></html>'
      src: [
        fs.readFileSync './build/minimal-firebase.js', 'utf-8'
      ]
      done: (err, _window) ->
        window = _window
        jsdom.getVirtualConsole(window).sendTo console
        done()
  }

  it 'is defined', ->
    expect(window.FirebaseSync).to.be.ok()

  it 'can be constructed', ->
    firebase = new window.FirebaseSync FB_ROOT
    expect(firebase).to.be.ok()

  it 'should be able to get the root firebase url', ->
    ref = firebase.child 'test'
    expect(ref.root()).to.equal FB_ROOT

  it 'should crash if the input url is not a firebase url', ->
    fn = window.FirebaseSync
    url = 'https://google.com'
    expect(fn).withArgs(url).to.throwError()

  it 'should trim trailing slashes from the url', ->
    ref = new window.FirebaseSync "#{FB_ROOT}/"
    expect(ref.url).to.equal FB_ROOT

  it 'should be able to get a child ref', ->
    path = 'testing/1/2/3'
    ref = firebase.child path
    expect(ref.toString()).to.equal "#{FB_ROOT}/#{path}"

  it 'should be able to get a child ref with period', ->
    ref = firebase.child 'testing.1.2.3'
    expect(ref.toString()).to.equal "#{FB_ROOT}/testing/1/2/3"

  it 'should have a toString() equal to the path', ->
    ref = firebase.child 'test'
    expect(firebase.toString()).to.equal firebase.url
    expect(ref.toString()).to.equal ref.url

  it 'should be able to get the parent ref', ->
    ref = firebase.child 'a/b/c'
    parent = ref.parent()
    expect(parent.url).to.equal "#{FB_ROOT}/a/b"

  it 'should have a null parent on the root ref', ->
    ref = firebase.parent()
    expect(ref).to.equal null

  it 'should be able to get data (numbers)', (done) ->
    ref = firebase.child 'test/number'
    ref.once (err, value) ->
      expect(err).to.equal null
      expect(typeof value).to.equal 'number'
      expect(value).to.equal 42
      done()

  it 'should be able to get data (strings)', (done) ->
    ref = firebase.child 'test/string'
    ref.once (err, value) ->
      expect(err).to.equal null
      expect(typeof value).to.equal 'string'
      expect(value).to.equal 'hello world'
      done()

  it 'should be able to get data (objects)', (done) ->
    ref = firebase.child 'test/object'
    ref.once (err, value) ->
      expect(err).to.equal null
      expect(typeof value).to.equal 'object'
      expect(value).to.eql {foo: 'bar'}
      done()

  it 'should be able to get data (arrays)', (done) ->
    ref = firebase.child 'test/array'
    ref.once (err, value) ->
      expect(err).to.equal null
      expect(Array.isArray value).to.equal true
      expect(value.toString()).to.equal "1,2,3"
      done()

  it 'should be able to get shallow data', ->
    ref = firebase.child 'test/shallow'
    ref.once {shallow: true}, (err, value) ->
      expect(err).to.equal null
      expect(value).to.eql {x: true, y: true}

  it 'should be able to get data synchronously', ->
    ref = firebase.child 'test/number'
    value = ref.once()
    expect(typeof value).to.equal 'number'
    expect(value).to.equal 42

  it 'should be able to auth anonymously', (done) ->
    firebase.authAnonymously (err, user) ->
      expect(err).to.equal null
      expect(user.provider).to.equal 'anonymous'
      done()

  it 'should be able to create a new user', (done) ->
    email = "user_#{Date.now()}@test.com"
    password = "hello world #{Math.random()}"
    firebase.createUser email, password, (err, user) ->
      expect(err).to.equal null
      expect(user).to.have.property 'uid'
      done()

  it 'should fail trying to create an existing user', (done) ->
    email = 'hello@test.com'
    password = 'world'
    firebase.createUser email, password, (err, user) ->
      expect(err?.code).to.equal 'EMAIL_TAKEN'
      done()

  it 'should be able to auth with password', (done) ->
    email = 'hello@test.com'
    password = 'world'
    firebase.authWithPassword email, password, (err, user) ->
      expect(err).to.equal null
      expect(user.uid).to.equal '988655a2-e4cc-4651-b095-292784be4d4c'
      done()

  it 'should catch invalid password for auth with password', (done) ->
    email = 'hello@test.com'
    password = 'invalid'
    firebase.authWithPassword email, password, (err, user) ->
      expect(err?.code).to.equal 'INVALID_PASSWORD'
      done()
