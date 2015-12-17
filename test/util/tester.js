// Generated by CoffeeScript 1.9.3
(function() {
  var t;

  t = {};

  t.errors = 0;

  t.error = function(msg) {
    t.errors++;
    console.error("ERROR: " + msg);
    if (process.env.HALT != null) {
      return process.exit(1);
    }
  };

  t.tests = [];

  t.test = function(description, cb) {
    return t.tests.push({
      description: description,
      cb: cb
    });
  };

  t.run = function() {
    var i, next;
    t.done();
    i = 0;
    next = function() {
      if (t.tests[++i] != null) {
        console.log("\n>>> RUNNING TEST #" + i + " '" + t.tests[i].description + "'");
        return t.tests[i].cb(next);
      }
    };
    return t.tests[i].cb(next);
  };

  t.done = function() {
    return t.test('tests done', function(next) {
      if (!t.errors) {
        console.log("\nOK\n");
        return process.exit(0);
      } else {
        console.log("\nERROR: some tests failed\n");
        return process.exit(1);
      }
    });
  };

  module.exports = t;

}).call(this);