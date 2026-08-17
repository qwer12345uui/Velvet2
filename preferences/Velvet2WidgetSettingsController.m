#import "../headers/HeadersPreferences.h"

static NSString * const kVelvet2WidgetIdentifier = @"com.noisyflake.velvet2.widgets";

@interface Velvet2WidgetSettingsController ()
@property (nonatomic, copy) NSArray *widgetSpecifiers;
@end

@implementation Velvet2WidgetSettingsController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.identifier = kVelvet2WidgetIdentifier;
        self.identifierName = @"Widgets";
        self.title = @"Widgets";
    }
    return self;
}

- (NSArray *)specifiers {
    if (self.widgetSpecifiers) {
        return self.widgetSpecifiers;
    }

    NSArray *baseSpecifiers = [super specifiers];
    NSSet<NSString *> *excludedKeys = [NSSet setWithArray:@[
        @"Title", @"Message", @"Date",
        @"appIconHidden", @"appIconCornerRadiusCircle", @"stackDimmingViewHidden"
    ]];
    NSSet<NSString *> *excludedGroupLabels = [NSSet setWithArray:@[@"Label", @"App Icon"]];
    NSMutableArray *filteredSpecifiers = [NSMutableArray array];

    for (PSSpecifier *specifier in baseSpecifiers) {
        NSString *key = specifier.properties[@"key"];
        NSString *label = specifier.properties[@"label"];
        if ([excludedKeys containsObject:key] || [excludedGroupLabels containsObject:label]) {
            continue;
        }
        [filteredSpecifiers addObject:specifier];
    }

    self.widgetSpecifiers = [filteredSpecifiers copy];
    return self.widgetSpecifiers;
}

@end
