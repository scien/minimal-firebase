
# dependencies
expect = require 'expect.js'
fs = require 'fs'
jsdom = require 'jsdom'

# tests
describe 'Firebase Sync', ->

  it 'works', (done) ->
    jsdom.env {
      html: '<html><body></body></html>'
      src: [
        fs.readFileSync './build/firebase-sync.js', 'utf-8'
      ]
      done: (err, window) ->
        console.log window.test()
        ref = window.FirebaseSync
        expect(ref).to.be.ok()
        done()
    }
