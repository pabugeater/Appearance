//
//  BCOWebView.h, Ver 1.fixme
//
//  Created by Steve Lidie on 12/8/18.
//

#ifndef kBCOWebViewX
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#endif
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef kBCOWebViewX
@interface BCOWebView : WKWebView <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate, MFMailComposeViewControllerDelegate>
#else
@interface BCOWebView : WKWebView <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>
#endif

@property( nonatomic, strong ) id contentController;
@property( nonatomic, copy ) void(^checkJsStatus)(NSString *returnCode, NSError *error);
@property( nonatomic, copy ) void(^initCompletionHandler)(NSString *__nullable returnCode, NSError *__nullable error);

- (id) initWithFile:(NSString *)file contentController:(id)contentController andFrame:(CGRect)frame  completionHandler:(void (^__nullable)(id, NSError *__nullable error))completionHandler;
- (void) addConstraintsForView:(id)view;

@end

NS_ASSUME_NONNULL_END