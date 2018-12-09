//
//  ViewController.m
//  Appearance
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];    
    self.ap = [[Appearance alloc] initWithFile:@"Appearance.html" owningViewController:self andFrame:self.view.bounds];
    [self.view addSubview:self.ap];
    [self.ap addAppearanceConstraintsForView:self.view];

} // end viewWillAppear

@end
