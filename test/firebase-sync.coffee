
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
describe 'Firebase Sync', ->

  # setup jsdom
  before (done) ->
    jsdom.env {
      html: '<html><body></body></html>'
      scripts: [
        'http://code.jquery.com/jquery.js'
      ]
      src: [
        fs.readFileSync './build/firebase-sync.js', 'utf-8'
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

  it 'should be able to get data (numbers)', ->
    ref = firebase.child 'test/number'
    expect(ref.value()).to.equal 42

  it 'should be able to get data (strings)', ->
    ref = firebase.child 'test/string'
    expect(ref.value()).to.equal 'hello world'

  it 'should be able to get data (objects)', ->
    ref = firebase.child 'test/object'
    expect(ref.value().foo).to.equal 'bar'
