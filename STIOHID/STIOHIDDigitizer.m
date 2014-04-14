//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDDigitizer.h"
#import "STIOHIDDigitizer+Internal.h"
#import "STIOHIDDigitizerTouch+Internal.h"

#import <QuartzCore/QuartzCore.h>
#import "STIOHIDEvent.h"
#import "STIOHIDEventFunctions.h"

#import <math.h>
#import <mach/mach_time.h>


static NSUInteger const STIOHIDDigitizerExpectedNumberOfTouches = 4;


static STIOHIDEventRef STIOHIDDigitizerTouchEventCreate(uint32_t identity, NSMutableArray *fingerEventDatas) {
    NSUInteger const numberOfFingerEvents = fingerEventDatas.count;
    if (numberOfFingerEvents <= 0) {
        return NULL;
    }
    NSCAssert(numberOfFingerEvents <= (UINT32_MAX - 1), @"");

    struct STIOHIDSystemQueueEventData h = (struct STIOHIDSystemQueueEventData){
        .timestamp = mach_absolute_time(),
        .senderID = 0x7374696f68696421,
        .options = STIOHIDEventOptionIsAbsolute|STIOHIDEventOptionIsPixelUnits,
        .eventCount = 1 + (uint32_t)numberOfFingerEvents,
    };

    struct STIOHIDDigitizerQualityEventData hed = (struct STIOHIDDigitizerQualityEventData){
        .base = {
            .base = {
                .base = {
                    .length = sizeof(struct STIOHIDDigitizerQualityEventData),
                    .type = STIOHIDEventTypeDigitizer,
                    .options = {
                        .genericOptions = STIOHIDEventOptionIsAbsolute|STIOHIDEventOptionIsPixelUnits,
                        .eventOptions = STIOHIDTransducerTouch,
                    },
                    .depth = 0,
                },
            },
            .transducerIndex = identity,
            .transducerType = STIOHIDDigitizerTransducerTypeHand,
            .identity = identity,
            .eventMask = STIOHIDDigitizerEventTouch,
            .childEventMask = STIOHIDDigitizerEventRange|STIOHIDDigitizerEventTouch,
        },
    };

    NSMutableData * const eventData = [[NSMutableData alloc] initWithCapacity:0];
    [eventData appendBytes:&h length:sizeof(h)];
    [eventData appendBytes:&hed length:sizeof(hed)];
    for (NSData *fingerEventData in fingerEventDatas) {
        [eventData appendData:fingerEventData];
    }

    STIOHIDEventRef e = STIOHIDEventCreateWithBytes(NULL, (void *)eventData.bytes, eventData.length);
    return e;
}


@interface STIOHIDDigitizerDisplayLinkTrampoline : NSObject
- (id)initWithTarget:(id)target;
@end
@implementation STIOHIDDigitizerDisplayLinkTrampoline {
@private
    id __weak _target;
}
- (id)init {
    return [self initWithTarget:nil];
}
- (id)initWithTarget:(id)target {
    if ((self = [super init])) {
        _target = target;
    }
    return self;
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}
@end


@interface STIOHIDDigitizerTouchContext : NSObject
@property (nonatomic,assign,readonly) uint32_t identity;
@property (nonatomic,assign) BOOL touching;
@property (nonatomic,assign) CGPoint position;
@end
@implementation STIOHIDDigitizerTouchContext
- (id)init {
    return [self initWithIdentity:0 position:CGPointZero];
}
- (id)initWithIdentity:(uint32_t)identity position:(CGPoint)position {
    if ((self = [super init])) {
        _identity = identity;
        _position = position;
        _touching = YES;
    }
    return self;
}
@end


@interface STIOHIDDigitizerTouchAnimationState : NSObject
@property (nonatomic,assign,readonly) CGPoint targetPosition;
- (void)setTargetPosition:(CGPoint)position duration:(NSTimeInterval)duration;
- (CGPoint)positionByRemovingDuration:(NSTimeInterval)duration;
@property (nonatomic,assign,getter=isFinished,readonly) BOOL finished;
@end
@implementation STIOHIDDigitizerTouchAnimationState {
@private
    CGPoint _startingPosition;
    CGPoint _currentPosition;
    NSTimeInterval _totalDuration;
    NSTimeInterval _remainingDuration;
}
- (id)init {
    return [self initWithPosition:CGPointZero targetPosition:CGPointZero duration:0];
}
- (id)initWithPosition:(CGPoint)position targetPosition:(CGPoint)targetPosition duration:(NSTimeInterval)duration {
    if ((self = [super init])) {
        _startingPosition = _currentPosition = position;
        _targetPosition = targetPosition;
        _remainingDuration = _totalDuration = duration;
    }
    return self;
}
- (void)setTargetPosition:(CGPoint)position duration:(NSTimeInterval)duration {
    _startingPosition = _currentPosition;
    _targetPosition = position;
    _remainingDuration = _totalDuration = duration;
}
- (CGPoint)positionByRemovingDuration:(NSTimeInterval)duration {
    CGPoint const startingPosition = _startingPosition;
    CGPoint const targetPosition = _targetPosition;
    NSTimeInterval totalDuration = _totalDuration;
    duration = MIN(duration, MAX(0, _remainingDuration));
    if ((_remainingDuration -= duration) == 0) {
        return targetPosition;
    }

    NSTimeInterval const remainingDuration = _remainingDuration;

    double const t = (totalDuration - remainingDuration) / totalDuration;

    double deltaPortion;
    if (t == .5) {
        deltaPortion = .5;
    } else if (t < .5) {
        deltaPortion = 2 * t * t;
    } else if (t > .5) {
        deltaPortion = 1 - (2 * (t - 1) * (t - 1));
    }

    CGVector const delta = (CGVector){
        .dx = targetPosition.x - startingPosition.x,
        .dy = targetPosition.y - startingPosition.y,
    };
    CGPoint const position = (CGPoint){
        .x = startingPosition.x + delta.dx * deltaPortion,
        .y = startingPosition.y + delta.dy * deltaPortion,
    };
    _currentPosition = position;
    return position;
}
- (BOOL)isFinished {
    if (_remainingDuration <= 0) {
        return YES;
    }
//    if (CGPointEqualToPoint(_position, _targetPosition)) {
//        return YES;
//    }
    return NO;
}
@end


@implementation STIOHIDDigitizer {
@private
    STIOHIDDigitizer *_selfRef;
    STIOHIDEventSystemClientRef _eventSystemClient;
    uint32_t _nextTouchIdentifier;
    NSMutableSet *_touchContexts;
    NSMapTable *_touchesByTouchContext;
    NSMapTable *_touchAnimationsByTouch;
    CADisplayLink *_displayLink;
    STIOHIDDigitizerDisplayLinkTrampoline *_displayLinkTrampoline;
}

- (id)init {
    if ((self = [super init])) {
        _eventSystemClient = STIOHIDEventSystemClientCreate(NULL);
        STIOHIDEventSystemClientScheduleWithRunLoop(_eventSystemClient, CFRunLoopGetMain(), kCFRunLoopCommonModes);

        _touchContexts = [[NSMutableSet alloc] initWithCapacity:STIOHIDDigitizerExpectedNumberOfTouches];
        _touchesByTouchContext = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsObjectPersonality|NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsObjectPersonality|NSPointerFunctionsWeakMemory capacity:STIOHIDDigitizerExpectedNumberOfTouches];
        _touchAnimationsByTouch = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsObjectPersonality|NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsObjectPersonality|NSPointerFunctionsStrongMemory capacity:STIOHIDDigitizerExpectedNumberOfTouches];

        STIOHIDDigitizerDisplayLinkTrampoline * const displayLinkTrampoline = [[STIOHIDDigitizerDisplayLinkTrampoline alloc] initWithTarget:self];
        _displayLinkTrampoline = displayLinkTrampoline;

        _displayLink = [CADisplayLink displayLinkWithTarget:_displayLinkTrampoline selector:@selector(displayLinkFired:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

        [self updateDisplayLinkPausedStatus];
    }
    return self;
}

- (void)dealloc {
    if (_eventSystemClient) {
        CFRelease(_eventSystemClient), _eventSystemClient = NULL;
    }
    [_displayLink invalidate];
}


- (STIOHIDDigitizerTouch *)touchAtPosition:(CGPoint)position {
    uint32_t const touchIdentifier = _nextTouchIdentifier++;
    STIOHIDDigitizerTouch * const touch = [[STIOHIDDigitizerTouch alloc] initWithDigitizer:self position:position];
    STIOHIDDigitizerTouchContext * const touchContext = [[STIOHIDDigitizerTouchContext alloc] initWithIdentity:touchIdentifier position:position];
    [_touchContexts addObject:touchContext];
    [_touchesByTouchContext setObject:touch forKey:touchContext];
    STIOHIDDigitizerTouchAnimationState * const animationState = [[STIOHIDDigitizerTouchAnimationState alloc] initWithPosition:position targetPosition:position duration:0];
    [_touchAnimationsByTouch setObject:animationState forKey:touch];
    [self updateDisplayLinkPausedStatus];
    return touch;
}


- (void)updateDisplayLinkPausedStatus {
    BOOL const needsDisplayLinkUnpaused = _touchContexts.count > 0;
    _selfRef = needsDisplayLinkUnpaused ? self : nil;
    _displayLink.paused = !needsDisplayLinkUnpaused;
}

- (void)displayLinkFired:(CADisplayLink *)displayLink {
    uint32_t const digitizerIdentity = 1000;
    NSMutableArray * const fingerEventDatas = [[NSMutableArray alloc] init];

    NSTimeInterval const interval = displayLink.duration;

    NSMutableSet * const touchContexts = _touchContexts.copy;
    NSMapTable * const touchesByTouchContext = _touchesByTouchContext;
    NSMapTable * const inflightTouches = _touchAnimationsByTouch.copy;
    for (STIOHIDDigitizerTouchContext *touchContext in touchContexts) {
        STIOHIDDigitizerTouch * const touch = [touchesByTouchContext objectForKey:touchContext];
        STIOHIDDigitizerTouchAnimationState * const touchAnimation = [inflightTouches objectForKey:touch];

        uint32_t const touchIdentity = touchContext.identity;

        BOOL const oldTouching = touchContext.touching;
        CGPoint const oldPosition = touchContext.position;

        BOOL const touchTouching = [touch isTouching];
        CGPoint const touchPosition = touchAnimation ? [touchAnimation positionByRemovingDuration:interval] : touchContext.position;

        BOOL const touchChanged = oldTouching != touchTouching;
        BOOL const positionChanged = !CGPointEqualToPoint(oldPosition, touchPosition);

        touchContext.touching = touchTouching;
        touchContext.position = touchPosition;

        if (touchChanged || touchTouching || positionChanged) {
            struct STIOHIDDigitizerQualityEventData fed = (struct STIOHIDDigitizerQualityEventData){
                .base = {
                    .base = {
                        .base = {
                            .length = sizeof(struct STIOHIDDigitizerQualityEventData),
                            .type = STIOHIDEventTypeDigitizer,
                            .options = {
                                .genericOptions = STIOHIDEventOptionIsAbsolute|STIOHIDEventOptionIsPixelUnits,
                                .eventOptions = STIOHIDTransducerRange | (touchTouching ? STIOHIDTransducerTouch : 0),
                            },
                            .depth = 1,
                        },
                        .position = {
                            .x = { .hi = (int)touchPosition.x, .lo = (int)(fmod(touchPosition.x, 1) * 0x10000) },
                            .y = { .hi = (int)touchPosition.y, .lo = (int)(fmod(touchPosition.y, 1) * 0x10000) },
                        },
                    },
                    .transducerIndex = touchIdentity,
                    .transducerType = STIOHIDDigitizerTransducerTypeFinger,
                    .identity = touchIdentity,
                    .eventMask = STIOHIDDigitizerEventRange | (touchChanged ? STIOHIDDigitizerEventTouch : 0) | (positionChanged ? STIOHIDDigitizerEventPosition : 0),
                    .orientationType = STIOHIDDigitizerOrientationTypeQuality,
                },
                .orientation = {
                    .quality = { .hi = 1 },
                    .density = { .hi = 1 },
                    .irregularity = { .hi = 1 },
                    .majorRadius = { .hi = 5 },
                    .minorRadius = { .hi = 5 },
                },
            };

            NSData * const fingerEventData = [[NSData alloc] initWithBytes:&fed length:sizeof(fed)];
            [fingerEventDatas addObject:fingerEventData];
        }

        if (!touch) {
            [_touchContexts removeObject:touchContext];
        }
        if ([touchAnimation isFinished]) {
            [_touchAnimationsByTouch removeObjectForKey:touch];
        }
    }

    STIOHIDEventSystemClientRef const eventSystemClient = _eventSystemClient;
    if (eventSystemClient) {
        STIOHIDEventRef const event = STIOHIDDigitizerTouchEventCreate(digitizerIdentity, fingerEventDatas);
        if (event) {
            STIOHIDEventSystemClientDispatchEvent(eventSystemClient, event);
            CFRelease(event);
        }
    }

    [self updateDisplayLinkPausedStatus];
}


- (void)touch:(STIOHIDDigitizerTouch *)touch animateFromPosition:(CGPoint)position toPosition:(CGPoint)targetPosition withDuration:(NSTimeInterval)duration {
    NSMapTable * const inflightTouches = _touchAnimationsByTouch;
    {
        STIOHIDDigitizerTouchAnimationState * const animation = [inflightTouches objectForKey:touch];
        if (animation) {
            [animation setTargetPosition:targetPosition duration:duration];
            return;
        }
    }

    STIOHIDDigitizerTouchAnimationState * const animation = [[STIOHIDDigitizerTouchAnimationState alloc] initWithPosition:position targetPosition:targetPosition duration:duration];
    [inflightTouches setObject:animation forKey:touch];

    [self updateDisplayLinkPausedStatus];
}

- (void)touch:(STIOHIDDigitizerTouch *)touch setTouching:(BOOL)touching {
    if (!touching) {
        [_touchAnimationsByTouch removeObjectForKey:touch];
    }
    [self updateDisplayLinkPausedStatus];
//    if (![touch isTouching]) {
//        [inflightTouches removeObjectForKey:touch];
//        return;
//    }
}

@end
