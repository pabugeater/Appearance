//
//  AppDelegate.m
//  BCOWebViewX
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
    NSLog(@"### BCOWebViewX version %@.", self.version);
    NSMenu *rootMenu = [NSApp mainMenu];
    NSMenuItem *mi = [rootMenu itemWithTitle:@"BCOWebViewX"];
    NSMenu *subMenu = [mi submenu];
    [subMenu removeItemAtIndex:2]; // remove Preferences...
    mi = [rootMenu itemWithTitle:@"File"];
    subMenu = [mi submenu];
    [subMenu removeItemAtIndex:2]; // remove Print
    [subMenu removeItemAtIndex:2]; // remover Page Setup
    [rootMenu removeItemAtIndex:2]; // remove Edit
    
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
    self.bwv = [[BCOWebView alloc] initWithFile:@"BCOWebView.html" contentController:self.hwc andFrame:v.frame];
    [v addSubview:self.bwv];
    [self.bwv addConstraintsForView:v];
    [w makeKeyAndOrderFront:self];
    
} // end doHelpAction

- (IBAction) doExportAction:(id)sender {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *sourcePath = [bundle pathForResource:@"BCOWebView" ofType:@"sh"];
    if (sourcePath == nil) {
        NSLog(@"BCOWebView.sh was not found");
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy.MM.dd-HH.mm.ss";
    NSString *nowStr = [df stringFromDate:now];
    NSError *err;
    NSSavePanel *save = [NSSavePanel savePanel];
    save.nameFieldStringValue = [NSString stringWithFormat:@"BCOWebView-%@-%@", self.version, nowStr];
    save.title = @"Export BCOWebView Bundle";
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
            NSString *escapedPath = [outURL.path stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
                      escapedPath = [escapedPath stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
            NSString *cmd = [NSString stringWithFormat:@"FIX_BCOWEBVIEW_HTML=YES %@/BCOWebView.sh %@ %@ '%@' %@", srcFolder, srcFolder, escapedPath, self.version, @"BCOWebView.sh BCOWebView.h BCOWebView.m BCOWebView.html BCOWebView.js"];
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
