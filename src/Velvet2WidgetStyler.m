#import "../headers/HeadersTweak.h"
#import <objc/runtime.h>

static NSString * const kVelvet2WidgetIdentifier = @"com.noisyflake.velvet2.widgets";
static NSString * const kVelvet2StyleUpdateNotification = @"com.noisyflake.velvet2/updateStyle";
static const void *kVelvet2WidgetOverlayKey = &kVelvet2WidgetOverlayKey;

@interface Velvet2WidgetStyler ()
@property (nonatomic, strong) NSHashTable<UIView *> *hosts;
@end

@implementation Velvet2WidgetStyler

+ (instancetype)sharedInstance {
    static Velvet2WidgetStyler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _hosts = [NSHashTable weakObjectsHashTable];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshWidgetHosts)
                                                     name:kVelvet2StyleUpdateNotification
                                                   object:nil];
    }
    return self;
}

- (BOOL)widgetsEnabled {
    return [[[Velvet2PrefsManager sharedInstance] objectForKey:@"widgetsEnabled"] boolValue];
}

- (void)refreshWidgetHosts {
    for (UIView *hostView in self.hosts.allObjects) {
        [self applyStyleToWidgetHost:hostView];
    }
}

- (UIView *)overlayForHost:(UIView *)hostView createIfNeeded:(BOOL)createIfNeeded {
    UIView *overlay = objc_getAssociatedObject(hostView, kVelvet2WidgetOverlayKey);
    if (!overlay && createIfNeeded) {
        overlay = [UIView new];
        overlay.userInteractionEnabled = NO;
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [overlay.layer addSublayer:[CALayer layer]];
        [overlay.layer addSublayer:[CALayer layer]];
        [hostView insertSubview:overlay atIndex:0];
        objc_setAssociatedObject(hostView, kVelvet2WidgetOverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return overlay;
}

- (UIImage *)candidateIconInView:(UIView *)view {
    if (!view || view.bounds.size.width < 30 || view.bounds.size.height < 30) {
        return nil;
    }

    CGFloat hostArea = CGRectGetWidth(view.bounds) * CGRectGetHeight(view.bounds);
    NSMutableArray<UIView *> *pendingViews = [NSMutableArray arrayWithObject:view];
    NSUInteger visited = 0;

    while (pendingViews.count && visited++ < 96) {
        UIView *candidate = pendingViews.firstObject;
        [pendingViews removeObjectAtIndex:0];

        if ([candidate isKindOfClass:[UIImageView class]]) {
            UIImage *image = ((UIImageView *)candidate).image;
            CGFloat candidateArea = CGRectGetWidth(candidate.bounds) * CGRectGetHeight(candidate.bounds);
            if (image && candidateArea >= 144 && candidateArea < hostArea * 0.55) {
                return image;
            }
        }

        for (UIView *subview in candidate.subviews) {
            if (!subview.hidden && subview.alpha > 0.01) {
                [pendingViews addObject:subview];
            }
        }
    }

    return nil;
}

- (void)restoreSystemStyleForHost:(UIView *)hostView {
    UIView *overlay = [self overlayForHost:hostView createIfNeeded:NO];
    overlay.hidden = YES;
    hostView.layer.shadowRadius = 0;
    hostView.layer.shadowOpacity = 0;
    hostView.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
}

- (void)applyStyleToWidgetHost:(id)candidateHost {
    if (![candidateHost isKindOfClass:[UIView class]]) {
        return;
    }

    UIView *hostView = (UIView *)candidateHost;
    if (hostView.bounds.size.width < 30 || hostView.bounds.size.height < 30) {
        return;
    }

    NSString *className = NSStringFromClass(hostView.class);
    if ([className rangeOfString:@"widget" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        return;
    }

    [self.hosts addObject:hostView];
    if (![self widgetsEnabled]) {
        [self restoreSystemStyleForHost:hostView];
        return;
    }

    UIView *overlay = [self overlayForHost:hostView createIfNeeded:YES];
    overlay.hidden = NO;
    overlay.frame = hostView.bounds;

    Velvet2Colorizer *colorizer = [[Velvet2Colorizer alloc] initWithIdentifier:kVelvet2WidgetIdentifier];
    colorizer.appIcon = [self candidateIconInView:hostView];

    CGFloat defaultCornerRadius = hostView.layer.cornerRadius > 0 ? hostView.layer.cornerRadius : 22.0;
    CGFloat configuredCornerRadius = [[[Velvet2PrefsManager sharedInstance] settingForKey:@"cornerRadiusCustom" withIdentifier:kVelvet2WidgetIdentifier] floatValue];
    BOOL useConfiguredCornerRadius = [[[Velvet2PrefsManager sharedInstance] settingForKey:@"cornerRadiusEnabled" withIdentifier:kVelvet2WidgetIdentifier] boolValue];
    CGFloat cornerRadius = useConfiguredCornerRadius ? configuredCornerRadius : defaultCornerRadius;
    cornerRadius = MIN(MAX(cornerRadius, 0), CGRectGetHeight(hostView.bounds) / 2.0);

    overlay.layer.continuousCorners = cornerRadius < CGRectGetHeight(overlay.bounds) / 2.0;
    overlay.layer.cornerRadius = cornerRadius;
    hostView.layer.continuousCorners = cornerRadius < CGRectGetHeight(hostView.bounds) / 2.0;
    hostView.layer.cornerRadius = cornerRadius;

    [colorizer colorBackground:overlay];
    [colorizer colorBorder:overlay];
    [colorizer colorLine:overlay inFrame:overlay.bounds];
    [colorizer colorShadow:hostView];
    [colorizer setAppearance:hostView];
}

@end
