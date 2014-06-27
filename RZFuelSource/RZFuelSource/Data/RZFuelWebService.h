//
//  RZFuelWebService.h
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import Foundation;

#import "RZFuelStation.h"

typedef void(^RZFueldWebServiceItemListBlock)(NSArray *objects, NSError *error);

@interface RZFuelWebService : NSObject

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)fetchNearbyLocationWithLat:(CGFloat)lat lon:(CGFloat)lon completionBlock:(RZFueldWebServiceItemListBlock)completion;

@end
