//
//  PPLocationFetcher.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/13/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPLocationFetcher.h"

const struct PPLocationFetcherConstants {
    CLLocationAccuracy desiredAccuracy;
    CLLocationAccuracy somewhatDesiredAccuracy;
    CLLocationAccuracy lowestAcceptableAccuracy;
    CLLocationDistance defaultDistanceFilter;
    NSTimeInterval acceptableLocationAge;
    
} PPLocationFetcherConstants = {
    .desiredAccuracy = 100.0,               // meters
    .somewhatDesiredAccuracy = 300.0,       // meters
    .lowestAcceptableAccuracy = 500.0,      // meters
    .defaultDistanceFilter = 0.0,           // meters
    .acceptableLocationAge = 180.0          // seconds
};

NSString *const PPLocationFetcherError = @"PPLocationFetcherError";

@interface PPLocationFetcher () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *clLocationManager;
@property (nonatomic) CLLocation *currentLocation;

@property (nonatomic) BOOL shouldFetchStreetAddress;
@property (nonatomic) NSInteger numberOfAttemptsToGetAccurateLocation;

@end

@implementation PPLocationFetcher

#pragma mark - Accessors

- (void)setDelegate:(id <PPLocationFetcherDelegate>)newDelegate {
    if (newDelegate &&
        ([newDelegate conformsToProtocol:@protocol(PPLocationFetcherDelegate)] == NO))
    {
        NSString *reason = @"Delegate object does not conform to PPLocationFetcherDelegate protocol";
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                         reason:reason
                                                       userInfo:nil];
        [exception raise];
    }
    
    _delegate = newDelegate;
}

- (CLLocationManager *)clLocationManager {
    if (_clLocationManager == nil) {
        _clLocationManager = [[CLLocationManager alloc] init];
        _clLocationManager.pausesLocationUpdatesAutomatically = NO;
        _clLocationManager.desiredAccuracy = self.desiredAccuracy;
        _clLocationManager.distanceFilter = self.distanceFilter;
        _clLocationManager.delegate = self;
    }
    return _clLocationManager;
}

#pragma mark - Initializers

- (id)init {
    self = [super init];
    if (self) {
        _distanceFilter = PPLocationFetcherConstants.defaultDistanceFilter;
        _desiredAccuracy = PPLocationFetcherConstants.lowestAcceptableAccuracy;
    }
    return self;
}

#pragma mark - Fetch location

- (void)startFetchingCurrentLocation {
    if ([self authorizedToAccessLocationServices]) {
        self.shouldFetchStreetAddress = NO;
        [self.clLocationManager startUpdatingLocation];
    }
}

- (void)stopFetchingLocation {
    [self.clLocationManager stopUpdatingLocation];
}

#pragma mark - Fetch street address

- (void)startFetchingCurrentStreetAddress {
    if ([self authorizedToAccessLocationServices]) {
        self.shouldFetchStreetAddress = YES;
        [self.clLocationManager startUpdatingLocation];
    }
}

- (void)stopFetchingStreetAddress {
    [self stopFetchingLocation];
}

#pragma mark - Location Authorization

- (BOOL)authorizedToAccessLocationServices {
    NSString *errorMessage = nil;
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        errorMessage = NSLocalizedString(@"Location Services is disabled. Enable it from Settings app to retrieve your location.", nil);
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        errorMessage = NSLocalizedString(@"Access to Location Services for this app is denied. Authorize this app from Settings app to retrieve your location.", nil);
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        errorMessage = NSLocalizedString(@"Access to Location Services for this app is restricted. Remove parental control from General > Restrictions view in Settings app.", nil);
    }
    
    if (errorMessage) {
        [self tellDelegateAboutAuthorizationError:errorMessage];
        return NO;
    }
    
    return YES;
}

- (void)tellDelegateAboutAuthorizationError:(NSString *)errorMessage {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: errorMessage };
    NSError *error = [NSError errorWithDomain:PPLocationFetcherError
                                         code:PPLocationFetcherAuthorizationFailedErrorCode
                                     userInfo:userInfo];

    if ([self.delegate respondsToSelector:@selector(locationFetcher:fetchingLocationDidFailWithError:)]) {
        [self.delegate locationFetcher:self fetchingLocationDidFailWithError:error];
    }
    
    if ([self.delegate respondsToSelector:@selector(locationFetcher:fetchingStreetAddressDidFailWithError:)]) {
        [self.delegate locationFetcher:self fetchingStreetAddressDidFailWithError:error];
    }
}

@end
