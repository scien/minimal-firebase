
/*
 *
 * Using Firebase Synchronously
 *
 */

(function() {
  window.FirebaseSync = (function() {
    function FirebaseSync(url) {
      this.url = url.replace(/\/$/, '');
      if (!this.root()) {
        throw new Error("Invalid firebase url: " + url);
      }
    }

    FirebaseSync.prototype.child = function(path) {
      path = path.split(/[\/\.]/g);
      path = path.join('/');
      return new FirebaseSync("" + this.url + "/" + path);
    };

    FirebaseSync.prototype.root = function() {
      var matches;
      matches = /(https:\/\/[a-z0-9-]+\.firebaseio\.com).*/.exec(this.url);
      return matches != null ? matches[1] : void 0;
    };

    FirebaseSync.prototype.toString = function() {
      return this.url;
    };

    return FirebaseSync;

  })();

}).call(this);
