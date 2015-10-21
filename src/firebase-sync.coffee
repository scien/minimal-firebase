###
#
# Using Firebase Synchronously
#
###

class window.FirebaseSync

  # https://www.firebase.com/docs/web/api/firebase/constructor.html
  constructor: (url) ->

    # trim trailing slashes
    @url = url.replace /\/$/, ''

    # check for valid firebase url
    if not @root()
      throw new Error "Invalid firebase url: #{url}"

  # https://www.firebase.com/docs/web/api/firebase/child.html
  child: (path) ->

    # allow specifying path with forward slashes or period
    path = path.split /[\/\.]/g
    path = path.join '/'

    # create new ref
    new FirebaseSync "#{@url}/#{path}"

  # https://www.firebase.com/docs/web/api/firebase/root.html
  root: ->
    matches = /(https:\/\/[a-z0-9-]+\.firebaseio\.com).*/.exec @url
    matches?[1]

  # https://www.firebase.com/docs/web/api/firebase/tostring.html
  toString: ->
    @url
