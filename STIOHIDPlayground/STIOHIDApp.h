//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <UIKit/UIKit.h>

#import "STIOHIDAppDelegate.h"


@interface STIOHIDApp : UIApplication
@property (nonatomic,weak) id<STIOHIDApplicationDelegate> delegate;
@end
