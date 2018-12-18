//
//  AppDelegate.m
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *infoPlist = [bundle infoDictionary];
    NSString *appVersion = (NSString *)[infoPlist objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuild = (NSString *)[infoPlist objectForKey:@"CFBundleVersion"];
    self.version = [NSString stringWithFormat:@"%@(%@)", appVersion, appBuild];
    NSLog(@"### Appearance version %@, macOSMode=%@.", self.version, self.macOSMode);
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (IBAction) doHelpAction:(id)sender {
    
    [self.hwc close];
    self.hwc = nil;
    self.hwc = [[HelpWindowController alloc] initWithWindowNibName:@"HelpWindowController"];
    NSWindow *w = self.hwc.window; // referencing the window instantiates and displays it
    NSView *v = w.contentView;
    self.ap = [[Appearance alloc] initWithFile:@"Appearance.html" contentController:self.hwc andFrame:v.frame];
    [v addSubview:self.ap];
    [self.ap addAppearanceConstraintsForView:v];
    [w makeKeyAndOrderFront:self];
    
} // end doHelpAction

- (IBAction) doExportAction:(id)sender {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *sourcePath = [bundle pathForResource:@"Appearance" ofType:@"sh"];
    if (sourcePath == nil) {
        NSLog(@"Appearance.sh was not found");
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy.MM.dd-HH.mm.ss";
    NSString *nowStr = [df stringFromDate:now];
    NSError *err;
    NSSavePanel *save = [NSSavePanel savePanel];
    save.nameFieldStringValue = [NSString stringWithFormat:@"Appearance-%@", nowStr];
    NSInteger result = [save runModal];
    if ( result == NSModalResponseOK ) {
        NSURL *outURL = [save URL];
        NSString *outStr = [outURL absoluteString];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (! [fileManager createDirectoryAtURL:outURL withIntermediateDirectories:YES attributes:nil error:&err] ) {
            NSLog(@"failed to create folder %@, error=%@", outStr, err.localizedDescription);
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:[NSString stringWithFormat:@"Failed to create '%@'.", outStr]];
            [alert setInformativeText:(err.localizedDescription ? err.localizedDescription : @"Unkown error." )];
            [alert setAlertStyle:NSAlertStyleWarning];
            [alert runModal];
        } else {
            NSString *srcFolder = [sourcePath stringByDeletingLastPathComponent];
            NSString *cmd = [NSString stringWithFormat:@"%@/Appearance.sh %@ %@ '%@' %@", srcFolder, srcFolder, outURL.path, self.version, @"Appearance.sh Appearance.txt Appearance.h Appearance.m Appearance.html com_bigcatos_Appearance.js"];
            NSInteger stat = system ( [cmd UTF8String] );
            if ( stat == 0 ) {
                NSLog(@"Export succeeded.");
            } else {
                NSLog( @"Export failed.");
                NSAlert *alert = [[NSAlert alloc] init];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:[NSString stringWithFormat:@"Failed to export to '%@'.", outStr]];
                [alert setInformativeText:[NSString stringWithFormat:@"system rc=%ld", stat]];
                [alert setAlertStyle:NSAlertStyleWarning];
                [alert runModal];
            }
       }
    }

} // end doHelpAction

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem {
    
    SEL theAction = [anItem action];
    if ( theAction == @selector(doHelpAction:)  ||  theAction == @selector(doExportAction:) ) {
        return YES;
    } else {
        return NO;
    }
    
} // end validateUserInterfaceItem

@end
