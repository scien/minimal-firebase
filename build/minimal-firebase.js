
/*
 *
 * Using Firebase Synchronously
 *
 */

(function() {
  var firebase, get;

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

  firebase = (function() {
    firebase.prototype.authAnonymously = function(next) {
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

    firebase.prototype.authWithPassword = function(email, password, next) {
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

    firebase.prototype.authWithCustomToken = function(token) {
      return this.token = token;
    };

    function firebase(url) {
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

    firebase.prototype.child = function(path) {
      path = path.split(/[\/\.]/g);
      path = path.join('/');
      return new MinimalFirebase(this.url + "/" + path);
    };

    firebase.prototype.createUser = function(email, password, next) {
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

    firebase.prototype.getAuth = function() {
      var ref, slug;
      slug = (ref = /https:\/\/([a-z0-9-]+)\.firebaseio\.com.*/.exec(this.url)) != null ? ref[1] : void 0;
      return typeof localStorage !== "undefined" && localStorage !== null ? localStorage["firebase:session::" + slug] : void 0;
    };

    firebase.prototype.key = function() {
      var last_slash;
      if (this.url === this.root()) {
        return null;
      }
      last_slash = this.url.lastIndexOf('/');
      return this.url.slice(last_slash + 1);
    };

    firebase.prototype.parent = function() {
      var last_slash, parent, path;
      path = this.url.replace(this.root(), '');
      last_slash = path.lastIndexOf('/');
      parent = path.slice(0, last_slash);
      if (parent === '') {
        return null;
      }
      return new MinimalFirebase("" + (this.root()) + parent);
    };

    firebase.prototype.root = function() {
      var matches;
      matches = /(https:\/\/[a-z0-9-]+\.firebaseio\.com).*/.exec(this.url);
      return matches != null ? matches[1] : void 0;
    };

    firebase.prototype.toString = function() {
      return this.url;
    };

    firebase.prototype.once = function() {
      var arg, filter, filters, i, j, len, len1, next, params, url;
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
      filters = ['orderBy', 'equalTo', 'startAt', 'endAt'];
      for (j = 0, len1 = filters.length; j < len1; j++) {
        filter = filters[j];
        if (typeof params[filter] === 'string') {
          params[filter] = "\"" + params[filter] + "\"";
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

    return firebase;

  })();

  window.MinimalFirebase = firebase;

  module.exports = firebase;

}).call(this);
