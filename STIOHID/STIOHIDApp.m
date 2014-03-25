//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDApp.h"


@implementation STIOHIDApp

- (void)sendEvent:(UIEvent *)event {
    id<STIOHIDApplicationDelegate> const delegate = self.delegate;

    [super sendEvent:event];

    [delegate application:self didReceiveEvent:event];
}

@end
