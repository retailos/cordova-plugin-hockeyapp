var exec = require("cordova/exec");

/**
 * This is a global variable called exposed by cordova
 */    
var HockeyApp = function(){};

HockeyApp.prototype.forcecrash = function(success, error) {
  exec(success, error, "HockeyAppPlugin", "forcecrash", []);
};

HockeyApp.prototype.feedback = function(success,error){
  exec(success,error,"HockeyAppPlugin","feedback",[]);
}

module.exports = new HockeyApp();
