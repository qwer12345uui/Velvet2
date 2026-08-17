#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Applies the existing Velvet2 visual vocabulary to a verified WidgetKit host view.
/// This class must never be used on generic UIKit views or widget extension processes.
@interface Velvet2WidgetStyler : NSObject

+ (instancetype)sharedInstance;
- (void)applyStyleToWidgetHost:(id)candidateHost;

@end

NS_ASSUME_NONNULL_END
