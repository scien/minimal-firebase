
/*
 *
 * Using Firebase Synchronously
 *
 */

(function() {
  var get;

  get = function() {
    var arg, escape, i, k, len, next, params, qs, request, result, url, v;
    next = null;
    params = {};
    url = null;
    for (i = 0, len = arguments.length; i < len; i++) {
      arg = arguments[i];
      switch (typeof arg) {
        case 'function':
          next = arg;
          break;
        case 'object':
          params = arg;
          break;
        case 'string':
          url = arg;
      }
    }
    escape = encodeURIComponent;
    qs = (function() {
      var results;
      results = [];
      for (k in params) {
        v = params[k];
        results.push((escape(k)) + "=" + (escape(v)));
      }
      return results;
    })();
    qs = qs.join('&');
    qs = qs.replace('%20', '+');
    if (qs.length > 0) {
      url = url + "?" + qs;
    }
    result = null;
    request = new XMLHttpRequest();
    request.open('GET', url, next != null);
    request.onreadystatechange = function() {
      var err;
      if (request.readyState === 4) {
        if (request.status >= 200 && request.status < 400) {
          try {
            result = JSON.parse(request.responseText);
            if (next) {
              return next(null, result);
            }
          } catch (_error) {
            err = _error;
            return next(err);
          }
        } else {
          return next(request.responseText);
        }
      }
    };
    request.send();
    if (next) {
      return request;
    } else {
      return result;
    }
  };

  window.FirebaseSync = (function() {
    FirebaseSync.prototype.authAnonymously = function(next) {
      var params, ref, slug, url;
      slug = (ref = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(this.url)) != null ? ref[1] : void 0;
      url = "https://auth.firebase.com/v2/" + slug + "/auth/anonymous";
      params = {
        suppress_status_codes: true,
        transport: 'json',
        v: 'js-2.2.9'
      };
      return get(url, params, next);
    };

    FirebaseSync.prototype.authWithPassword = function(email, password, next) {
      var params, ref, slug, url;
      slug = (ref = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(this.url)) != null ? ref[1] : void 0;
      url = "https://auth.firebase.com/v2/" + slug + "/auth/password";
      params = {
        email: email,
        password: password,
        suppress_status_codes: true,
        transport: 'json',
        v: 'js-2.2.9'
      };
      return get(url, params, function(err, resp) {
        if (err) {
          return next(err);
        }
        if (resp.error) {
          return next(resp.error);
        }
        return next(null, resp);
      });
    };

    FirebaseSync.prototype.authWithCustomToken = function(token) {
      return this.token = token;
    };

    function FirebaseSync(url) {
      var auth;
      this.url = url.replace(/\/$/, '');
      if (!this.root()) {
        throw new Error("Invalid firebase url: " + url);
      }
      auth = this.getAuth();
      if (auth != null ? auth.token : void 0) {
        this.authWithCustomToken(auth.token);
      }
    }

    FirebaseSync.prototype.child = function(path) {
      path = path.split(/[\/\.]/g);
      path = path.join('/');
      return new FirebaseSync(this.url + "/" + path);
    };

    FirebaseSync.prototype.createUser = function(email, password, next) {
      var params, ref, slug, url;
      slug = (ref = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(this.url)) != null ? ref[1] : void 0;
      url = "https://auth.firebase.com/v2/" + slug + "/users";
      params = {
        _method: 'POST',
        email: email,
        password: password,
        suppress_status_codes: true,
        transport: 'json',
        v: 'js-2.3.1'
      };
      return get(url, params, function(err, resp) {
        if (err) {
          return next(err);
        }
        if (resp.error) {
          return next(resp.error);
        }
        return next(null, resp);
      });
    };

    FirebaseSync.prototype.getAuth = function() {
      var ref, slug;
      slug = (ref = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(this.url)) != null ? ref[1] : void 0;
      return typeof localStorage !== "undefined" && localStorage !== null ? localStorage["firebase:session::" + slug] : void 0;
    };

    FirebaseSync.prototype.key = function() {
      var last_slash;
      if (this.url === this.root()) {
        return null;
      }
      last_slash = this.url.lastIndexOf('/');
      return this.url.slice(last_slash + 1);
    };

    FirebaseSync.prototype.parent = function() {
      var last_slash, parent, path;
      path = this.url.replace(this.root(), '');
      last_slash = path.lastIndexOf('/');
      parent = path.slice(0, last_slash);
      if (parent === '') {
        return null;
      }
      return new FirebaseSync("" + (this.root()) + parent);
    };

    FirebaseSync.prototype.root = function() {
      var matches;
      matches = /(https:\/\/[a-z0-9-]+\.firebaseio\.com).*/.exec(this.url);
      return matches != null ? matches[1] : void 0;
    };

    FirebaseSync.prototype.toString = function() {
      return this.url;
    };

    FirebaseSync.prototype.once = function() {
      var arg, i, len, next, params, url;
      params = {};
      next = null;
      for (i = 0, len = arguments.length; i < len; i++) {
        arg = arguments[i];
        switch (typeof arg) {
          case 'object':
            params = arg;
            break;
          case 'function':
            next = arg;
        }
      }
      if (this.token) {
        params.auth = this.token;
      }
      url = this.url + ".json";
      if (next) {
        return get(url, params, next);
      } else {
        return get(url, params);
      }
    };

    return FirebaseSync;

  })();

}).call(this);
