
// com_bigcatos_Appearance.js, Ver 1.fixme
//
// BigCatOs.com light / dark appearances.
//
// Element IDs:
//              'container'                    : div, named by EverWeb, containing the main content.
//
// session storge and NSUSerDefaults:
//              'com_bigcatos_darkMode'        : '' for light appearance, 'dark' for dark appearance.
//
// -1 macOS
// -2 iOS
// -3 BigCatOs main page
// -4 Solar Coaster, start in dark mode
// -5 Solar Coaster, start in light mode
//
// Specialized usage using evaluateJavaScript :
// com_bigcatos_setJsState( "dark" ); com_bigcatos_doDarkMode( -2 );

var customType = -1;

function com_bigcatos_doDarkMode(event) {

    if ( event < 0 ) { // initialization
        customType = event;
        if ( customType == -1 || customType == -4) {
        } else if ( customType == -2 || customType == -5 ) {
        } else if ( customType == -3 ) {
        } else {
            customType = -1;
        }
        if ( customType == -4 ) { // Solar Coaster starts with dark appearance, most of the time
            localStorage.setItem( "com_bigcatos_darkMode", 'dark' ); // save current appearance
        }

        // Listen for keystrokes.
        
        document.body.addEventListener( 'keydown',  com_bigcatos_doDarkMode, false );
        
    } // ifend initialization

    // Toggle appearance, possibly.
    
    var darkMode = localStorage.getItem("com_bigcatos_darkMode"); // current appearance
    if ( event != -1 && event != -2 && event != -3 && event != -4 && event != -5 ) {
        var type = event.type
        if ( type == 'keydown' ) {
            var  keynum = event.key;
            if ( keynum != "a" ) {
                return;
            }
        } else if ( type == 'click' ) {
        } else if ( type == 'keyup' ) {
        } else {
            return;
        }
        darkMode = darkMode == 'dark' ? '' : 'dark'; // new appearance
    } // ifend not initialization

    // Set container div to the proper appearance.
    
    var x = document.getElementsByClassName("container");
    var element = x[0];
    var transitionStyle = 'linear';
    var transition = "background 500ms " + transitionStyle + ", backgroundColor 500ms " + transitionStyle;
    element.style["transition"] = transition;
    document.body.style["transition"] = transition;
    if ( darkMode == "dark" ) {
        var dark = ( (customType == -4 || customType == -5) ? 'black' : "#404040" );
        element.style["background"] = dark;
        element.style["backgroundColor"] = dark;
        document.body.style.backgroundColor = dark;
        element.style["color"] = "white";
        com_bigcatos_colorLinks("#0098EE") ;
        var sc = document.getElementById( 'solarcoaster' );
        if ( dark == 'black' ) {
            sc.style["transition"] = transition;
            sc.style.color = '#03a6f3';
            document.getElementById('blue1').color = '#03a6f3';
            document.getElementById('blue2').color = '#03a6f3';
        }
    } else {
        var light = ( (customType == -4 || customType == -5) ? "#03a6f3" : "white" );
        element.style["background"] = light;
        element.style["backgroundColor"] = light;
        document.body.style.backgroundColor = light;
        element.style['color'] = ( (customType == -4 || customType == -5) ? 'black' : 'black' );
        com_bigcatos_colorLinks("#0000EE");
        var sc = document.getElementById( 'solarcoaster' );
        if ( light == '#03a6f3' ) {
            sc.style["transition"] = transition;
            sc.style.color = 'blue';
            document.getElementById('blue1').color = 'blue';
            document.getElementById('blue2').color = 'blue';
        }
    }
    localStorage.setItem( "com_bigcatos_darkMode", darkMode ); // save current appearance
    com_bigcatos_saveState(); // synch to NSUserDefaults

} // end com_bigcatos_doDarkMode

function com_bigcatos_colorLinks(hex) {

    var links = document.getElementsByTagName("a");
    for(var i=0;i<links.length;i++) {
        if(links[i].href) {
            links[i].style.color = hex;
        }
    }
    
} // end com_bigcatos_colorLinks

function com_bigcatos_getJsState () {
    
    // Return state of com_bigcatos_darkMode.
    
    var darkMode = localStorage.getItem("com_bigcatos_darkMode");
    return darkMode;
    
} // end com_bigcatos_getJsState

function com_bigcatos_saveState ( ) {
    
    // Send a saveState message to our Objective-C wrapper to update NSUserDefaults.
    
    try {
        window.webkit.messageHandlers.doAppearanceAction.postMessage("saveState");
    }
    finally {
        //Block of code to be executed regardless of the try / catch result
        return;
    }

} // end com_bigcatos_saveState

function com_bigcatos_setExplicitAppearance ( appearance ) { // appearance --> "dark" : ""

    var isMacLike = navigator.platform.match(/(Mac|iPhone|iPod|iPad)/i)?true:false;
    var isIOS = navigator.platform.match(/(iPhone|iPod|iPad)/i)?true:false;
    var type = ( isIOS ? -2 : -1 );
    var title = document.getElementsByTagName("title")[0].innerHTML;
    if ( title == "Solar Coaster Help" || title == "Solar Coaster" ) {
        type = ( appearance == "dark" ? -4 : -5 );
    }
    com_bigcatos_setJsState( appearance );
    
} // com_bigcatos_setExplicitAppearance

function com_bigcatos_setJsState ( darkMode ) {
    
    // Initialize session storage for doDarkMode().
    
    localStorage.setItem( "com_bigcatos_darkMode", darkMode );
    
} // end com_bigcatos_setJsState
