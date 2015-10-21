
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
