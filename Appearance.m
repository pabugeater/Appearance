//
//  Appearance.m, Ver 1.fixme
//
//  Created by Steve Lidie on 12/8/18.
//

#import "Appearance.h"

@interface NSURL (parameterDictionaryForMailTo)
    
- (NSDictionary *) parameterDictionaryForMailTo;
    
@end

@implementation NSURL (parameterDictionaryForMailTo)
    
- (NSDictionary *) parameterDictionaryForMailTo {
    NSMutableDictionary *parameterDictionary = [[NSMutableDictionary alloc] init];
    NSString *mailtoParameterString = [[self absoluteString] substringFromIndex:[@"mailto:" length]];
    NSUInteger questionMarkLocation = [mailtoParameterString rangeOfString:@"?"].location;
    if (questionMarkLocation != NSNotFound) {
        [parameterDictionary setObject:[mailtoParameterString substringToIndex:questionMarkLocation] forKey:@"recipient"];
        NSString *parameterString = [mailtoParameterString substringFromIndex:questionMarkLocation + 1];
        NSArray *keyValuePairs = [parameterString componentsSeparatedByString:@"&"];
        for (NSString *queryString in keyValuePairs) {
            NSArray *keyValuePair = [queryString componentsSeparatedByString:@"="];
            if (keyValuePair.count == 2)
            [parameterDictionary setObject:[[keyValuePair objectAtIndex:1] stringByRemovingPercentEncoding] forKey:[[keyValuePair objectAtIndex:0] stringByRemovingPercentEncoding]];
        }
    }
    else {
        [parameterDictionary setObject:mailtoParameterString forKey:@"recipient"];
    }
    
    return [parameterDictionary copy];
}
    
@end

@implementation Appearance

- (id) initWithFile:(NSString *)file contentController:(id)contentController andFrame:(CGRect)frame {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *pref = [[WKPreferences alloc] init];
    pref.javaScriptEnabled = YES;
    configuration.preferences = pref;
#ifdef kAppearanceX
    if ( @available(macOS 12.0, *) ) {
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }
#else
    if ( @available(iOS 10.0, *) ) {
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }
#endif
#ifndef kAppearanceX
    configuration.allowsInlineMediaPlayback = YES;
#endif
    [configuration.userContentController addScriptMessageHandler:self name:@"doAppearanceAction"];
    if ( self = [super initWithFrame:frame configuration:configuration] ) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MyCaches"];
        path = [path stringByAppendingPathComponent:file];
        if ( [[NSFileManager defaultManager] isReadableFileAtPath:path] == NO ) {
            NSString *fileName = [file stringByDeletingPathExtension];
            NSString *ext = [file pathExtension];
            path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        }
        NSString *path2HTML = path;
        if ( ! path2HTML ) {
            NSLog(@"Appearance HTML file not found: %@", file);
            return nil;
        }
        NSString *u1 = [path2HTML stringByDeletingLastPathComponent];
        NSURL *baseURL = [NSURL fileURLWithPath:u1];
        self.UIDelegate = self;
        self.navigationDelegate = self;
        self.contentController = contentController; // UIViewController or NSWindow (from NSWindowController or NSView)
        self.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 9.0, *)) {
            [self loadFileURL:[NSURL fileURLWithPath:path2HTML] allowingReadAccessToURL:baseURL];
        } else {
            [self loadHTMLString:[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path2HTML] encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
        }
        self.checkJsStatus = ^(NSString *rc, NSError *error) {
            if ( error ) {
                NSLog(@"checkJsStatus :  rc=%@, error=%@", rc, error);
            }
        };
        return self;
    } else {
        return nil;
    }
    
} // end initWithFileandFrame

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *darkMode;
#ifdef kAppearanceX
    if (@available(macOS 10.14, *)) {
        darkMode = [NSApplication sharedApplication].effectiveAppearance.name;
        darkMode = ( darkMode == NSAppearanceNameDarkAqua ? @"dark" : @"" );
        [defaults setObject:darkMode forKey:@"darkMode"];
    } else {
        darkMode = [defaults objectForKey:@"darkMode"];
        if ( ! darkMode || [darkMode length] == 0 || [darkMode isEqualToString:@"null"] ) darkMode = @"";
    }
#else
    darkMode = [defaults objectForKey:@"darkMode"];
    if ( ! darkMode || [darkMode length] == 0 || [darkMode isEqualToString:@"null"] ) darkMode = @"";
#endif
    NSString *darkModeHelp = [defaults objectForKey:@"darkModeHelp"];
    if ( ! darkModeHelp || [darkModeHelp length] == 0 || [darkModeHelp isEqualToString:@"null"]|| [darkModeHelp isEqualToString:@"undefined"] ) darkModeHelp = @"darkModeHelpNotDisplayed";
    NSString *js = [NSString stringWithFormat:@"com_bigcatos_setExplicitAppearance( \"%@\", \"%@\" ); ", darkMode, darkModeHelp];
    [self evaluateJavaScript:js completionHandler:self.checkJsStatus];
    
} // end didFinishNavigation

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavgication");
}

- (void) addAppearanceConstraintsForView:(id)containerView {

    Appearance *ap = self;
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ap]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ap)]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[ap]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(ap)]];

} // end addAppearanceConstraintsToView

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *msg = (NSString *)message.body;
    if ( [msg isEqualToString:@"saveState"] ) {
        [self saveState];
    } else {
        NSLog(@" unknown Appearance message=%@", msg);
    }
    
} // end didReceiveScriptMessage

- (void) saveState {
    
    // Fetch the JavaScript session variables and update NSUserDefaults to match.
    
    void(^getJsState)(NSString *, NSError *) = ^(NSString *rc, NSError *error) {
        if ( error ) {
            NSLog(@"getJsState :  rc=%@, error=%@", rc, error);
        }
        NSString *darkMode, *darkModeHelp;
        NSArray *toks = [rc componentsSeparatedByString:@"|"];
        darkMode = toks[0];
        darkModeHelp = toks[1];
        if ( ! darkMode || [darkMode length] == 0 || [darkMode isEqualToString:@"null"] ) darkMode = @"";
        if ( ! darkModeHelp || [darkModeHelp length] == 0 || [darkModeHelp isEqualToString:@"null"] ) darkModeHelp = @"darkModeHelpNotDisplayed";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:darkMode forKey:@"darkMode"];
        [defaults setObject:darkModeHelp forKey:@"darkModeHelp"];
        [defaults synchronize];
    };
    
    NSString *js = @"com_bigcatos_getJsState()";
    [self evaluateJavaScript:js completionHandler:(void (^)(id, NSError *error))getJsState ];

} // end saveState

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))WVcompletionHandler {
    
#ifndef kAppearanceX
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Appearance", nil) message: message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { WVcompletionHandler(); }];
    [alert addAction:okAction];
    UIViewController *vc = self.contentController;
    if ( vc.presentedViewController == nil ) {
        [vc                         presentViewController:alert animated:YES completion:nil];
    } else {
        [vc.presentedViewController presentViewController:alert animated:YES completion:nil];
    }
#else
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    NSWindowController *wc = self.contentController;
    [alert beginSheetModalForWindow:wc.window completionHandler:^(NSModalResponse returnCode) {
        WVcompletionHandler();
    }];
#endif
    
} // end runJavaScriptAlertPanelWithMessage
    
#pragma mark -
#pragma mark WKWebView and MFMailComposeViewController delegate methods for parameterDictionaryForMailTo category
    
#ifndef kAppearanceX

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void  (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ( [navigationAction.request.URL.scheme isEqualToString:@"mailto"] && [MFMailComposeViewController canSendMail] ) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        if ( mailController == nil ) return;
        NSDictionary *parameterDictionary = [navigationAction.request.URL parameterDictionaryForMailTo];
        mailController.mailComposeDelegate = self;
        NSString *subject = [parameterDictionary objectForKey:@"subject"];
        NSArray *recipients = [[NSArray alloc] initWithArray:[ [parameterDictionary objectForKey:@"recipient"] componentsSeparatedByString:@","]];
        [mailController setSubject:subject];
        [mailController setToRecipients:recipients];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.contentController presentViewController:mailController animated:YES completion:nil];
        });
    }
    decisionHandler( WKNavigationActionPolicyAllow );
    
} //end decidePolicyForNavigationAction
    
- (void) mailComposeController: (MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled: {
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case MFMailComposeResultSaved: {
            [controller dismissViewControllerAnimated:NO completion:nil];
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Mail Saved" message:@"Message saved in your Drafts folder." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // Nil.
            }];
            [ac addAction:ok];
            [self.contentController presentViewController:ac animated:YES completion:nil];
           break;
        }
        case MFMailComposeResultSent: {
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case MFMailComposeResultFailed: {
            [controller dismissViewControllerAnimated:NO completion:nil];
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Mail Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // Nil.
            }];
            [ac addAction:ok];
            [self.contentController presentViewController:ac animated:YES completion:nil];
            break;
        }
    } // end switch
    
} // end didFinishWithResult
    
#endif

@end
