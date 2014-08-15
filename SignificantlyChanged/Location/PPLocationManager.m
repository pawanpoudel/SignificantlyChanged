//
//  PPLocationManager.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/13/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPLocationManager.h"
#import "PPLocationFetcher.h"
#import "PPGeocoder.h"

static const NSTimeInterval kDurationForKeepingAppAliveInBackground = 900; // 15 mins

@interface PPLocationManager ()

@property (nonatomic) NSTimer *timerForKeepingAppAliveInBackground;

@end

@implementation PPLocationManager

#pragma mark - Initializers

+ (PPLocationFetcher *)locationFetcher {
    PPLocationFetcher *locationFetcher = [[PPLocationFetcher alloc] init];
    locationFetcher.geocoder = [[PPGeocoder alloc] init];
    
    return locationFetcher;
}

+ (instancetype)sharedInstance {
    static PPLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        locationManager = [[self alloc] init];
        locationManager.locationFetcher = [self locationFetcher];
    });
    
    return locationManager;
}

#pragma mark - App lifecycle

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance]
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    if ([self appLaunchedDueToLocationChangeNotification:notification] &&
        [self isLocationBackgroundModeEnabled])
    {
        [self keepAppAliveByListeningToLocationUpdatesInBackground];
    }
}

- (BOOL)appLaunchedDueToLocationChangeNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo allKeys] containsObject:UIApplicationLaunchOptionsLocationKey]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isLocationBackgroundModeEnabled {
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSArray *backgroundModes = appInfo[@"UIBackgroundModes"];
    return [backgroundModes containsObject:@"location"];
}

#pragma mark - Keep app alive in background

- (void)keepAppAliveByListeningToLocationUpdatesInBackground {
    self.locationFetcher.desiredAccuracy = [self lowestLocationAccuracy];
    [self.locationFetcher startFetchingCurrentLocation];
    [self startKeepAliveTimer];
    
    [self startMonitoringSignificantLocationChanges];
}

- (CLLocationAccuracy)lowestLocationAccuracy {
    return kCLLocationAccuracyThreeKilometers;
}

- (void)startKeepAliveTimer {
    if (self.timerForKeepingAppAliveInBackground == nil) {
        self.timerForKeepingAppAliveInBackground = [NSTimer scheduledTimerWithTimeInterval:kDurationForKeepingAppAliveInBackground
                                                                                    target:self
                                                                                  selector:@selector(stopListeningToLocationUpdates)
                                                                                  userInfo:nil
                                                                                   repeats:NO];
    }
}

- (void)stopListeningToLocationUpdates {
    [self.timerForKeepingAppAliveInBackground invalidate];
    self.timerForKeepingAppAliveInBackground = nil;
    [self.locationFetcher stopFetchingCurrentLocation];
}

#pragma mark - Significant location change

- (void)startMonitoringSignificantLocationChanges {
    [self.locationFetcher startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringSignificantLocationChanges {
    [self.locationFetcher stopMonitoringSignificantLocationChanges];
}

#pragma mark - MDLocationFetcher delegate methods

- (void)locationFetcher:(PPLocationFetcher *)fetcher
    didReceiveCurrentLocation:(CLLocation *)location
{
    DebugLog(@"Received a location update.");
}

- (void)locationFetcher:(PPLocationFetcher *)fetcher
    fetchingLocationDidFailWithError:(NSError *)error
{
    DebugLog(@"Location fetcher failed to fetch a location: %@", [error localizedDescription]);
}

@end
