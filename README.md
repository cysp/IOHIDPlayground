STIOHID
=======

    STIOHIDDigitizer * const digitizer = [[STIOHIDDigitizer alloc] init];

    STIOHIDDigitizerTouch * __block touch1 = nil;
    STIOHIDDigitizerTouch * __block touch2 = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        touch1 = [digitizer touchAtPosition:(CGPoint){ 100, 100 }];
        touch2 = [digitizer touchAtPosition:(CGPoint){ 150, 100 }];
        [touch1 setPosition:(CGPoint){ 150, 200 } withDuration:.5];
        [touch2 setPosition:(CGPoint){ 200, 200 } withDuration:.5];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [touch2 setTouching:NO];
        [touch1 setPosition:(CGPoint){ 20, 300 } withDuration:.25];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [touch2 setTouching:YES];
        [touch1 setPosition:(CGPoint){ 100, 100 } withDuration:.5];
        [touch2 setPosition:(CGPoint){ 150, 100 } withDuration:.5];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STIOHIDDigitizerTouch * touch = [digitizer touchAtPosition:(CGPoint){ .x = 300, .y = 400 }];
        (void)touch;
    });

![](STIOHID.gif)
