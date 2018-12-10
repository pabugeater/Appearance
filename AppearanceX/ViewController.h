
//
//  ViewController.h
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Appearance.h"

@interface ViewController : NSViewController {
    Appearance *ap;
}

@property (nonatomic, retain ) Appearance *ap;

@end

