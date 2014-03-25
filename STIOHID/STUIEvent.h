//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <UIKit/UIKit.h>

#import "STIOHIDEvent.h"


@protocol STUIEvent <NSObject>
@end
@protocol STUIInternalEvent <STUIEvent>
- (STIOHIDEventRef)_hidEvent;
@end
