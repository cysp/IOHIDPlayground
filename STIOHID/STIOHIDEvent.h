//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>

#import <STIOHID/STCFRuntime.h>
#import <STIOHID/STIOHIDTypes.h>
#import <STIOHID/STIOHIDEventType.h>
#import <STIOHID/STIOHIDEventField.h>


enum STIOHIDEventOption {
    STIOHIDEventOptionIsAbsolute     = 1 << 0,
    STIOHIDEventOptionIsCollection   = 1 << 1,
    STIOHIDEventOptionIsPixelUnits   = 1 << 2,
    STIOHIDEventOptionIsCenterOrigin = 1 << 3,
    STIOHIDEventOptionIsBuiltIn      = 1 << 4,
};

// 0x63 -> phase?

typedef CFTypeRef STIOHIDEventRef;
typedef uint32_t STIOHIDEventType;
struct __attribute__((packed)) STIOHIDEventBase {
    struct STCFRuntimeBase base;	// 0, 4
    uint64_t timeStamp;	// 8, c
    uint64_t senderId;
    enum STIOHIDEventOption options : 32;	// 18
    uint32_t typeMask;	// 1c
    uint32_t attributeDataLength;
    uintptr_t attributeDataBytes;
    uint64_t context;
    CFMutableArrayRef children;	// 20
    STIOHIDEventRef parent;	// 24
    uint32_t unknown;
};

struct __attribute__((packed)) STIOHIDEvent {
    struct STIOHIDEventBase base;
    uint32_t            size;
    STIOHIDEventType    type;
    uint32_t            recordOptions;
    uint32_t            depth;
};

struct __attribute__((packed)) STIOHIDAxisEvent {
    struct STIOHIDEventBase base;
    struct {
        struct STIOFixed x;
        struct STIOFixed y;
        struct STIOFixed z;
    } position;
};

enum STIOHIDDigitizerEventOptions {
    STIOHIDTransducerRange               = 0x0001,
    STIOHIDTransducerTouch               = 0x0002,
    STIOHIDTransducerInvert              = 0x0004,
    STIOHIDTransducerDisplayIntegrated   = 0x0008
};

enum STIOHIDDigitizerTransducerType {
    STIOHIDDigitizerTransducerTypeStylus = 0,
    STIOHIDDigitizerTransducerTypePuck = 1,
    STIOHIDDigitizerTransducerTypeFinger = 2,
    STIOHIDDigitizerTransducerTypeHand = 3,
};

enum STIOHIDDigitizerEventType {
    STIOHIDDigitizerEventRange = 0x1,
    STIOHIDDigitizerEventTouch = 0x2,
    STIOHIDDigitizerEventPosition = 0x4,
    STIOHIDDigitizerEventStop = 0x8,
    STIOHIDDigitizerEventPeak = 0x10,
    STIOHIDDigitizerEventIdentity = 0x20,
    STIOHIDDigitizerEventAttribute = 0x40,
    STIOHIDDigitizerEventCancel = 0x80,
    STIOHIDDigitizerEventStart = 0x100,
    STIOHIDDigitizerEventResting = 0x200,
    STIOHIDDigitizerEventFromEdgeFlat = 0x400,
    STIOHIDDigitizerEventFromEdgeTip = 0x800,
    STIOHIDDigitizerEventFromCorner = 0x1000,
    STIOHIDDigitizerEventSwipeUp    = 0x01000000,
    STIOHIDDigitizerEventSwipeDown  = 0x02000000,
    STIOHIDDigitizerEventSwipeLeft  = 0x04000000,
    STIOHIDDigitizerEventSwipeRight = 0x08000000,
};

enum STIOHIDDigitizerOrientationType {
    STIOHIDDigitizerOrientationTypeTilt = 0,
    STIOHIDDigitizerOrientationTypePolar = 1,
    STIOHIDDigitizerOrientationTypeQuality = 2,
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
    uint32_t unknown4; // isFirstEvent?
    uint32_t unknown5; // dunno, always 0?
    uint32_t unknown6; // dunno, always 0?
    uint32_t unknown7; // dunno, always 0?
};
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDEventAttributeData) == 28, "");
#endif


typedef float STIOHIDFloat;

#import "STIOHIDEventFunctions.h"
