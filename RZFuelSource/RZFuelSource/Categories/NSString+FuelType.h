//
//  NSString+FuelType.h
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZFuelType.h"

OBJC_EXTERN NSString* const kRZFuelAPIFuelTypeBio;
OBJC_EXTERN NSString* const kRZFuelAPIFuelTypeCompressedNaturalGas;
OBJC_EXTERN NSString* const kRZFuelAPIFuelTypeEthanol;
OBJC_EXTERN NSString* const kRZFuelAPIFuelTypeElectric;
OBJC_EXTERN NSString* const kRZFuelAPIFuelTypeHydrogen;
OBJC_EXTERN NSString* const kRZFuelAPIFuelTypeLiqiudNaturalGas;
OBJC_EXTERN NSString* const kRZFuelAPIFuelTypePetroleum;

@interface NSString (FuelType)

- (RZFuelType)fuelType;

@end
