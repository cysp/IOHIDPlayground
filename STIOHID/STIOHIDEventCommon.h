//
//  STIOHIDEventCommon.h
//  STIOHIDPlayground
//
//  Created by Scott Talbot on 27/03/2014.
//  Copyright (c) 2014 Scott Talbot. All rights reserved.
//

#ifndef STIOHIDPlayground_STIOHIDEventCommon_h
#define STIOHIDPlayground_STIOHIDEventCommon_h

struct __attribute__((packed)) STIOFixed {
    uint32_t lo : 16;
    uint32_t hi : 16;
};

static inline double STIOFixedToDouble(struct STIOFixed a) {
    return a.hi + ((double)a.lo / (1 << 16));
};


enum STIOHIDEventType {
    STIOHIDEventTypeNULL,                    // 0
    STIOHIDEventTypeVendorDefined,
    STIOHIDEventTypeButton,
    STIOHIDEventTypeKeyboard,
    STIOHIDEventTypeTranslation,
    STIOHIDEventTypeRotation,                // 5
    STIOHIDEventTypeScroll,
    STIOHIDEventTypeScale,
    STIOHIDEventTypeZoom,
    STIOHIDEventTypeVelocity,
    STIOHIDEventTypeOrientation,             // 10
    STIOHIDEventTypeDigitizer,
    STIOHIDEventTypeAmbientLightSensor,
    STIOHIDEventTypeAccelerometer,
    STIOHIDEventTypeProximity,
    STIOHIDEventTypeTemperature,             // 15
    STIOHIDEventTypeNavigationSwipe,
    STIOHIDEventTypePointer,
    STIOHIDEventTypeProgress,
    STIOHIDEventTypeMultiAxisPointer,
    STIOHIDEventTypeGyro,                    // 20
    STIOHIDEventTypeCompass,
    STIOHIDEventTypeZoomToggle,
    STIOHIDEventTypeDockSwipe, // just like STIOHIDEventTypeNavigationSwipe, but intended for consumption by Dock
    STIOHIDEventTypeSymbolicHotKey,
    STIOHIDEventTypePower,                   // 25
    STIOHIDEventTypeReserved1,
    STIOHIDEventTypeFluidTouchGesture, // This will eventually superseed Navagation and Dock swipes
    STIOHIDEventTypeBoundaryScroll,
    STIOHIDEventTypeBiometric,
};

enum STIOHIDEventOption {
    STIOHIDEventOptionIsAbsolute     = 1 << 0,
    STIOHIDEventOptionIsCollection   = 1 << 1,
    STIOHIDEventOptionIsPixelUnits   = 1 << 2,
    STIOHIDEventOptionIsCenterOrigin = 1 << 3,
    STIOHIDEventOptionIsBuiltIn      = 1 << 4,
};


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
