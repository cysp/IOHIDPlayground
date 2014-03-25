//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDAppDelegate.h"

#import "STIOHIDEvent.h"
#import "STUIEvent.h"


@implementation STIOHIDAppDelegate

- (void)setWindow:(UIWindow *)window {
    _window = window;
    [_window makeKeyAndVisible];
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow * const window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];

    self.window = window;

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
    struct STIOHIDDigitizerQualityEventData const * const e1dqed = (struct STIOHIDDigitizerQualityEventData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData));
    struct STIOHIDDigitizerQualityEventData const * const e2dqed = (struct STIOHIDDigitizerQualityEventData const *)(dataBytes + sizeof(struct STIOHIDSystemQueueEventData) + sizeof(struct STIOHIDDigitizerQualityEventData));
    (void)e1dqed;
    (void)e2dqed;

    struct STIOHIDEventAttributeData const * const ead = (struct STIOHIDEventAttributeData const *)ed->attributeData;
    (void)ead;
    NSData * const attributeData = [[NSData alloc] initWithBytesNoCopy:(void *)ed->attributeData length:ed->attributeLength freeWhenDone:NO];
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
