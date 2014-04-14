//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import "STIOHIDEventFunctions.h"

#import <dlfcn.h>


STIOHIDEventCreateData_t STIOHIDEventCreateData = NULL;
STIOHIDEventCreateWithBytes_t STIOHIDEventCreateWithBytes = NULL;

STIOHIDEventSystemClientCreate_t STIOHIDEventSystemClientCreate = NULL;
STIOHIDEventSystemClientScheduleWithRunLoop_t STIOHIDEventSystemClientScheduleWithRunLoop = NULL;
STIOHIDEventSystemClientDispatchEvent_t STIOHIDEventSystemClientDispatchEvent = NULL;

STIOHIDEventGetAttributeData_t STIOHIDEventGetAttributeData = NULL;
STIOHIDEventGetIntegerValue_t STIOHIDEventGetIntegerValue = NULL;
STIOHIDEventSetIntegerValue_t STIOHIDEventSetIntegerValue = NULL;
STIOHIDEventGetFloatValue_t STIOHIDEventGetFloatValue = NULL;
STIOHIDEventSetFloatValue_t STIOHIDEventSetFloatValue = NULL;

__attribute__((constructor))
void STIOHIDEventInit(void) {
    STIOHIDEventSystemClientCreate = dlsym(RTLD_DEFAULT, "IOHIDEventSystemClientCreate");
    STIOHIDEventSystemClientScheduleWithRunLoop = dlsym(RTLD_DEFAULT, "IOHIDEventSystemClientScheduleWithRunLoop");
    STIOHIDEventSystemClientDispatchEvent = dlsym(RTLD_DEFAULT, "IOHIDEventSystemClientDispatchEvent");

    STIOHIDEventCreateWithBytes = dlsym(RTLD_DEFAULT, "IOHIDEventCreateWithBytes");
    STIOHIDEventCreateData = dlsym(RTLD_DEFAULT, "IOHIDEventCreateData");
    STIOHIDEventGetAttributeData = dlsym(RTLD_DEFAULT, "IOHIDEventGetAttributeData");
    STIOHIDEventGetIntegerValue = dlsym(RTLD_DEFAULT, "IOHIDEventGetIntegerValue");
    STIOHIDEventSetIntegerValue = dlsym(RTLD_DEFAULT, "IOHIDEventSetIntegerValue");
    STIOHIDEventGetFloatValue = dlsym(RTLD_DEFAULT, "IOHIDEventGetFloatValue");
    STIOHIDEventSetFloatValue = dlsym(RTLD_DEFAULT, "IOHIDEventSetFloatValue");
}
