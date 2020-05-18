//
//  ScriptMessageHandler.h
//  BCOWebView
//
//  Created by Steve Lidie on 5/17/20.
//  Copyright © 2020 Steve Lidie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScriptMessageHandler : NSObject

@property( nonatomic, copy ) void(^__nullable scriptMessageHandler)(WKUserContentController *__nonnull userContentController, WKScriptMessage *__nonnull scriptMessage);

@end

NS_ASSUME_NONNULL_END
