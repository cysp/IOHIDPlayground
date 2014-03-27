//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDEvent.h"

#import <dlfcn.h>


STIOHIDEventCreateData_t STIOHIDEventCreateData = NULL;
STIOHIDEventCreateWithBytes_t STIOHIDEventCreateWithBytes = NULL;

STIOHIDEventCreateDigitizerFingerEventWithQuality_t STIOHIDEventCreateDigitizerFingerEventWithQuality = NULL;
STIOHIDEventCreateDigitizerEvent_t STIOHIDEventCreateDigitizerEvent = NULL;
STIOHIDEventAppendEvent_t STIOHIDEventAppendEvent = NULL;
STIOHIDEventSystemClientCreate_t STIOHIDEventSystemClientCreate = NULL;
STIOHIDEventSystemClientDispatchEvent_t STIOHIDEventSystemClientDispatchEvent = NULL;

STIOHIDEventGetAttributeData_t STIOHIDEventGetAttributeData = NULL;
STIOHIDEventGetIntegerValue_t STIOHIDEventGetIntegerValue = NULL;
STIOHIDEventSetIntegerValue_t STIOHIDEventSetIntegerValue = NULL;
STIOHIDEventGetFloatValue_t STIOHIDEventGetFloatValue = NULL;
STIOHIDEventSetFloatValue_t STIOHIDEventSetFloatValue = NULL;

__attribute__((constructor))
void STIOHIDEventInit(void) {
    STIOHIDEventCreateData = dlsym(RTLD_DEFAULT, "IOHIDEventCreateData");
    STIOHIDEventCreateWithBytes = dlsym(RTLD_DEFAULT, "IOHIDEventCreateWithBytes");
    STIOHIDEventCreateDigitizerEvent = dlsym(RTLD_DEFAULT, "IOHIDEventCreateDigitizerEvent");
    STIOHIDEventCreateDigitizerFingerEventWithQuality = dlsym(RTLD_DEFAULT, "IOHIDEventCreateDigitizerFingerEventWithQuality");
    STIOHIDEventAppendEvent = dlsym(RTLD_DEFAULT, "IOHIDEventAppendEvent");
    STIOHIDEventSystemClientCreate = dlsym(RTLD_DEFAULT, "IOHIDEventSystemClientCreate");
    STIOHIDEventSystemClientDispatchEvent = dlsym(RTLD_DEFAULT, "IOHIDEventSystemClientDispatchEvent");

    STIOHIDEventGetAttributeData = dlsym(RTLD_DEFAULT, "IOHIDEventGetAttributeData");
    STIOHIDEventGetIntegerValue = dlsym(RTLD_DEFAULT, "IOHIDEventGetIntegerValue");
    STIOHIDEventSetIntegerValue = dlsym(RTLD_DEFAULT, "IOHIDEventSetIntegerValue");
    STIOHIDEventGetFloatValue = dlsym(RTLD_DEFAULT, "IOHIDEventGetFloatValue");
    STIOHIDEventSetFloatValue = dlsym(RTLD_DEFAULT, "IOHIDEventSetFloatValue");
}
