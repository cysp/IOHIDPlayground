//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDAppDelegate.h"

#import "STIOHIDEvent.h"
#import "STUIEvent.h"

#import <mach/mach_time.h>


@implementation STIOHIDAppDelegate

- (void)setWindow:(UIWindow *)window {
    _window = window;
    [_window makeKeyAndVisible];
}


- (void)tapRecognized:(UITapGestureRecognizer *)recognizer {
    NSLog(@"%@", recognizer);
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow * const window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];

    self.window = window;

    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [window addGestureRecognizer:r];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        struct STIOHIDSystemQueueEventData h = (struct STIOHIDSystemQueueEventData){
            .timestamp = mach_absolute_time(),
            .senderID = 0,
            .options = STIOHIDEventOptionIsAbsolute|STIOHIDEventOptionIsPixelUnits,
            .eventCount = 2,
        };

        struct STIOHIDDigitizerQualityEventData hed = (struct STIOHIDDigitizerQualityEventData){
            .base = {
                .base = {
                    .base = {
                        .length = sizeof(struct STIOHIDDigitizerQualityEventData),
                        .type = STIOHIDEventTypeDigitizer,
                        .options = {
                            .genericOptions = STIOHIDEventOptionIsAbsolute|STIOHIDEventOptionIsPixelUnits,
                            .eventOptions = STIOHIDDigitizerEventTouch,
                        },
                        .depth = 0,
                    },
                },
                .transducerIndex = 2,
                .transducerType = STIOHIDDigitizerTransducerTypeHand,
                .identity = 1000,
                .eventMask = STIOHIDDigitizerEventTouch,
                .childEventMask = STIOHIDDigitizerEventRange|STIOHIDDigitizerEventTouch,
            },
        };

        struct STIOHIDDigitizerQualityEventData fed = (struct STIOHIDDigitizerQualityEventData){
            .base = {
                .base = {
                    .base = {
                        .length = sizeof(struct STIOHIDDigitizerQualityEventData),
                        .type = STIOHIDEventTypeDigitizer,
                        .options = {
                            .genericOptions = STIOHIDEventOptionIsAbsolute|STIOHIDEventOptionIsPixelUnits,
                            .eventOptions = STIOHIDDigitizerEventRange|STIOHIDDigitizerEventTouch,
                        },
                        .depth = 1,
                    },
                    .position = {
                        .x = { .hi = 200 },
                        .y = { .hi = 160 },
                    },
                },
                .transducerIndex = 2,
                .transducerType = STIOHIDDigitizerTransducerTypeFinger,
                .identity = 1001,
                .eventMask = STIOHIDDigitizerEventRange|STIOHIDDigitizerEventTouch,
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


        STIOHIDEventSystemClientRef const c = STIOHIDEventSystemClientCreate(NULL);

        {
            uint8_t d[sizeof(h) + sizeof(hed) + sizeof(fed)] = { 0 };

            memcpy(&d[0], &h, sizeof(h));
            memcpy(&d[sizeof(h)], &hed, sizeof(hed));
            memcpy(&d[sizeof(h)+sizeof(hed)], &fed, sizeof(fed));

            STIOHIDEventRef e = STIOHIDEventCreateWithBytes(NULL, d, sizeof(d));
            if (e) {
                if (c) {
                    STIOHIDEventSystemClientDispatchEvent(c, e);
                }
                CFRelease(e);
            }
        }

        h.timestamp += 10;
        hed.base.base.base.options.eventOptions = 0;
        fed.base.base.base.options.eventOptions = 0;

        {
            uint8_t d[sizeof(h) + sizeof(hed) + sizeof(fed)] = { 0 };

            memcpy(&d[0], &h, sizeof(h));
            memcpy(&d[sizeof(h)], &hed, sizeof(hed));
            memcpy(&d[sizeof(h)+sizeof(hed)], &fed, sizeof(fed));

            STIOHIDEventRef e = STIOHIDEventCreateWithBytes(NULL, d, sizeof(d));
            if (e) {
                if (c) {
                    STIOHIDEventSystemClientDispatchEvent(c, e);
                }
                CFRelease(e);
            }
        }

        if (c) {
            CFRelease(c);
        }
    });

    return YES;
}


#pragma mark - STIOHIDApplicationDelegate

- (void)application:(UIApplication *)application didReceiveEvent:(UIEvent *)event {
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
    struct STIOHIDDigitizerQualityEventData const * const e1dqed = (struct STIOHIDDigitizerQualityEventData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData) + ed->attributeLength);
    struct STIOHIDDigitizerQualityEventData const * const e2dqed = (struct STIOHIDDigitizerQualityEventData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData) + ed->attributeLength + sizeof(struct STIOHIDDigitizerQualityEventData));
    (void)e1dqed;
    (void)e2dqed;

    struct STIOHIDEventAttributeData const * const ead = (struct STIOHIDEventAttributeData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData));
    (void)ead;
    NSData * const attributeData = [[NSData alloc] initWithBytesNoCopy:(void *)ead length:ed->attributeLength freeWhenDone:NO];
    NSLog(@"attr: %@", attributeData);

    if (e->children && CFArrayGetCount(e->children) > 0) {
        STIOHIDEventRef const child0 = CFArrayGetValueAtIndex(e->children, 0);
        struct STIOHIDDigitizerQualityEvent *dqe = (struct STIOHIDDigitizerQualityEvent *)child0;
        (void)dqe;

        NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, child0);
        (void)data;
//        NSLog(@"  c0: %@", data);
    }

    if (e->children && CFArrayGetCount(e->children) > 1) {
        STIOHIDEventRef const child1 = CFArrayGetValueAtIndex(e->children, 1);
        struct STIOHIDDigitizerQualityEvent *dqe = (struct STIOHIDDigitizerQualityEvent *)child1;
        (void)dqe;

//        NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, child1);
//        NSLog(@"  c1: %@", data);
    }

    if (e->children && CFArrayGetCount(e->children) > 2) {
        STIOHIDEventRef const child2 = CFArrayGetValueAtIndex(e->children, 2);
        struct STIOHIDDigitizerQualityEvent *dqe = (struct STIOHIDDigitizerQualityEvent *)child2;
        (void)dqe;

//        NSData * const data = (__bridge_transfer NSData *)STIOHIDEventCreateData(NULL, child2);
//        NSLog(@"  c2: %@", data);
    }
}

@end
