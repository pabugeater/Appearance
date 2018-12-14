//
//  Appearance.h, Ver 1.fixme
//
//  Created by Steve Lidie on 12/8/18.
//

#ifndef kAppearanceX
#import <UIKit/UIKit.h>
#endif
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Appearance : WKWebView <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property( nonatomic, strong ) id contentController;

- (id) initWithFile:(NSString *)file contentController:(id)contentController andFrame:(CGRect)frame;
- (void) addAppearanceConstraintsForView:(id)view;
- (void) saveState;

@end

NS_ASSUME_NONNULL_END
