
// Appearance.html, Ver 1.fixme
//
// BigCatOs.com light / dark appearances.
//
// Element IDs:
//              'com_bigcatos_darkModeHelpDiv' : div containing the Appearance Help information.
//              'container'                    : div, named by EverWeb, containing the main content.
//
// session storge and NSUSerDefaults:
//              'com_bigcatos_darkMode'        : '' for light appearance, 'dark' for dark appearance.
//              'com_bigcatos_darkModeHelp'    : '' or if Help displayed 'DarkModeHelpDisplayed'.
//
// Inject the user Appearance Help div.
//
// -1 macOS
// -2 iOS
// -3 BigCatOs main page
// -4 Solar Coaster, start in dark mode
// -5 Solar Coaster, start in light mode
//
// Nominal usage from <body> footer :
// <script>com_bigcatos_doDarkMode( -2 );</script>
//
// Specialized usage using evaluateJavaScript :
// com_bigcatos_setJsState( "dark", "DarkModeHelpDisplayed" ); com_bigcatos_doDarkMode( -2 ); com_bigcatos_removeHelpDiv();

var customType = -1;

function com_bigcatos_doDarkMode(event) {

    if (event < 0 ) { // initialization
        customType = event;
        var block_to_insert = document.createElement( 'div' );
        if ( customType == -1 || customType == -4) {
            block_to_insert.innerHTML = '<p>&nbsp<center><span style=" border: 4px solid #EA98EE; border-radius: 10px; padding-left:20px; padding-right:20px; padding-top:10px; padding-bottom:10px;  ">Click App icon or type <b><i>a</i></b> to toggle <b>Light / Dark</b> appearance</span></center> <p>&nbsp' ;
        } else if ( customType == -2 || customType == -5 ) {
            block_to_insert.innerHTML = '<p>&nbsp<center><div style=" border: 2px solid #EA98EE; border-radius: 10px; padding-left:2px; padding-right:2px; padding-top:2px; padding-bottom:2px;  ">Touch App icon to toggle<br><b>Light / Dark</b> appearance</div></center> <p>&nbsp' ;
        } else if ( customType == -3 ) {
            block_to_insert.innerHTML = '<p>&nbsp<center><div style=" border: 2px solid #EA98EE; border-radius: 10px; padding-left:2px; padding-right:2px; padding-top:2px; padding-bottom:2px;  ">Touch Star or type <b><i>a</i></b><br>to toggle<br><b>Light / Dark</b> appearance</div></center> <p>&nbsp' ;
        } else {
            block_to_insert.innerHTML = '<p>&nbsp<center><span style=" border: 2px solid #EA98EE; border-radius: 10px; padding-left:2px; padding-right:2px; padding-top:2px; padding-bottom:2px;  ">Unknown App Type=' + customType + '</span></center> <p>&nbsp' ;
            customType = -1;
        }
        var container_block = document.getElementById( 'com_bigcatos_darkModeHelpDiv' );
        container_block.appendChild( block_to_insert );
        
        // Listen for keystrokes.
        
        document.body.addEventListener( 'keydown',  com_bigcatos_doDarkMode, false );
        
        // Setup Help to toggle Dark Mode and instruct the user. Initially opacity = 0, set to one for 10 seconds
        // on page load, but only once. Hide Dark Mode help info after its initial showing by un-injecting the div.
        
        var darkModeHelp = sessionStorage.getItem("com_bigcatos_darkModeHelp");
        var to = 10000;
        if ( darkModeHelp == "DarkModeHelpDisplayed" ) {
            to = 0;
        }
        
        // On window load if timeout 'to' is > 0 make the darkModeHelp div visible, then set a timer to hide it
        // after 'to' seconds. If timeout 'to' == 0 simply remove the darkModeHelp div.
        
        window.onload = function () {
            var help = document.getElementById( 'com_bigcatos_darkModeHelpDiv' );
            if ( to != 0 ) {
                help.style.opacity = 1.0;
                setTimeout(
                           function() {
                                help.style.opacity = 0.0;
                                sessionStorage.setItem( "com_bigcatos_darkModeHelp", "DarkModeHelpDisplayed" );
                                com_bigcatos_saveState(); // synch to NSUserDefaults
                                while( help.firstChild ) {
                                    help.removeChild( help.firstChild );
                                }
                            }
                            , to );
            } else {
                while( help.firstChild ) {
                    help.removeChild( help.firstChild );
                }
            }
        } // end onload
        
        if ( customType == -4 ) { // Solar Coaster starts with dark appearance, most of the time
            sessionStorage.setItem( "com_bigcatos_darkMode", 'dark' ); // save current appearance
        }
    } // ifend initialization

    // Toggle appearance, possibly.
    
    var darkMode = sessionStorage.getItem("com_bigcatos_darkMode"); // current appearance
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
    if ( darkMode == "dark" ) {
        var dark = ( (customType == -4 || customType == -5) ? 'black' : "#404040" );
        element.style["background"] = dark;
        element.style["backgroundColor"] = dark;
        document.body.style.backgroundColor = dark;
        element.style["color"] = "white";
        com_bigcatos_colorLinks("#0098EE") ;
        var sc = document.getElementById( 'solarcoaster' );
        if ( dark == 'black' ) {
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
            sc.style.color = 'blue';
            document.getElementById('blue1').color = 'blue';
            document.getElementById('blue2').color = 'blue';
        }
    }
    sessionStorage.setItem( "com_bigcatos_darkMode", darkMode ); // save current appearance
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
    
    // Return state of com_bigcatos_darkMode and com_bigcatos_darkModeHelp.
    
    var darkMode = sessionStorage.getItem("com_bigcatos_darkMode");
    var darkModeHelp = sessionStorage.getItem("com_bigcatos_darkModeHelp");
    return darkMode + '|' + darkModeHelp;
    
} // end com_bigcatos_getJsState

function com_bigcatos_removeHelpDiv ( ) {
    
    window.onload();
    
} // end com_bigcatos_removeHelperDiv

function com_bigcatos_saveState ( ) {
    
    // Send a saveState message to our Objective-C wrapper to update NSUserDefaults.
    
    try {
        window.webkit.messageHandlers.doAppearanceAction.postMessage("saveState");
    }
    finally {
        //Block of code to be executed regardless of the try / catch result
    }

} // end com_bigcatos_saveState

function com_bigcatos_setExplicitAppearance ( appearance, darkModeHelp ) { // appearance --> "dark" : ""

    var isMacLike = navigator.platform.match(/(Mac|iPhone|iPod|iPad)/i)?true:false;
    var isIOS = navigator.platform.match(/(iPhone|iPod|iPad)/i)?true:false;
    var type = ( isIOS ? -2 : -1 );
    var title = document.getElementsByTagName("title")[0].innerHTML;
    if ( title == "Solar Coaster Help" || title == "Solar Coaster" ) {
        type = ( appearance == "dark" ? -4 : -5 );
    }
    com_bigcatos_setJsState( appearance, darkModeHelp );
    com_bigcatos_doDarkMode( type );
    com_bigcatos_removeHelpDiv();
    
} // com_bigcatos_setExplicitAppearance

function com_bigcatos_setJsState ( darkMode, darkModeHelp ) {
    
    // Initialize session storage for doDarkMode().
    
    sessionStorage.setItem( "com_bigcatos_darkMode", darkMode );
    sessionStorage.setItem( "com_bigcatos_darkModeHelp", darkModeHelp);
    
} // end com_bigcatos_setJsState
