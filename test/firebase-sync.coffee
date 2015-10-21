
###
# jsom 3.x documentation: http://bit.ly/1OROksU
###

# dependencies
expect = require 'expect.js'
fs = require 'fs'
jsdom = require 'jsdom'

# tests
describe 'Firebase Sync', ->

  jsdom.env {
    html: '<html><body></body></html>'
    src: [
      fs.readFileSync './build/firebase-sync.js', 'utf-8'
    ]
    done: (err, window) ->
      jsdom.getVirtualConsole(window).sendTo console

      console.log 'it'
      it 'is defined', (done) ->
        expect(window.FirebaseSync).to.be.ok()
        done()

      run()
  }


