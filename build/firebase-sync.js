
/*
 *
 * Using Firebase Synchronously
 *
 */

(function() {
  window.FirebaseSync = (function() {
    function FirebaseSync() {}

    return FirebaseSync;

  })();

  window.test = function() {
    console.log('in window.test');
    return 'hello world';
  };

}).call(this);
