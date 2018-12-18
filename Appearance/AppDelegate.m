//
//  AppDelegate.m
//  Appearance
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
    NSLog(@"### Appearance version %@.", self.version);
    
}

@end
