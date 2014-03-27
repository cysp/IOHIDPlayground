//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <UIKit/UIKit.h>


@protocol STIOHIDApplicationDelegate <UIApplicationDelegate>
- (void)application:(UIApplication *)application didReceiveEvent:(UIEvent *)event;
@end

@interface STIOHIDAppDelegate : UIResponder <STIOHIDApplicationDelegate>
@property (nonatomic,strong) UIWindow *window;
@end
