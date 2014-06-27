//
//  RZFuelStation.m
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZFuelStation.h"
#import "RZImportable.h"

#import "NSString+FuelType.h"

@interface RZFuelStation () <RZImportable>

@end

@implementation RZFuelStation

- (NSString *)title
{
    return [NSString descriptionForFuelType:self.fuelType];
}

- (NSString *)subtitle
{
    return [self.stationName copy];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (BOOL)isEqual:(RZFuelStation *)other
{
    if ([other isKindOfClass:[RZFuelStation class]] == NO) {
        return NO;
    }
    return [self.stationID isEqualToString:other.stationID];
}

+ (NSDictionary *)customMappings
{
    static NSDictionary *s_customMappings = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_customMappings = @{ @"id" : @"stationID"};
    });
    
    return s_customMappings;
}

#pragma mark - RZImportable

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"ev_connector_types"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            self.evConnectorTypes = value;
        }
        return NO;
    }
    else if ([key isEqualToString:@"fuel_type_code"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.fuelType = [value fuelType];
        }
        return NO;
    }
    else if ([key isEqualToString:@"open_date"]) { // For now we are just ignoring this.
        return NO;
    }
    else if ([key isEqualToString:@"ev_network_ids"]) { // Don't care about this.
        return NO;
    }
    return YES;
}


@end
