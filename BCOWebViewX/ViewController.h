
//
//  ViewController.h
//  BCOWebViewX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BCOWebView.h"
#import "AppDelegate.h"

@interface ViewController : NSViewController <NSWindowDelegate>

@property (nonatomic, retain ) BCOWebView *bwv;

@end

