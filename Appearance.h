//
//  Appearance.h
//  GO-21
//
//  Created by Steve Lidie on 12/8/18.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Appearance : WKWebView <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property( nonatomic, strong ) UIViewController *viewController;

- (id) initWithFile:(NSString *)file owningViewController:(UIViewController *)viewController andFrame:(CGRect)frame;
- (void) addAppearanceConstraintsForView:(UIView *)view;
- (void) saveState;
    
@end

NS_ASSUME_NONNULL_END
