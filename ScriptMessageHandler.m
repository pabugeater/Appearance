//
//  ScriptMessageHandler.m
//  BCOWebView
//
//  Created by Steve Lidie on 5/17/20.
//  Copyright © 2020 Steve Lidie. All rights reserved.
//

#import "ScriptMessageHandler.h"

@implementation ScriptMessageHandler

- (id) init {
    
    if ( self = [super init] ) { // complex way of defining a scriptMessage handler, done soley to eliminate redundant definitions
        
        self.scriptMessageHandler = ^(WKUserContentController *__nonnull userContentController, WKScriptMessage *__nonnull scriptMessage) {
            
            // Allowed message body types are NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull.
            
            id msgClass = [scriptMessage.body class];
            NSString *out = [NSString stringWithFormat:@"Custom script message handler received message of class %@:", msgClass];
            if ( [scriptMessage.body isKindOfClass:[NSArray class]] ) {
                NSArray *messageItems = scriptMessage.body;
                out = [NSString stringWithFormat:@"%@\n", out];
                for ( NSInteger i = 0; i < [messageItems count]; i++ ) {
                    NSString *className = NSStringFromClass( [messageItems[i] class] );
                    out = [NSString stringWithFormat:@"%@\nIndex %ld, class %@: %@", out, i, className, messageItems[i]];
                }
            } else {
                out = [NSString stringWithFormat:@"%@\n\n%@", out, scriptMessage.body];
            }

            NSString *name = [[scriptMessage.frameInfo.request.URL lastPathComponent] stringByDeletingPathExtension];
#ifndef kBCOWebViewX
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(name, nil) message:out preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
#else
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:name];
            [alert setInformativeText:out];
            [alert addButtonWithTitle:@"OK"];
            [alert runModal];
#endif
        };
    }
    return self; 

} // end init

@end
