//
//  ViewController.m
//  BCOWebViewX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void) keyDown: (NSEvent*) theEvent { // suppress macOS alert beep when 'a' key pressed
} // end keyDown

- (void)viewWillAppear {
    
    [super viewWillAppear];
    [[NSApplication sharedApplication] mainWindow].delegate = self;
    
    self.bwv = [[BCOWebView alloc] initWithFile:@"BCOWebView.html"
                              contentController:self andFrame:self.view.bounds
                           scriptMessageHandler:[[ScriptMessageHandler alloc] init].scriptMessageHandler
                              completionHandler:^(id __nullable result, NSError *__nullable error) {
            NSLog(@"BCOWebViewX ViewController in completion handler, result '%@'", result);
            if ( ! error ) {
                [self.view addSubview:self.bwv];
                [self.bwv addConstraintsForView:self.view];
            } else {
                NSLog(@"BCOWebView initWithFile error: %@", error);
            }
        }
    ];

}  // end viewWillAppear

- (void)windowWillClose:(NSNotification *)notification {
    
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    if ( delegate.hwc ) {
        [delegate.hwc close];
    }
    
} // end windowWillClose

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
