//
//  PPAppDelegate.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/13/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PPObjectConfigurator.h"
#import "PPLocationManager.h"

@interface PPAppDelegate ()

@property (nonatomic) PPLocationManager *locationManager;

@end

@implementation PPAppDelegate

#pragma mark - Accessors

- (PPLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[PPObjectConfigurator sharedInstance] locationManager];
    }
    
    return _locationManager;
}

#pragma mark - App lifecycle

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.locationManager promptForLocationPermissions];
    return YES;
}

@end
