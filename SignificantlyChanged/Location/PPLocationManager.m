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
        // TODO: Keep the app alive by listening to location updates in background.
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

@end
