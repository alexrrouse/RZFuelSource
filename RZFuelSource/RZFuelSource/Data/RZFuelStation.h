//
//  RZFuelStation.h
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZFuelStation : NSObject

@property (nonatomic, strong) NSString *accessDaysTime;
@property (nonatomic, strong) NSString *bdBlends;
@property (nonatomic, strong) NSString *cardsAccepted;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *dateLastConfirmed;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *e85BlenderPump;
@property (nonatomic, strong) NSArray  *evConnectorTypes;
@property (nonatomic, strong) NSString *evDCFastNum;
@property (nonatomic, strong) NSString *evLevel1EvseNum;
@property (nonatomic, strong) NSString *evLevel2EvseNum;
@property (nonatomic, strong) NSString *evNetwork;
@property (nonatomic, strong) NSDictionary  *evNetworkIds;
@property (nonatomic, strong) NSString *evNetworkWeb;
@property (nonatomic, strong) NSString *evOtherEvse;
@property (nonatomic, strong) NSDate   *expectedDate;
@property (nonatomic, strong) NSString *fuelTypeCode;
@property (nonatomic, strong) NSString *geocodeStatus;
@property (nonatomic, strong) NSString *groupsWithAccessCode;
@property (nonatomic, strong) NSString *hyStatusLink;
@property (nonatomic, strong) NSString *stationID; // Need custom mapping here
@property (nonatomic, strong) NSString *intersectionDirections;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *lpgPrimary;
@property (nonatomic, strong) NSString *ngFillTypeCode;
@property (nonatomic, strong) NSString *ngPSI;
@property (nonatomic, strong) NSString *ngVehicleClass;
@property (nonatomic, strong) NSDate   *openDate;
@property (nonatomic, strong) NSString *ownerTypeCode;
@property (nonatomic, strong) NSString *plus4;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *stationPhone;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *zip;


@end
