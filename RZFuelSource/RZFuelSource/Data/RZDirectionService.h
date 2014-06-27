//
//  RZDirectionService.h
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKDirectionsRequest;
@interface RZDirectionService : NSObject

+ (instancetype)sharedInstance;

- (void)directionsFromDirectionRequest:(MKDirectionsRequest *)request;

@end
