//
//  PPLocationManager.h
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/13/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPLocationFetcherDelegate.h"

/**
    @description A façade providing access to the location subsystem.
                 PPLocationManager collects interfaces exposed by various
                 classes that provide highly specific location related
                 functionalities and exposes their behaviors via a high 
                 level interface.
 */
@interface PPLocationManager : NSObject <PPLocationFetcherDelegate>

/**
    @description A location fetcher object that fetches the current location
                 of the device through Location Services provided by iOS.
 */
@property (nonatomic) PPLocationFetcher *locationFetcher;

/**
    @description Starts the generation of updates based on significant
                 location changes.
    @see "Starting the Significant-Change Location Service" section
         in "Location and Maps Programming Guide" from Apple.
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
    @description Keep the app running through location background mode.
                 The primary purpose of this method is to not let iOS
                 suspend the app soon after it has been launched due
                 to the arrival of a significant location change or
                 region monitoring event.
    @discussion If the location background mode is not enabled, this 
                method doesn't do anything.
    @see "Getting Location Events in the Background" section in
         "Location and Maps Programming Guide" from Apple.
 */
- (void)keepAppAliveByListeningToLocationUpdatesInBackground;

/**
    @description Forces iOS to show the Location Services permission alert
                 view if the user hasn't given permission to this app already.
    @discussion  Ideally, this method shouldn't be called at all because it
                 is a bad practice to ask for permission from areas in app
                 that do not use location at all. The user might get confused
                 as to why the app is asking for permission. That being said, 
                 this method provides an easy way to show the permission alert
                 view if need arises.
 */
- (void)promptForLocationPermissions;

/**
    @description Check if the app has "location" as one of the background modes.
    @return YES if location is in the list of UIBackgroundModes otherwise NO.
 */
- (BOOL)isLocationBackgroundModeEnabled;

@end
