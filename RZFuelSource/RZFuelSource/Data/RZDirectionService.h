//
//  RZDirectionService.h
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKRoute;

typedef void(^RZDirectionsServiceLineStringBlock)(NSString *lineString, MKRoute *route, NSError *error);

@class MKDirectionsRequest;
@interface RZDirectionService : NSObject

+ (instancetype)sharedInstance;

- (void)directionsFromDirectionRequest:(MKDirectionsRequest *)request withCompletionBlock:(RZDirectionsServiceLineStringBlock)completion;

@end
