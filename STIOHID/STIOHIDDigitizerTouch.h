//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface STIOHIDDigitizerTouch : NSObject
@property (nonatomic,assign) CGPoint position;
- (void)setPosition:(CGPoint)position withDuration:(NSTimeInterval)duration;
@property (nonatomic,assign,getter=isTouching) BOOL touching;
@end
