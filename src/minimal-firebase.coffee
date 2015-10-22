###
#
# Using Firebase Synchronously
#
###

# simple json requests
get = ->

  # parse arguments
  next = null
  params = {}
  url = null
  for arg in arguments
    switch typeof arg
      when 'function' then next = arg
      when 'object' then params = arg
      when 'string' then url = arg

  # serialize params
  escape = encodeURIComponent
  qs = ("#{escape k}=#{escape v}" for k, v of params)
  qs = qs.join '&'
  qs = qs.replace '%20', '+'
  url = "#{url}?#{qs}" if qs.length > 0

  # handle request
  result = null
  request = new XMLHttpRequest()
  request.open 'GET', url, next?
  request.onreadystatechange = ->
    if request.readyState is 4
      if request.status >= 200 and request.status < 400
        try
          result = JSON.parse request.responseText
          if next
            next null, result
        catch err
          next err
      else
        next request.responseText
  request.send()

  if next
    return request
  else
    return result

class window.FirebaseSync

  # https://www.firebase.com/docs/web/api/firebase/authanonymously.html
  authAnonymously: (next) ->
    slug = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(@url)?[1]
    url = "https://auth.firebase.com/v2/#{slug}/auth/anonymous"
    params = {
      suppress_status_codes: true
      transport: 'json'
      v: 'js-2.2.9'
    }
    get url, params, next

  # https://www.firebase.com/docs/web/api/firebase/authwithpassword.html
  authWithPassword: (email, password, next) ->
    slug = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(@url)?[1]
    url = "https://auth.firebase.com/v2/#{slug}/auth/password"
    params = {
      email: email
      password: password
      suppress_status_codes: true
      transport: 'json'
      v: 'js-2.2.9'
    }
    get url, params, (err, resp) ->
      return next err if err
      return next resp.error if resp.error
      next null, resp

  # https://www.firebase.com/docs/web/api/firebase/authwithcustomtoken.html
  authWithCustomToken: (token) ->
    @token = token

  # https://www.firebase.com/docs/web/api/firebase/constructor.html
  constructor: (url) ->

    # trim trailing slashes
    @url = url.replace /\/$/, ''

    # check for valid firebase url
    if not @root()
      throw new Error "Invalid firebase url: #{url}"

    # check if the user is authenticated
    auth = @getAuth()
    if auth.token
      @authWithCustomToken auth.token

  # https://www.firebase.com/docs/web/api/firebase/child.html
  child: (path) ->

    # allow specifying path with forward slashes or period
    path = path.split /[\/\.]/g
    path = path.join '/'

    # create new ref
    new FirebaseSync "#{@url}/#{path}"

  # https://www.firebase.com/docs/web/api/firebase/createuser.html
  createUser: (email, password, next) ->
    slug = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(@url)?[1]
    url = "https://auth.firebase.com/v2/#{slug}/users"
    params = {
      _method: 'POST'
      email: email
      password: password
      suppress_status_codes: true
      transport: 'json'
      v: 'js-2.3.1'
    }
    get url, params, (err, resp) ->
      return next err if err
      return next resp.error if resp.error
      next null, resp

  # https://www.firebase.com/docs/web/api/firebase/getauth.html
  getAuth: ->
    slug = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(@url)?[1]
    localStorage["firebase:session::#{slug}"]

  # https://www.firebase.com/docs/web/api/firebase/parent.html
  parent: ->
    path = @url.replace @root(), ''
    last_slash = path.lastIndexOf '/'
    parent = path[0...last_slash]

    # match firebase by returning null from the root
    if parent is ''
      return null

    # create new ref
    new FirebaseSync "#{@root()}#{parent}"

  # https://www.firebase.com/docs/web/api/firebase/root.html
  root: ->
    matches = /(https:\/\/[a-z0-9-]+\.firebaseio\.com).*/.exec @url
    matches?[1]

  # https://www.firebase.com/docs/web/api/firebase/tostring.html
  toString: ->
    @url

  # https://www.firebase.com/docs/web/api/query/once.html
  once: ->

    # parse arguments
    params = {}
    next = null
    for arg in arguments
      switch typeof arg
        when 'object' then params = arg
        when 'function' then next = arg

    # auth
    if @token
      params.auth = @token

    # get data
    url = "#{@url}.json"
    if next
      get url, params, next
    else
      return get url, params
