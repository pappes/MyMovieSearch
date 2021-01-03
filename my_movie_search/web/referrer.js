function ref_alertMessage(text) {
    alert(text)
}


window.ref_logger = (flutter_value) => {
    window.console.log("js writing to console " + flutter_value);
 }

window.ref_override = (new_referrer) => {
    var referrer = window.document.referrer;
    window.state = {
        original_referrer: referrer
    };
    ref_logger( "initial value of  window.document.referrer is " +  window.document.referrer)
    try {
        // create new property on the document object to fake the referrer.  Does not work on some browsers.
        Object.defineProperty(document,
                              "referrer",
                              {get : function(){ return new_referrer; }});
        ref_logger( "current value of  window.document.referrer after defineProperty is " +  window.document.referrer);
    } catch {} finally {}

    try {
        // Remever any previous getter.  Raises exception if the getter does not exist.
        delete window.document.referrer;
        ref_logger( "current value of window.document.referrer after delete is " +  window.document.referrer);
    } catch {} finally {}
    try {
        // create a getter to fake the referrer.  Does not work on some browsers.
        window.document.__defineGetter__('referrer', function () { return 'new_referrer'; });
        //ref_logger( "current value of  window.document.referrer after __defineGetter__ is " +  window.document.referrer);
    } catch {} finally {}
    ref_logger( "final value of window.document.referrer is " +  window.document.referrer);
    
     window.state = {
        new_referrer: window.document.referrer
     };

    window.console.log("js writing to console referrer changed from " + referrer + " to " + new_referrer);
    return referrer; // Return old value so that it can be restored later.
}
