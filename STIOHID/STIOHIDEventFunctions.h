//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHID_STIOHIDEVENTFUNCTIONS_H
#define STIOHID_STIOHIDEVENTFUNCTIONS_H

#import <CoreFoundation/CoreFoundation.h>
#import <STIOHID/STIOHID.h>


typedef CFTypeRef STIOHIDEventSystemClientRef;
typedef STIOHIDEventSystemClientRef (*STIOHIDEventSystemClientCreate_t)(CFAllocatorRef allocator);
extern STIOHIDEventSystemClientCreate_t STIOHIDEventSystemClientCreate;

typedef void (*STIOHIDEventSystemClientDispatchEvent_t)(STIOHIDEventSystemClientRef client, STIOHIDEventRef event);
extern STIOHIDEventSystemClientDispatchEvent_t STIOHIDEventSystemClientDispatchEvent;


typedef STIOHIDEventRef (*STIOHIDEventCreateWithBytes_t)(CFAllocatorRef allocator, void *bytes, size_t length);
extern STIOHIDEventCreateWithBytes_t STIOHIDEventCreateWithBytes;

typedef CFDataRef (*STIOHIDEventCreateData_t)(CFAllocatorRef allocator, STIOHIDEventRef event);
extern STIOHIDEventCreateData_t STIOHIDEventCreateData;

typedef CFDataRef (*STIOHIDEventGetAttributeData_t)(STIOHIDEventRef event);
extern STIOHIDEventGetAttributeData_t STIOHIDEventGetAttributeData;

typedef uint32_t (*STIOHIDEventGetIntegerValue_t)(STIOHIDEventRef event, STIOHIDEventField field);
extern STIOHIDEventGetIntegerValue_t STIOHIDEventGetIntegerValue;
typedef void (*STIOHIDEventSetIntegerValue_t)(STIOHIDEventRef event, STIOHIDEventField field, uint32_t value);
extern STIOHIDEventSetIntegerValue_t STIOHIDEventSetIntegerValue;

typedef float (*STIOHIDEventGetFloatValue_t)(STIOHIDEventRef event, STIOHIDEventField field);
extern STIOHIDEventGetFloatValue_t STIOHIDEventGetFloatValue;
typedef void (*STIOHIDEventSetFloatValue_t)(STIOHIDEventRef event, STIOHIDEventField field, float value);
extern STIOHIDEventSetFloatValue_t STIOHIDEventSetFloatValue;

#endif
