//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHID_STCFRUNTIME_H
#define STIOHID_STCFRUNTIME_H

#include <objc/objc.h>


struct STCFRuntimeBase {
    Class cfisa;
    uint8_t cfinfo[4];
#if defined(__LP64__) && (__LP64__ != 0)
    uint32_t rc;
#endif
};

#endif
