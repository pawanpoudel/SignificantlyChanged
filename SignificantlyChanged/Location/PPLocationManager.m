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
    // TODO: Find out if the app was launched due to significant location change.
    // TODO: Check to see if the location background mode is enabled or not.
}

@end
