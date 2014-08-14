//
//  PPLocationFetcher.h
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/13/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPLocationFetcherDelegate.h"
#import <CoreLocation/CoreLocation.h>

extern NSString *const PPLocationFetcherError;

typedef enum : short {
    PPLocationFetcherAuthorizationFailedErrorCode,
} PPLocationFetcherErrorCode;

@interface PPLocationFetcher : NSObject

/**
    @description The delegate object to send location update events to.
 */
@property (nonatomic, weak) id <PPLocationFetcherDelegate> delegate;

/**
    @description The minimum distance (measured in meters) a device must
                 move horizontally before a location update event is
                 generated.
    @note The default value of this property is 0.0 meters.
 */
@property (nonatomic) CLLocationDistance distanceFilter;

/**
    @description The desired accuracy of the location data.
    @note The receiver does its best to achieve the requested accuracy;
          however, the actual accuracy is not guaranteed. The default
          value of this property is kCLLocationAccuracyThreeKilometers.
 */
@property (nonatomic) CLLocationAccuracy desiredAccuracy;

/**
    @description Fetches device's current location. It attempts to fetch a
                 location with best accuracy, but if a location with the
                 specified desired accuracy is not available after few attempts,
                 it returns a location with lower accuracy.
 */
- (void)startFetchingCurrentLocation;

/**
    @description Stops the generation of location updates.
    @discussion Call this method whenever your code no longer needs to
 receive location events.
 */
- (void)stopFetchingCurrentLocation;

/**
    @description Fetches current street address for the device.
    @discussion If you need street address in addition to location data
                call this method instead of @startFetchingCurrentLocation.
 */
- (void)startFetchingCurrentStreetAddress;

/**
    @description Stops the generation of street address updates.
    @discussion Call this method whenever your code no longer needs to
                receive new street address events.
 */
- (void)stopFetchingStreetAddress;

/**
    @description Starts the generation of updates based on significant
                 location changes.
    @see "Starting the Significant-Change Location Service" section in
         "Location and Maps Programming Guide" from Apple.
 */
- (void)startMonitoringSignificantLocationChanges;

/**
    @description Stops the generation of updates based on significant
                 location changes.
    @see "Starting the Significant-Change Location Service" section in
         "Location and Maps Programming Guide" from Apple.
 */
- (void)stopMonitoringSignificantLocationChanges;

/**
    @description Checks if the location service is turned on and if the 
                 user has authorized the app to use it.
    @return YES if the app can access locaiton services otherwise NO.
 */
- (BOOL)authorizedToAccessLocationServices;

@end
