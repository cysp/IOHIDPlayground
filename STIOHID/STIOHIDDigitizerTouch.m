//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDDigitizerTouch.h"
#import "STIOHIDDigitizer+Internal.h"
#import "STIOHIDDigitizerTouch+Internal.h"


@interface STIOHIDDigitizerTouch ()
@property (nonatomic,strong,readonly) STIOHIDDigitizer *digitizer;
@end

@implementation STIOHIDDigitizerTouch

- (id)init {
    return [self initWithDigitizer:nil position:CGPointZero];
}
- (id)initWithDigitizer:(STIOHIDDigitizer *)digitizer position:(CGPoint)position {
    if ((self = [super init])) {
        _digitizer = digitizer;
        _position = position;
        _touching = YES;
    }
    return self;
}

- (void)setPosition:(CGPoint)position {
    return [self setPosition:position withDuration:0];
}
- (void)setPosition:(CGPoint)position withDuration:(NSTimeInterval)duration {
    CGPoint const originalPosition = _position;
    if (!CGPointEqualToPoint(_position, position) || duration) {
        _position = position;
        [self.digitizer touch:self animateFromPosition:originalPosition toPosition:_position withDuration:duration];
    }
}

- (void)setTouching:(BOOL)touching {
    if (_touching != touching) {
        _touching = touching;
        [self.digitizer touch:self setTouching:_touching];
    }
}

@end
