//
//  BCOWebView.m, Ver 1.fixme
//
//  Created by Steve Lidie on 12/8/18.
//

#import "BCOWebView.h"

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

@implementation BCOWebView

- (id) initWithFile:(NSString *)file contentController:(id)contentController andFrame:(CGRect)frame completionHandler:(void (^)(id, NSError *error))completionHandler {
    
    self.initCompletionHandler = completionHandler;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *pref = [[WKPreferences alloc] init];
    pref.javaScriptEnabled = YES;
    configuration.preferences = pref;
#ifdef kBCOWebViewX
    if ( @available(macOS 12.0, *) ) {
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }
#else
    if ( @available(iOS 10.0, *) ) {
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    }
#endif
#ifndef kBCOWebViewX
    configuration.allowsInlineMediaPlayback = YES;
#endif
    [configuration.userContentController addScriptMessageHandler:self name:@"BCOWebViewSendJSMessage"];
    if ( self = [super initWithFrame:frame configuration:configuration] ) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MyCaches"];
        path = [path stringByAppendingPathComponent:file];
        if ( [[NSFileManager defaultManager] isReadableFileAtPath:path] == NO ) {
            NSString *fileName = [file stringByDeletingPathExtension];
            NSString *ext = [file pathExtension];
            path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        }
        self.UIDelegate = self;
        self.navigationDelegate = self;
        self.contentController = contentController; // UIViewController or NSWindow (from NSWindowController or NSView)
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSString *path2HTML = path;
        if ( ! path2HTML ) {
            NSLog(@"BCOWebView HTML file not found: %@", file);
            return self;
        }
        NSString *u1 = [path2HTML stringByDeletingLastPathComponent];
        NSURL *baseURL = [NSURL fileURLWithPath:u1];
        if (@available(iOS 9.0, *)) {
            [self loadFileURL:[NSURL fileURLWithPath:path2HTML] allowingReadAccessToURL:baseURL];
        } else {
            [self loadHTMLString:[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path2HTML] encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
        }
        return self;
    } else {
        return nil;
    }
    
} // end initWithFileandFrame

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if ( self.initCompletionHandler) self.initCompletionHandler( @"BCOWebView initWithFile did load content.", nil );
    
} // end didFinishNavigation

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    if ( self.initCompletionHandler) self.initCompletionHandler( @"BCOWebView initWithFile failed to load content.", error );
    
} // end didFailNavigation

- (void) addConstraintsForView:(id)containerView {

    BCOWebView *bwv = self;
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bwv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bwv)]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bwv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bwv)]];

} // end addConstraintsToView

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *msg = (NSString *)message.body;
    NSLog(@" Unknown BCOWebViewSendJSMessage '%@'.", msg); // stub
    
} // end didReceiveScriptMessage

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))WVcompletionHandler {
    
#ifndef kBCOWebViewX
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"BCOWebView", nil) message: message preferredStyle: UIAlertControllerStyleAlert];
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
    [alert runModal];
    WVcompletionHandler();
#endif
    
} // end runJavaScriptAlertPanelWithMessage
    
#pragma mark -
#pragma mark WKWebView and MFMailComposeViewController delegate methods for parameterDictionaryForMailTo category
    
#ifndef kBCOWebViewX

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
