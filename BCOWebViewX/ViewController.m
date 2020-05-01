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
    
    self.bwv = [[BCOWebView alloc] initWithFile:@"BCOWebView.html" contentController:self.view andFrame:self.view.bounds];
    [self.view addSubview:self.bwv];
    [self.bwv addConstraintsForView:self.view];

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
