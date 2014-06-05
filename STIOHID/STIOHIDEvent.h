//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHID_STIOHIDEVENT_H
#define STIOHID_STIOHIDEVENT_H

#import <Foundation/Foundation.h>

#import <STIOHID/STIOHID.h>
#import <STIOHID/STCFRuntime.h>
#import <STIOHID/STIOHIDEventCommon.h>
#import <STIOHID/STIOHIDEventData.h>


// 0x63 -> phase?

typedef CFTypeRef STIOHIDEventRef;
typedef uint32_t STIOHIDEventType;
struct __attribute__((packed)) STIOHIDEventBase {
    struct STCFRuntimeBase base;	// 0, 4
    uint64_t timeStamp;	// 8, c
    uint64_t senderId;
    enum STIOHIDEventOption options : 32;	// 18
    uint32_t typeMask;	// 1c
    uintptr_t attributeDataLength;
    uintptr_t attributeDataBytes;
    uint64_t context;
#if __LP64__
    uintptr_t x;
#endif
    CFMutableArrayRef children;	// 20
    STIOHIDEventRef parent;	// 24
    uintptr_t unknown;
};

struct __attribute__((packed)) STIOHIDEvent {
    struct STIOHIDEventBase base;
    uint32_t            size;
    STIOHIDEventType    type;
    uint32_t            recordOptions;
    uint32_t            depth;
};

struct __attribute__((packed)) STIOHIDAxisEvent {
    struct STIOHIDEvent base;
    struct {
        struct STIOFixed x;
        struct STIOFixed y;
        struct STIOFixed z;
    } position;
};

struct __attribute__((packed)) STIOHIDDigitizerEvent {
    struct STIOHIDAxisEvent base;
    uint32_t transducerIndex;
    enum STIOHIDDigitizerTransducerType transducerType : 32;
    uint32_t identity;
    enum STIOHIDDigitizerEventType eventMask : 32;
    enum STIOHIDDigitizerEventType childEventMask : 32;
    uint32_t buttonMask;

    struct STIOFixed pressure;
    struct STIOFixed auxPressure;
    struct STIOFixed twist;

    enum STIOHIDDigitizerOrientationType orientationType : 32;
};

struct __attribute__((packed)) STIOHIDDigitizerTiltEvent {
    struct STIOHIDDigitizerEvent base;
    struct {
        struct STIOFixed x;
        struct STIOFixed y;
    } orientation;
};

struct __attribute__((packed)) STIOHIDDigitizerPolarEvent {
    struct STIOHIDDigitizerEvent base;
    struct {
        struct STIOFixed altitude;
        struct STIOFixed azimuth;
    } orientation;
};

struct __attribute__((packed)) STIOHIDDigitizerQualityEvent {
    struct STIOHIDDigitizerEvent base;
    struct {
        struct STIOFixed quality;
        struct STIOFixed density;
        struct STIOFixed irregularity;
        struct STIOFixed majorRadius;
        struct STIOFixed minorRadius;
    } orientation;
};



struct __attribute__((packed)) STIOHIDEventAttributeData {
    uint32_t unknown1; // dunno, always 0x02?
    uint32_t unknown2; // dunno, always 0x0c?
    uint32_t contextId;
    uint32_t unknown4; // systemGesturePossible
    uint32_t unknown5; // dunno, always 0?
    uint32_t unknown6; // dunno, always 0?
    uint32_t unknown7; // dunno, always 0?
};
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDEventAttributeData) == 28, "");
#endif


typedef float STIOHIDFloat;

//#import "STIOHIDEventFunctions.h"

#endif