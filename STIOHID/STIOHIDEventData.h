//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHID_STIOHIDEVENTDATA_H
#define STIOHID_STIOHIDEVENTDATA_H

struct __attribute__((packed)) STIOHIDSystemQueueEventData {
    uint64_t timestamp;
    uint64_t senderID;
    uint32_t options;
    uint32_t attributeDataLength;
    uint32_t eventCount;
};
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDSystemQueueEventData) == 28, "");
#endif

struct __attribute__((packed)) STIOHIDEventData {
    uint32_t length;
    enum STIOHIDEventType type : 32;
    union {
        struct {
            enum STIOHIDEventOption genericOptions : 16;
            uint32_t eventOptions : 16; // eventFlags?
        };
        uint32_t options;
    } options;
    uint32_t depth;
};
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDEventData) == 16, "");
#endif

struct __attribute__((packed)) STIOHIDAxisEventData {
    struct STIOHIDEventData base;
    struct {
        struct STIOFixed x;
        struct STIOFixed y;
        struct STIOFixed z;
    } position;
};
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDAxisEventData) == 28, "");
#endif

struct __attribute__((packed)) STIOHIDDigitizerEventData {
    struct STIOHIDAxisEventData base;
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
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDDigitizerEventData) == 68, "");
#endif

struct __attribute__((packed)) STIOHIDDigitizerQualityOrientation {
    struct STIOFixed quality;
    struct STIOFixed density;
    struct STIOFixed irregularity;
    struct STIOFixed minorRadius;
    struct STIOFixed majorRadius;
};

struct __attribute__((packed)) STIOHIDDigitizerQualityEventData {
    struct STIOHIDDigitizerEventData base;
    struct STIOHIDDigitizerQualityOrientation orientation;
};
#if __has_feature(c_static_assert)
_Static_assert(sizeof(struct STIOHIDDigitizerQualityEventData) == 88, "");
#endif


#endif
