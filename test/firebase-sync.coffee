
###
# jsom 3.x documentation: http://bit.ly/1OROksU
###

# dependencies
expect = require 'expect.js'
fs = require 'fs'
jsdom = require 'jsdom'

# locals
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
