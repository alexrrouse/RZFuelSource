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

NSString* const kRZFuelFuelTypeBioDescription                     = @"Biodiesel";
NSString* const kRZFuelFuelTypeCompressedNaturalGasDescription    = @"Compressed Natural Gas";
NSString* const kRZFuelFuelTypeEthanolDescription                 = @"Ethanol";
NSString* const kRZFuelFuelTypeElectricDescription                = @"Electric";
NSString* const kRZFuelFuelTypeHydrogenDescription                = @"Hydrogen";
NSString* const kRZFuelFuelTypeLiqiudNaturalGasDescription        = @"Liquefied Natural Gas";
NSString* const kRZFuelFuelTypePetroleumDescription               = @"Liquefied Petroleum Gas";

NSString* const kRZFuelFuelTypeBioShortDescription                     = @"Bio";
NSString* const kRZFuelFuelTypeCompressedNaturalGasShortDescription    = @"CNG";
NSString* const kRZFuelFuelTypeEthanolShortDescription                 = @"Ethanol";
NSString* const kRZFuelFuelTypeElectricShortDescription                = @"Electric";
NSString* const kRZFuelFuelTypeHydrogenShortDescription                = @"Hydrogen";
NSString* const kRZFuelFuelTypeLiqiudNaturalGasShortDescription        = @"LNG";
NSString* const kRZFuelFuelTypePetroleumShortDescription               = @"LPG";

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

<<<<<<< HEAD
+ (NSString *)descriptionForFuelType:(RZFuelType)fuelType
{
    NSString *description = @"";
    
    switch (fuelType) {
        case RZFuelTypeBioDiesel:
            description = kRZFuelFuelTypeBioDescription;
            break;
        case RZFuelTypeElectric:
            description = kRZFuelFuelTypeElectricDescription;
            break;
        case RZFuelTypeCompressedNaturalGas:
            description = kRZFuelFuelTypeCompressedNaturalGasDescription;
            break;
        case RZFuelTypeEthanol:
            description = kRZFuelFuelTypeEthanolDescription;
            break;
        case RZFuelTypeHydrogen:
            description = kRZFuelFuelTypeHydrogenDescription;
            break;
        case RZFuelTypeLiquidNaturalGas:
            description = kRZFuelFuelTypeLiqiudNaturalGasDescription;
            break;
        case RZFuelTypePetroleumGas:
            description = kRZFuelFuelTypePetroleumDescription;
            break;
        case RZFuelTypeUnknown:
            description = @"";
            break;
    }
    
    return description;
}

+ (NSString *)shortDescriptionForFuelType:(RZFuelType)fuelType
{
    NSString *description = @"";
    
    switch (fuelType) {
        case RZFuelTypeBioDiesel:
            description = kRZFuelFuelTypeBioShortDescription;
            break;
        case RZFuelTypeElectric:
            description = kRZFuelFuelTypeElectricShortDescription;
            break;
        case RZFuelTypeCompressedNaturalGas:
            description = kRZFuelFuelTypeCompressedNaturalGasShortDescription;
            break;
        case RZFuelTypeEthanol:
            description = kRZFuelFuelTypeEthanolShortDescription;
            break;
        case RZFuelTypeHydrogen:
            description = kRZFuelFuelTypeHydrogenShortDescription;
            break;
        case RZFuelTypeLiquidNaturalGas:
            description = kRZFuelFuelTypeLiqiudNaturalGasShortDescription;
            break;
        case RZFuelTypePetroleumGas:
            description = kRZFuelFuelTypePetroleumShortDescription;
            break;
        case RZFuelTypeUnknown:
            description = @"";
            break;
    }
    
    return description;
=======
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
>>>>>>> origin/master
}

@end
