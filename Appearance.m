//
//  Appearance.m
//  GO-21
//
//  Created by Steve Lidie on 12/8/18.
//

#import "Appearance.h"

@implementation Appearance

- (id) initWithFile:(NSString *)file owningViewController:(UIViewController *)viewController andFrame:(CGRect)frame {
    
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
            NSLog(@"DRAT########################################################=%@", file);
            NSString *fileName = [file stringByDeletingPathExtension];
            NSString *ext = [file pathExtension];
            path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        }
        NSString *path2HTML = path;
        NSString *u1 = [path2HTML stringByDeletingLastPathComponent];
        NSURL *baseURL = [NSURL fileURLWithPath:u1];
        self.UIDelegate = self;
        self.navigationDelegate = self;
        self.viewController = viewController;
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
    if ( ! darkMode || [darkMode length] == 0 || [darkMode isEqualToString:@"null"] ) darkMode = @" ";
    if ( ! darkModeHelp || [darkModeHelp length] == 0 || [darkModeHelp isEqualToString:@"null"] ) darkModeHelp = @"darkModeHelpNotDisplayed";
    NSString *js = [NSString stringWithFormat:@"com_bigcatos_setJsState( \"%@\", \"%@\" );com_bigcatos_doDarkMode( -2 ); com_bigcatos_removeHelpDiv();  ", darkMode, darkModeHelp];
    [self evaluateJavaScript:js completionHandler:nil];
    
} // end didFinishNavigation

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavgication");
}

- (void) addAppearanceConstraintsForView:(UIView *)containerView {
    
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
        NSLog(@"saveState darkMode=%@, darkModeHelp=%@", darkMode, darkModeHelp);
        if ( ! darkMode || [darkMode length] == 0 || [darkMode isEqualToString:@"null"] ) darkMode = @" ";
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Appearance", nil) message: message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { WVcompletionHandler(); }];
    [alert addAction:okAction];
    if ( self.viewController.presentedViewController == nil ) {
        [self.viewController presentViewController:alert animated:YES completion:nil];
    } else {
        [self.viewController.presentedViewController presentViewController:alert animated:YES completion:nil];
    }
    
} // end runJavaScriptAlertPanelWithMessage

@end
