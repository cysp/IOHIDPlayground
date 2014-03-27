//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHIDEVENTFIELD_H
#define STIOHIDEVENTFIELD_H

#import "STIOHIDEventType.h"


#define STIOHIDEventFieldBase(type) (type << 16)

typedef uint32_t STIOHIDEventField;

enum {
    STIOHIDEventFieldDigitizerX = STIOHIDEventFieldBase(STIOHIDEventTypeDigitizer),
    STIOHIDEventFieldDigitizerY,
    STIOHIDEventFieldDigitizerZ,
    STIOHIDEventFieldDigitizerButtonMask,
    STIOHIDEventFieldDigitizerType,
    STIOHIDEventFieldDigitizerIndex,
    STIOHIDEventFieldDigitizerIdentity,
    STIOHIDEventFieldDigitizerEventMask,
    STIOHIDEventFieldDigitizerRange,
    STIOHIDEventFieldDigitizerTouch,
    STIOHIDEventFieldDigitizerPressure,
    STIOHIDEventFieldDigitizerAuxiliaryPressure, //BarrelPressure
    STIOHIDEventFieldDigitizerTwist,
    STIOHIDEventFieldDigitizerTiltX,
    STIOHIDEventFieldDigitizerTiltY,
    STIOHIDEventFieldDigitizerAltitude,
    STIOHIDEventFieldDigitizerAzimuth,
    STIOHIDEventFieldDigitizerQuality,
    STIOHIDEventFieldDigitizerDensity,
    STIOHIDEventFieldDigitizerIrregularity,
    STIOHIDEventFieldDigitizerMajorRadius,
    STIOHIDEventFieldDigitizerMinorRadius,
    STIOHIDEventFieldDigitizerCollection,
    STIOHIDEventFieldDigitizerCollectionChord,
    STIOHIDEventFieldDigitizerChildEventMask,
    STIOHIDEventFieldDigitizerIsDisplayIntegrated
};

#undef STIOHIDEventFieldBase

#endif
