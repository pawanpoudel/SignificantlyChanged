//
//  PPObjectConfigurator.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/15/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPObjectConfigurator.h"
#import "PPLocationManager.h"
#import "PPLocationFetcher.h"
#import "PPGeocoder.h"

@implementation PPObjectConfigurator

+ (PPObjectConfigurator *)sharedInstance {
    static PPObjectConfigurator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (PPLocationManager *)locationManager {
    PPLocationManager *manager = [[PPLocationManager alloc] init];
    manager.locationFetcher = [self locationFetcher];
    manager.locationFetcher.delegate = manager;
    
    return manager;
}

- (PPLocationFetcher *)locationFetcher {
    PPLocationFetcher *locationFetcher = [[PPLocationFetcher alloc] init];
    locationFetcher.geocoder = [[PPGeocoder alloc] init];
    
    return locationFetcher;
}

@end
