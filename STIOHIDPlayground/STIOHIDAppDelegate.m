//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDAppDelegate.h"

#import <STIOHID/STIOHID.h>
#import <STIOHID/STIOHIDEventFunctions.h>
#import <STTouchDisplay/STTouchDisplay.h>

#import "STUIEvent.h"

#import <mach/mach_time.h>


@interface STIOHIDAppDelegate () <UIScrollViewDelegate>
@end

@implementation STIOHIDAppDelegate {
@private
    STTouchDisplayWindow *_touchDisplayWindow;
    UIView *_zoomView;
}

- (void)setWindow:(UIWindow *)window {
    _window = window;
    [_window makeKeyAndVisible];
}


- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap recognized: %@", recognizer);
    self.window.backgroundColor = [UIColor purpleColor];
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect const screenBounds = [[UIScreen mainScreen] bounds];
    UIWindow * const window = [[UIWindow alloc] initWithFrame:screenBounds];
    window.backgroundColor = [UIColor whiteColor];

    UIScrollView * const scrollView = [[UIScrollView alloc] initWithFrame:screenBounds];
    scrollView.contentSize = screenBounds.size;
    scrollView.delegate = self;
    scrollView.minimumZoomScale = .1;
    scrollView.maximumZoomScale = 2;
    scrollView.bounces = YES;
    scrollView.bouncesZoom = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    [window addSubview:scrollView];

    UIView * const zoomView = _zoomView = [[UIView alloc] initWithFrame:scrollView.bounds];
    zoomView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.2f];
    [scrollView addSubview:zoomView];

    self.window = window;

    _touchDisplayWindow = [[STTouchDisplayWindow alloc] initWithFrame:screenBounds];

    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [zoomView addGestureRecognizer:r];

    STIOHIDDigitizer * const digitizer = [[STIOHIDDigitizer alloc] init];

    STIOHIDDigitizerTouch * __block touch1 = nil;
    STIOHIDDigitizerTouch * __block touch2 = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        touch1 = [digitizer touchAtPosition:(CGPoint){ 100, 100 }];
        touch2 = [digitizer touchAtPosition:(CGPoint){ 150, 100 }];
        [touch1 setPosition:(CGPoint){ 150, 200 } withDuration:1];
        [touch2 setPosition:(CGPoint){ 200, 200 } withDuration:1];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [touch2 setTouching:NO];
        [touch1 setPosition:(CGPoint){ 20, 300 } withDuration:.5];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [touch2 setTouching:YES];
        [touch1 setPosition:(CGPoint){ 100, 100 } withDuration:1];
        [touch2 setPosition:(CGPoint){ 150, 100 } withDuration:1];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STIOHIDDigitizerTouch * touch = [digitizer touchAtPosition:(CGPoint){ .x = 300, .y = 400 }];
        (void)touch;
    });

    return YES;
}


#pragma mark - STIOHIDApplicationDelegate

- (void)application:(UIApplication *)application didReceiveEvent:(UIEvent *)event {
    switch (event.type) {
        case UIEventTypeTouches:
            [_touchDisplayWindow updateWithEvent:event];
            break;
        case UIEventTypeMotion:
        case UIEventTypeRemoteControl:
            break;
    }

    if (![event respondsToSelector:@selector(_hidEvent)]) {
        return;
    }

    STIOHIDEventRef const hidevent = [((id<STUIInternalEvent>)event) _hidEvent];
    struct STIOHIDEvent *e = (struct STIOHIDEvent *)hidevent;
    if (!e) {
        return;
    }

    (void)e;


//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerIdentity, 0xaa);
//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerButtonMask, 0xff);
//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerEventMask, 0xee);
//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerChildEventMask, 0xdd);
//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerRange, 0xcc);
//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerTouch, 0xbb);
//    STIOHIDEventSetIntegerValue(hidevent, STIOHIDEventFieldDigitizerIsDisplayIntegrated, 0x99);
//    STIOHIDEventSetFloatValue(hidevent, STIOHIDEventFieldDigitizerPressure, .33);
//    STIOHIDEventSetFloatValue(hidevent, STIOHIDEventFieldDigitizerAuxiliaryPressure, .66);
//    STIOHIDEventSetFloatValue(hidevent, STIOHIDEventFieldDigitizerTwist, .75);

    NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, hidevent);
//    NSLog(@"e: %@", data);

    void const * const dataBytes = data.bytes;
    struct STIOHIDSystemQueueEventData const * const ed = (struct STIOHIDSystemQueueEventData const *)dataBytes;
    struct STIOHIDDigitizerQualityEventData const * const e1dqed = (struct STIOHIDDigitizerQualityEventData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData) + ed->attributeDataLength);
    struct STIOHIDDigitizerQualityEventData const * const e2dqed = (struct STIOHIDDigitizerQualityEventData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData) + ed->attributeDataLength + sizeof(struct STIOHIDDigitizerQualityEventData));
    (void)e1dqed;
    (void)e2dqed;

    NSLog(@"p: %g,%g", STIOFixedToDouble(e2dqed->base.pressure), STIOFixedToDouble(e2dqed->base.auxPressure));
    NSLog(@"t: %g", STIOFixedToDouble(e2dqed->base.twist));
    NSLog(@"r: %g,%g", STIOFixedToDouble(e2dqed->orientation.majorRadius), STIOFixedToDouble(e2dqed->orientation.minorRadius));

    struct STIOHIDEventAttributeData const * const ead = (struct STIOHIDEventAttributeData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData));
    (void)ead;
    NSData * const attributeData = [[NSData alloc] initWithBytesNoCopy:(void *)ead length:ed->attributeDataLength freeWhenDone:NO];
//    NSLog(@"attr: %@", attributeData);

    if (e->base.children && CFArrayGetCount(e->base.children) > 0) {
        STIOHIDEventRef const child0 = CFArrayGetValueAtIndex(e->base.children, 0);
        struct STIOHIDDigitizerQualityEvent *dqe = (struct STIOHIDDigitizerQualityEvent *)child0;
        (void)dqe;

        NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, child0);
        (void)data;
//        NSLog(@"  c0: %@", data);
    }

    if (e->base.children && CFArrayGetCount(e->base.children) > 1) {
        STIOHIDEventRef const child1 = CFArrayGetValueAtIndex(e->base.children, 1);
        struct STIOHIDDigitizerQualityEvent *dqe = (struct STIOHIDDigitizerQualityEvent *)child1;
        (void)dqe;

//        NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, child1);
//        NSLog(@"  c1: %@", data);
    }

    if (e->base.children && CFArrayGetCount(e->base.children) > 2) {
        STIOHIDEventRef const child2 = CFArrayGetValueAtIndex(e->base.children, 2);
        struct STIOHIDDigitizerQualityEvent *dqe = (struct STIOHIDDigitizerQualityEvent *)child2;
        (void)dqe;

//        NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, child2);
//        NSLog(@"  c2: %@", data);
    }
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomView;
}

@end
