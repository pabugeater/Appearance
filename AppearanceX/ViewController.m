//
//  ViewController.m
//  AppearanceX
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize ap;


- (void)viewWillAppear {
    
    [super viewWillAppear];
    self.ap = [[Appearance alloc] initWithFile:@"Appearance.html" owningViewController:self.view.window andFrame:self.view.bounds];
    [self.view addSubview:self.ap];
    [self.ap addAppearanceConstraintsForView:self.view];

}  // end viewWillAppear

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
