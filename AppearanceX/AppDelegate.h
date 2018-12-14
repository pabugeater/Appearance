//
//  AppDelegate.h
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HelpWindowController.h"
#import "Appearance.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSString *macOSMode;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) HelpWindowController *hwc;
@property (nonatomic, strong) Appearance *ap;

@end

