//
//  RZFuelWebService.m
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZFuelWebService.h"
#import "AFNetworking.h"

// Categories
#import "NSString+FuelType.h"
#import "NSObject+RZImport.h"

static NSString * const kRZFuelServiceAPIKey                    = @"6PORx4DHgSnXVwiI4t1moSTEwITctYM5tSHtg274";

static NSString * const kRZFuelServiceAPIKeyRequestAPIKey       = @"api_key";

// Nearby
static NSString * const kRZFuelServiceAPIRequestKeyLatitude     = @"latitude";
static NSString * const kRZFuelServiceAPIRequestKeyLongitude    = @"longitude";
static NSString * const kRZFuelServiceAPIRequestKeyRadius       = @"radius";
static NSString * const kRZFuelServiceAPIRequestKeyStatus       = @"status";
static NSString * const kRZFuelServiceAPIRequestKeyAccess       = @"access";
static NSString * const kRZFuelServiceAPIRequestKeyFuelType     = @"fuel_type";
static NSString * const kRZFuelServiceAPIRequestKeyLimit        = @"limit";

// Route
static NSString * const kRZFuelServiceAPIRequestKeyRoute        = @"route";
static NSString * const kRZFuelServiceAPIRequestKeyDistance     = @"distance";


static NSString * const kRZFuelServiceAPIBaseURL        = @"http://developer.nrel.gov/api/";
static NSString * const kRZFuelServiceAPINearestURL     = @"alt-fuel-stations/v1/nearest.json";
static NSString * const kRZFuelServiceAPIRouteURL       = @"alt-fuel-stations/v1/nearby-route.json";

@interface RZFuelWebService ()

@property (nonatomic, strong) AFHTTPSessionManager* apiSessionManager;
@property (nonatomic, strong) AFJSONRequestSerializer* jsonRequestSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer* jsonResponseSerializer;

@end

@implementation RZFuelWebService

+ (instancetype)sharedInstance
{
    static RZFuelWebService *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[self alloc] init];
    });
    return s_manager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer {
    if (_jsonRequestSerializer == nil) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        [_jsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    return _jsonRequestSerializer;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (_jsonResponseSerializer == nil)
    {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

- (AFHTTPSessionManager *)apiSessionManager
{
    if (_apiSessionManager == nil) {
        NSURLSessionConfiguration *apiSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _apiSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://developer.nrel.gov/api/"]
                                                      sessionConfiguration:apiSessionConfig];
        
        
        [_apiSessionManager setRequestSerializer:[self jsonRequestSerializer]];
        
        NSMutableIndexSet *acceptableStatusCodes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        //        [acceptableStatusCodes addIndex:303]; // not-modified is acceptable
        
        [self.jsonResponseSerializer setAcceptableStatusCodes:acceptableStatusCodes];
        [_apiSessionManager setResponseSerializer:self.jsonResponseSerializer];
    }
    
    return _apiSessionManager;
}

- (NSURLSessionDataTask *)taskForRequest:(NSURLRequest *)request enqueue:(BOOL)enqueue completion:(RZFueldWebServiceItemListBlock)completion {
    __block NSURLSessionDataTask *task = [self.apiSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error == nil)
        {

            NSArray *objects = [RZFuelStation rzi_objectsFromArray:[responseObject objectForKey:@"fuel_stations"] withMappings:[RZFuelStation customMappings]];
            
            if (completion)
            {
                completion(objects, nil);
            }
        }
        else
        {
            if (completion != nil)
            {
                completion(nil, error);
            }
        }
    }];
    
    if (enqueue) {
        [task resume];
    }
    
    return task;
}

- (NSURLSessionDataTask *)fetchNearbyLocationWithLat:(CGFloat)lat lon:(CGFloat)lon completionBlock:(RZFueldWebServiceItemListBlock)completion
{
    return [self fetchNearbyLocationWithFuelType:RZFuelTypeAll lat:lat lon:lon completionBlock:completion];
}

- (NSURLSessionDataTask *)fetchNearbyLocationWithFuelType:(RZFuelType)fuelType lat:(CGFloat)lat lon:(CGFloat)lon completionBlock:(RZFueldWebServiceItemListBlock)completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{kRZFuelServiceAPIKeyRequestAPIKey : kRZFuelServiceAPIKey,
                                     kRZFuelServiceAPIRequestKeyFuelType : [NSString stringFromFuelType:fuelType],
                                     kRZFuelServiceAPIRequestKeyRadius : @(50),
                                     kRZFuelServiceAPIRequestKeyStatus : @"E",
                                     kRZFuelServiceAPIRequestKeyAccess: @"public",
                                     kRZFuelServiceAPIRequestKeyLimit : @(10),
                                     kRZFuelServiceAPIRequestKeyLatitude : @(lat),
                                     kRZFuelServiceAPIRequestKeyLongitude : @(lon) }
                                   ];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kRZFuelServiceAPIBaseURL,kRZFuelServiceAPINearestURL];
    
    NSMutableURLRequest *request = [self.jsonRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:params error:NULL ];
    
    return [self taskForRequest:request enqueue:YES completion:completion];
}

- (NSURLSessionDataTask *)fetchNearbyLocationsWithFuelType:(RZFuelType)fuelType route:(NSString *)routeString completionBlock:(RZFueldWebServiceItemListBlock)completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
                                   @{kRZFuelServiceAPIKeyRequestAPIKey : kRZFuelServiceAPIKey,
                                     kRZFuelServiceAPIRequestKeyFuelType : [NSString stringFromFuelType:fuelType],
                                     kRZFuelServiceAPIRequestKeyDistance : @(10),
                                     kRZFuelServiceAPIRequestKeyStatus : @"E",
                                     kRZFuelServiceAPIRequestKeyAccess : @"public",
                                     kRZFuelServiceAPIRequestKeyRoute : routeString
                                     }
                                   ];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kRZFuelServiceAPIBaseURL,kRZFuelServiceAPIRouteURL];
    
    NSMutableURLRequest *request = [self.jsonRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:params error:NULL ];
    
    return [self taskForRequest:request enqueue:YES completion:completion];
}



@end
