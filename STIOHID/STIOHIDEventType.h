//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHID_STIOHIDEVENTTYPE_H
#define STIOHID_STIOHIDEVENTTYPE_H

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

#endif
