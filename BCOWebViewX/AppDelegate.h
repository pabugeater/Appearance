//
//  AppDelegate.h
//  BCOWebViewX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HelpWindowController.h"
#import "BCOWebView.h"
#import "ScriptMessageHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) HelpWindowController *__nullable hwc;
@property (nonatomic, strong) BCOWebView *bwv;

@end

NS_ASSUME_NONNULL_END

