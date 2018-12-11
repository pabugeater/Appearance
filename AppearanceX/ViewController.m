//
//  ViewController.m
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewWillAppear {
    
    [super viewWillAppear];
    [[NSApplication sharedApplication] mainWindow].delegate = self;
    
    self.ap = [[Appearance alloc] initWithFile:@"Appearance.html" owningViewController:self.view.window andFrame:self.view.bounds];
    [self.view addSubview:self.ap];
    [self.ap addAppearanceConstraintsForView:self.view];

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
