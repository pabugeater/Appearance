//
//  Appearance.m
//  GO-21
//
//  Created by Steve Lidie on 12/8/18.
//

#import "Appearance.h"

@implementation Appearance

- (id) initWithFile:(NSString *)file contentController:(id)contentController andFrame:(CGRect)frame {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *pref = [[WKPreferences alloc] init];
    pref.javaScriptEnabled = YES;
    configuration.preferences = pref;
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
        [self loadFileURL:[NSURL fileURLWithPath:path2HTML] allowingReadAccessToURL:baseURL];
        return self;
    } else {
        return nil;
    }
    
} // end initWithFileandFrame

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *darkMode = [defaults objectForKey:@"darkMode"];
    NSString *darkModeHelp = [defaults objectForKey:@"darkModeHelp"];
    if ( ! darkMode || [darkMode length] == 0 || [darkMode isEqualToString:@"null"] ) darkMode = @"";
    if ( ! darkModeHelp || [darkModeHelp length] == 0 || [darkModeHelp isEqualToString:@"null"] ) darkModeHelp = @"darkModeHelpNotDisplayed";
    NSString *js = [NSString stringWithFormat:@"com_bigcatos_setJsState( \"%@\", \"%@\" );com_bigcatos_doDarkMode( -2 ); com_bigcatos_removeHelpDiv();  ", darkMode, darkModeHelp];
    [self evaluateJavaScript:js completionHandler:nil];
    
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
    
    void(^getJsState)(NSString *, NSError *) = ^(NSString *rc, NSError *error) {
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

@end
