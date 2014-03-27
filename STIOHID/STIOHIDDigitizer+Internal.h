//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDDigitizer.h"

@class STIOHIDDigitizerTouch;


@interface STIOHIDDigitizer ()
- (void)touch:(STIOHIDDigitizerTouch *)touch animateFromPosition:(CGPoint)startPosition toPosition:(CGPoint)endPosition withDuration:(NSTimeInterval)duration;
- (void)touch:(STIOHIDDigitizerTouch *)touch setTouching:(BOOL)touching;
@end
