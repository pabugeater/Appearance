
// BCOWebView.js, Ver 1.fixme
//

// Example: send JS message to Objective-C wrapper BCOWebView.m didReceiveScriptMessage():

window.onload = function () {
    
    //BCOWebViewSendJSMessage( 'Frog!' );
    
} // end onload

function BCOWebViewSendJSMessage ( msg ) {
    
    // Send a message to our Objective-C wrapper.
    
    try {
        window.webkit.messageHandlers.BCOWebViewSendJSMessage.postMessage( msg );
    }
    finally {
        //Block of code to be executed regardless of the try / catch result
        return;
    }
    
} // end BCOWebViewLogMessage

