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

#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [locations enumerateObjectsWithOptions:NSEnumerationReverse
                                usingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
                                    if ([self isLocationAcceptable:location]) {
                                        [self foundNewLocation:location];
                                        *stop = YES;
                                    }
                                }];
}

- (BOOL)isLocationAcceptable:(CLLocation *)location {
    if ([self isLocationCached:location]) {
        // This is cached location. We don't want it.
        // Keep listening for a fresh location.
        return NO;
    }
    
    if ([self isLocationDesired:location] ||
        ((self.numberOfAttemptsToGetAccurateLocation > 3) && [self isLocationSomewhatDesired:location]) ||
        ((self.numberOfAttemptsToGetAccurateLocation > 5 && [self isLocationLeastDesired:location])))
    {
        return YES;
    }
    
    self.numberOfAttemptsToGetAccurateLocation++;
    return NO;
}

- (BOOL)isLocationCached:(CLLocation *)location {
    // First location returned may contain data that was
    // cached from previous usage of the location service
    NSTimeInterval locationAge = [[NSDate date] timeIntervalSinceDate:location.timestamp];
    if (locationAge > PPLocationFetcherConstants.acceptableLocationAge) {
        return YES;
    }
    return NO;
}

- (BOOL)isLocationDesired:(CLLocation *)location {
    if (location.horizontalAccuracy <= PPLocationFetcherConstants.desiredAccuracy) {
        return YES;
    }
    return NO;
}

- (BOOL)isLocationSomewhatDesired:(CLLocation *)location {
    if (location.horizontalAccuracy <= PPLocationFetcherConstants.somewhatDesiredAccuracy) {
        return YES;
    }
    return NO;
}

- (BOOL)isLocationLeastDesired:(CLLocation *)location {
    if (location.horizontalAccuracy <= PPLocationFetcherConstants.lowestAcceptableAccuracy) {
        return YES;
    }
    return NO;
}

- (void)foundNewLocation:(CLLocation *)newLocation {
    self.numberOfAttemptsToGetAccurateLocation = 0;
    self.currentLocation = newLocation;
    
    if ([self.delegate respondsToSelector:@selector(locationFetcher:didReceiveCurrentLocation:)]) {
        [self.delegate locationFetcher:self didReceiveCurrentLocation:self.currentLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorLocationUnknown) {
        // Location is currently unknown, but CLLocationManager will keep trying.
        // So, ignore this error.
        return;
    }
    
    self.currentLocation = nil;
    
    if ([self.delegate respondsToSelector:@selector(locationFetcher:fetchingLocationDidFailWithError:)]) {
        [self.delegate locationFetcher:self fetchingLocationDidFailWithError:error];
    }
}

@end
