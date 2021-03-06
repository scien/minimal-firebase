## Minimal Firebase

The current firebase.js download is 210k. Minified it's down to 132k. And add
in gzip compression to get it to 44k.

Firebase has a ton of features, but many times you don't need all of them.
This project aims to be a minimal, not full-featured implementation of the
Javascript SDK through use of the REST API.

At its core, The main goal is to have a quick way to simply load and query
data from your firebase.

Comparing to the sizes above, it is currently 5.7k, 2.8k, and 1.4k.

[![Build Status](https://travis-ci.org/scien/minimal-firebase.svg?style=flat-square)](https://travis-ci.org/scien/minimal-firebase)
[![NPM version](http://img.shields.io/npm/v/minimal-firebase.svg?style=flat-square)](https://www.npmjs.org/package/minimal-firebase)

## Usage

1. Include MinimalFirebase:
  ```html
  <script src="build/minimal-firebase.min.js"></script>
  ```

2. Use it:
  ```coffeescript
  # setup your minimal firebase
  firebase_root = "https://minimal-firebase.firebaseio.com"
  firebase = new MinimalFirebase(firebase_root)

  # get refs
  child = firebase.child "some_key"
  parent = child.parent()
  console.log "child.path = #{child.toString()}"
  console.log "child.key = #{child.key()}"
  
  # load data
  child.once (err, value) ->
    console.log "child value = #{value}"
  child.once {shallow: true}, (err, value) ->
    console.log "child shallow value", value
  child.once {format: 'export'}, (err, value) ->
    console.log "child value with priorities", value

  # load data synchronously
  value = child.once()

  # authenticate
  user = firebase.getAuth()
  firebase.createUser 'hello@test.com', 'world', (err, user) ->
    console.log user.uid
  firebase.authWithPassword 'hello@test.com', 'world', (err, user) ->
    console.log user.uid
  firebase.authAnonymously (err, user) ->
    console.log user.provider
  ```

## License
©2015 Bryant Williams under the [MIT license](http://opensource.org/licenses/MIT):

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
