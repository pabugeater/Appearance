//
//  Appearance.h
//  GO-21
//
//  Created by Steve Lidie on 12/8/18.
//

#ifndef AppearanceX
#import <UIKit/UIKit.h>
#endif
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Appearance : WKWebView <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

#ifndef AppearanceX
@property( nonatomic, strong ) UIViewController *viewController;
#else
@property( nonatomic, strong ) NSWindow *viewController;
#endif

#ifndef AppearanceX
- (id) initWithFile:(NSString *)file owningViewController:(UIViewController *)viewController andFrame:(CGRect)frame;
- (void) addAppearanceConstraintsForView:(UIView *)view;
- (void) saveState;
#else
- (id) initWithFile:(NSString *)file owningViewController:(NSWindow *)viewController andFrame:(CGRect)frame;
- (void) addAppearanceConstraintsForView:(NSView *)view;
- (void) saveState;
#endif

@end

NS_ASSUME_NONNULL_END
