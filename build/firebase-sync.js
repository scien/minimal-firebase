
/*
 *
 * Using Firebase Synchronously
 *
 */

(function() {
  window.FirebaseSync = (function() {
    function FirebaseSync(url) {
      this.url = url.replace(/\/$/, '');
    }

    FirebaseSync.prototype.child = function(path) {
      path = path.split(/[\/\.]/g);
      path = path.join('/');
      return new FirebaseSync("" + this.url + "/" + path);
    };

    FirebaseSync.prototype.toString = function() {
      return this.url;
    };

    return FirebaseSync;

  })();

}).call(this);
