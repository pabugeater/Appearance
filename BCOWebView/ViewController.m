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
    self.bwv = [[BCOWebView alloc] initWithFile:@"BCOWebView.html"
                              contentController:self andFrame:self.view.bounds
                              completionHandler:^(id __nullable result, NSError *__nullable error) {
            NSLog(@"BCOWebView in completion handler, result '%@'", result);
            if ( ! error ) {
                [self.view addSubview:self.bwv];
                [self.bwv addConstraintsForView:self.view];
            } else {
                NSLog(@"BCOWebView initWithFile error: %@", error);
            }
        }
    ];

} // end viewWillAppear

@end
