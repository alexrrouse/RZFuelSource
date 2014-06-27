//
//  RZFuelType.h
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#ifndef RZFuelSource_RZFuelType_h
#define RZFuelSource_RZFuelType_h

typedef NS_ENUM (NSUInteger, RZFuelType) {
    RZFuelTypeUnknown = 0,
    RZFuelTypeAll,
    RZFuelTypeBioDiesel,
    RZFuelTypeCompressedNaturalGas,
    RZFuelTypeEthanol,
    RZFuelTypeElectric,
    RZFuelTypeHydrogen,
    RZFuelTypeLiquidNaturalGas,
    RZFuelTypePetroleumGas
};

OBJC_EXTERN const NSUInteger kRZFuelTypeFirstObject;
OBJC_EXTERN const NSUInteger kRZFuelTypeLastObject;
OBJC_EXTERN const NSUInteger kRZFuelTypeNumObjects;

#endif
