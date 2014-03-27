//  Copyright (c) 2014 Scott Talbot. All rights reserved.

#ifndef STIOHID_STIOHIDTYPES_H
#define STIOHID_STIOHIDTYPES_H

struct __attribute__((packed)) STIOFixed {
    uint32_t lo : 16;
    uint32_t hi : 16;
};

#endif
