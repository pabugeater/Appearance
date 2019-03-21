//
//  ViewController.m
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void) keyDown: (NSEvent*) theEvent { // suppress macOS alert beep when 'a' key pressed
} // end keyDown

- (void) viewDidLoad {

    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    delegate.macOSMode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"] isEqualToString:@"Dark"] ? @"dark" : @"";
    if (@available(macOS 10.14, *)) {
        [NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(themeChanged:) name:@"AppleInterfaceThemeChangedNotification" object: nil];
    }

} // end viewDidLoad

- (void)viewWillAppear {
    
    [super viewWillAppear];
    [[NSApplication sharedApplication] mainWindow].delegate = self;
    
    self.ap = [[Appearance alloc] initWithFile:@"Appearance.html" contentController:self.view andFrame:self.view.bounds];
    [self.view addSubview:self.ap];
    [self.ap addAppearanceConstraintsForView:self.view];

}  // end viewWillAppear

- (void)windowWillClose:(NSNotification *)notification {
    
    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    if ( delegate.hwc ) {
        [delegate.hwc close];
    }
    
} // end windowWillClose

-(void)themeChanged:(NSNotification *) notification {

    AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    NSApplication *app = [ NSApplication sharedApplication];
    NSString *currentAppearance = app.effectiveAppearance.name;
    if (@available(macOS 10.14, *)) {
        delegate.macOSMode = ( currentAppearance == NSAppearanceNameDarkAqua ? @"" : @"dark" );
    } else {
        // Fallback on earlier versions
    } // toggle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:delegate.macOSMode forKey:@"darkMode"];
    [defaults synchronize];
    NSString *darkModeHelp = [defaults objectForKey:@"darkModeHelp"];
    NSString *js = [NSString stringWithFormat:@"com_bigcatos_setExplicitAppearance ( \"%@\", \"%@\" ); ", delegate.macOSMode, darkModeHelp];
    [self.ap evaluateJavaScript:js completionHandler:self.ap.checkJsStatus];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
