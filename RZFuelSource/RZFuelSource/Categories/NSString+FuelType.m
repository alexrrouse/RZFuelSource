//
//  NSString+FuelType.m
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSString+FuelType.h"
#import "RZFuelWebService.h"

/* From API
 
 BD     Biodiesel (B20 and above)
 CNG	Compressed Natural Gas
 E85	Ethanol (E85)
 ELEC	Electric
 HY     Hydrogen
 LNG	Liquefied Natural Gas
 LPG	Liquefied Petroleum Gas (Propane) */

NSString* const kRZFuelAPIFuelTypeAll                   = @"all";
NSString* const kRZFuelAPIFuelTypeBio                   = @"BD";
NSString* const kRZFuelAPIFuelTypeCompressedNaturalGas  = @"CNG";
NSString* const kRZFuelAPIFuelTypeEthanol               = @"E85";
NSString* const kRZFuelAPIFuelTypeElectric              = @"ELEC";
NSString* const kRZFuelAPIFuelTypeHydrogen              = @"HY";
NSString* const kRZFuelAPIFuelTypeLiqiudNaturalGas      = @"LNG";
NSString* const kRZFuelAPIFuelTypePetroleum             = @"LPG";

@implementation NSString (FuelType)

- (RZFuelType)fuelType
{
    RZFuelType fuelType = RZFuelTypeUnknown;
    
    if ([self isEqualToString:kRZFuelAPIFuelTypeAll]){
        fuelType = RZFuelTypeAll;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypeBio]) {
        fuelType = RZFuelTypeBioDiesel;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypeCompressedNaturalGas]) {
        fuelType = RZFuelTypeCompressedNaturalGas;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypeEthanol]) {
        fuelType = RZFuelTypeEthanol;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypeElectric]) {
        fuelType = RZFuelTypeElectric;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypeHydrogen]) {
        fuelType = RZFuelTypeHydrogen;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypeLiqiudNaturalGas]) {
        fuelType = RZFuelTypeLiquidNaturalGas;
    }
    else if ([self isEqualToString:kRZFuelAPIFuelTypePetroleum]) {
        fuelType = RZFuelTypePetroleumGas;
    }
    
    return fuelType;
}

+ (NSString *)stringFromFuelType:(RZFuelType)type
{
    NSString *ret = nil;
    switch (type) {
        case RZFuelTypeUnknown:
            ret = kRZFuelAPIFuelTypeAll;
            break;
        case RZFuelTypeAll:
            ret = kRZFuelAPIFuelTypeAll;
            break;
        case RZFuelTypeBioDiesel:
            ret = kRZFuelAPIFuelTypeBio;
            break;
        case RZFuelTypeCompressedNaturalGas:
            ret = kRZFuelAPIFuelTypeCompressedNaturalGas;
            break;
        case RZFuelTypeEthanol:
            ret = kRZFuelAPIFuelTypeEthanol;
            break;
        case RZFuelTypeElectric:
            ret = kRZFuelAPIFuelTypeElectric;
            break;
        case RZFuelTypeHydrogen:
            ret = kRZFuelAPIFuelTypeHydrogen;
            break;
        case RZFuelTypeLiquidNaturalGas:
            ret = kRZFuelAPIFuelTypeLiqiudNaturalGas;
            break;
        case RZFuelTypePetroleumGas:
            ret = kRZFuelAPIFuelTypePetroleum;
            break;
        default:
            break;
    }
    return ret;
}

@end
