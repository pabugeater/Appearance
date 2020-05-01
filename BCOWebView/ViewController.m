//
//  ViewController.m
//  BCOWebView
//
//  Created by Steve Lidie on 12/9/18.
//  Copyright © 2018 Steve Lidie. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];    
    self.bwv = [[BCOWebView alloc] initWithFile:@"BCOWebView.html" contentController:self andFrame:self.view.bounds];
    [self.view addSubview:self.bwv];
    [self.bwv addConstraintsForView:self.view];

} // end viewWillAppear

@end
