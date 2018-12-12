//
//  AppDelegate.m
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (IBAction) doHelpAction:(id)sender {
    
    [self.hwc close];
    self.hwc = nil;
    self.hwc = [[HelpWindowController alloc] initWithWindowNibName:@"HelpWindowController"];
    NSWindow *w = self.hwc.window; // referencing the window instantiates and displays it
    NSView *v = w.contentView;
    self.ap = [[Appearance alloc] initWithFile:@"Appearance.html" owningViewController:w andFrame:v.frame];
    [v addSubview:self.ap];
    [self.ap addAppearanceConstraintsForView:v];
    [w makeKeyAndOrderFront:self];
    
} // end doHelpAction

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem {
    
    SEL theAction = [anItem action];
    if ( theAction == @selector(doHelpAction:) ) {
        return YES;
    } else {
        return NO;
    }
    
} // end validateUserInterfaceItem

@end
