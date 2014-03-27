//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class STIOHIDDigitizerTouch;


@interface STIOHIDDigitizer : NSObject
- (STIOHIDDigitizerTouch *)touchAtPosition:(CGPoint)position;
@end
