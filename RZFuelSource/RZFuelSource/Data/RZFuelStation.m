//
//  RZFuelStation.m
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZFuelStation.h"

@implementation RZFuelStation
- (NSString *)title
{
    return [self.stationName copy];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

@end
