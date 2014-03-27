//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHIDEVENTFUNCTIONS_H
#define STIOHIDEVENTFUNCTIONS_H


typedef STIOHIDEventRef (*STIOHIDEventCreateDigitizerFingerEventWithQuality_t)(CFAllocatorRef allocator, uint64_t timeStamp, uint32_t index, uint32_t identity, uint32_t eventMask, STIOHIDFloat x, STIOHIDFloat y, STIOHIDFloat z, /*STIOHIDFloat tipPressure,*/ STIOHIDFloat twist, Boolean range, Boolean touch, STIOOptionBits options);

//IOHIDEventRef IOHIDEventCreateKeyboardEvent(CFAllocatorRef allocator, uint64_t time, uint16_t page, uint16_t usage, Boolean down, IOHIDEventOptionBits flags);

typedef STIOHIDEventRef (*STIOHIDEventCreateDigitizerEvent_t)(CFAllocatorRef allocator, uint64_t timeStamp, enum STIOHIDDigitizerTransducerType type, uint32_t index, uint32_t identity, uint32_t eventMask, uint32_t buttonMask, STIOHIDFloat x, STIOHIDFloat y, STIOHIDFloat z, STIOHIDFloat tipPressure, STIOHIDFloat barrelPressure, Boolean range, Boolean touch, STIOOptionBits options);

//IOHIDEventRef IOHIDEventCreateDigitizerFingerEvent(CFAllocatorRef allocator, uint64_t timeStamp, uint32_t index, uint32_t identity, uint32_t eventMask, IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist, Boolean range, Boolean touch, IOOptionBits options);

typedef void (*STIOHIDEventAppendEvent_t)(STIOHIDEventRef parent, STIOHIDEventRef child);

//void IOHIDEventSetIntegerValue(IOHIDEventRef event, IOHIDEventField field, int value);
//void IOHIDEventSetSenderID(IOHIDEventRef event, uint64_t sender);

typedef CFTypeRef STIOHIDEventSystemClientRef;
typedef STIOHIDEventSystemClientRef (*STIOHIDEventSystemClientCreate_t)(CFAllocatorRef allocator);

typedef void (*STIOHIDEventSystemClientDispatchEvent_t)(STIOHIDEventSystemClientRef client, STIOHIDEventRef event);
//void IOHIDEventSystemConnectionDispatchEvent(IOHIDEventSystemConnectionRef connection, IOHIDEventRef event);


typedef CFDataRef (*STIOHIDEventCreateData_t)(CFAllocatorRef allocator, STIOHIDEventRef event);
extern STIOHIDEventCreateData_t STIOHIDEventCreateData;
typedef STIOHIDEventRef (*STIOHIDEventCreateWithBytes_t)(CFAllocatorRef allocator, void *bytes, size_t length);
extern STIOHIDEventCreateWithBytes_t STIOHIDEventCreateWithBytes;

extern STIOHIDEventCreateDigitizerFingerEventWithQuality_t STIOHIDEventCreateDigitizerFingerEventWithQuality;
extern STIOHIDEventCreateDigitizerEvent_t STIOHIDEventCreateDigitizerEvent;
extern STIOHIDEventAppendEvent_t STIOHIDEventAppendEvent;
extern STIOHIDEventSystemClientCreate_t STIOHIDEventSystemClientCreate;
extern STIOHIDEventSystemClientDispatchEvent_t STIOHIDEventSystemClientDispatchEvent;


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

//000000000002b2f4 T _IOHIDEventGetAttributeDataLength
//000000000002b2fe T _IOHIDEventGetAttributeDataPtr
//000000000002ad4b T _IOHIDEventGetChildren
//000000000002b08a T _IOHIDEventGetDataLength
//0000000000028dbc T _IOHIDEventGetEvent
//0000000000028f38 T _IOHIDEventGetEventFlags
//0000000000028dcb T _IOHIDEventGetEventWithOptions
//000000000002ab4c T _IOHIDEventGetFloatMultiple
//000000000002ab8f T _IOHIDEventGetFloatMultipleWithOptions
//0000000000029644 T _IOHIDEventGetFloatValue
//0000000000029653 T _IOHIDEventGetFloatValueWithOptions
//000000000002aabc T _IOHIDEventGetIntegerMultiple
//000000000002aafd T _IOHIDEventGetIntegerMultipleWithOptions
//0000000000029078 T _IOHIDEventGetIntegerValue
//0000000000029087 T _IOHIDEventGetIntegerValueWithOptions
//0000000000028ed1 T _IOHIDEventGetLatency
//000000000002ad41 T _IOHIDEventGetParent
//0000000000028f24 T _IOHIDEventGetPhase
//000000000002b38d T _IOHIDEventGetPolicy
//0000000000028f6a T _IOHIDEventGetPosition
//0000000000028f87 T _IOHIDEventGetPositionWithOptions
//0000000000028f60 T _IOHIDEventGetSenderID
//0000000000028ebd T _IOHIDEventGetTimeStamp
//0000000000028e7c T _IOHIDEventGetType
//000000000002806c T _IOHIDEventGetTypeID
//000000000002b34f T _IOHIDEventGetTypeString
//000000000002ad04 T _IOHIDEventGetVendorDefinedData

#endif
