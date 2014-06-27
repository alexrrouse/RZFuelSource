//
//  RZDirectionService.m
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZDirectionService.h"
#import "RZFuelWebService.h"

@import MapKit;

@implementation RZDirectionService

+ (instancetype)sharedInstance
{
    static RZDirectionService *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[self alloc] init];
    });
    return s_manager;
}

- (void)directionsFromDirectionRequest:(MKDirectionsRequest *)request withCompletionBlock:(RZDirectionsServiceLineStringBlock)completion
{
    // WHYYYYY APPLE WHYYYYY
    MKDirectionsRequest * newRequest = [[MKDirectionsRequest alloc] init];
    newRequest.transportType = MKDirectionsTransportTypeAutomobile;
    newRequest.requestsAlternateRoutes = NO;
    newRequest.source = request.source;
    newRequest.destination = request.destination;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        MKDirections *drivingDirections = [[MKDirections alloc] initWithRequest:newRequest];

        [drivingDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error == nil)
            {
                NSArray *routes = [response routes];
                MKRoute *route = [response.routes firstObject];
                
                NSMutableString *lineString = [NSMutableString stringWithString:@"LINESTRING("];
                NSUInteger pointCount = route.polyline.pointCount;
                
                //allocate a C array to hold this many points/coordinates...
                CLLocationCoordinate2D *routeCoordinates
                = malloc(pointCount * sizeof(CLLocationCoordinate2D));
                
                //get the coordinates (all of them)...
                [route.polyline getCoordinates:routeCoordinates
                                         range:NSMakeRange(0, pointCount)];
                
                //this part just shows how to use the results...
                NSLog(@"route pointCount = %d", pointCount);

                CLLocation *lastGoodLocation = [[CLLocation alloc] initWithLatitude:routeCoordinates[0].latitude longitude:routeCoordinates[0].longitude];
                CLLocationCoordinate2D coord = lastGoodLocation.coordinate;
                [lineString appendFormat:@"%f %f,", coord.longitude, coord.latitude];

                NSInteger pointTotal = 0;
                CGFloat maxDistanceInMeters = 8000;
                for (int c=0; c < pointCount; c++)
                {
                    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:routeCoordinates[c].latitude longitude:routeCoordinates[c].longitude];
                    if ([lastGoodLocation distanceFromLocation:newLocation] > maxDistanceInMeters || (c == pointCount-1) )
                    {
                        CLLocationCoordinate2D coord = newLocation.coordinate;
                        [lineString appendFormat:@"%f %f%@", coord.longitude, coord.latitude, ((c == pointCount-1) ? @"" : @",")];
                        lastGoodLocation = newLocation;
                        pointTotal++;
                    }
                }
                [lineString appendString:@")"];
                
                NSLog(@"LineString: %@", lineString);
                NSLog(@"OldPoints:%d - ActualPoints: %d",pointCount, pointTotal);
                //free the memory used by the C array when done with it...
                free(routeCoordinates);
                

                //@"LINESTRING(-74.0 40.7, -87.63 41.87, -104.98 39.76)"
                if (completion)
                {
                    completion(lineString, route, error);
                }
                
            }
        }];

//    });
    
}
@end
