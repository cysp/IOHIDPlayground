//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDApp.h"


@protocol UIApplication <NSObject>
- (void)_handleHIDEvent:(id)o;

@end

@implementation STIOHIDApp

- (void)_handleHIDEvent:(id)o {
    NSLog(@"%@", o);
}

- (void)sendEvent:(UIEvent *)event {
    id<STIOHIDApplicationDelegate> const delegate = self.delegate;

    [super sendEvent:event];

    [delegate application:self didReceiveEvent:event];
}

@end
