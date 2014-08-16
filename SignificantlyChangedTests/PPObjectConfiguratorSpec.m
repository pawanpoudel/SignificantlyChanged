//
//  PPObjectConfiguratorSpec.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/15/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "Kiwi.h"
#import "PPObjectConfigurator.h"
#import "PPLocationManager.h"
#import "PPLocationFetcher.h"
#import "PPGeocoder.h"

SPEC_BEGIN(PPObjectConfiguratorSpec)

describe(@"PPObjectConfigurator", ^{
    __block PPObjectConfigurator *objectConfigurator = nil;
    
    beforeEach(^{
        objectConfigurator = [[PPObjectConfigurator alloc] init];
    });
    
    describe(@"#sharedInstance", ^{
        it(@"returns the same instance every time", ^{
            PPObjectConfigurator *objectConfigurator1 = [PPObjectConfigurator sharedInstance];
            PPObjectConfigurator *objectConfigurator2 = [PPObjectConfigurator sharedInstance];
            [[objectConfigurator1 should] beIdenticalTo:objectConfigurator2];
        });
    });
    
    describe(@".locationManager", ^{
        __block PPLocationManager *locationManager = nil;
        
        beforeEach(^{
            locationManager = [objectConfigurator locationManager];
        });
        
        it(@"location manager isn't nil", ^{
            [[locationManager shouldNot] beNil];
        });
        
        it(@"location manager has a location fetcher", ^{
            [[locationManager.locationFetcher shouldNot] beNil];
        });
        
        it(@"location fetcher has a geocoder", ^{
            [[locationManager.locationFetcher.geocoder shouldNot] beNil];
        });
        
        it(@"location manager is the delegate of location fetcher", ^{
            PPLocationManager *delegate = (PPLocationManager *)locationManager.locationFetcher.delegate;
            [[delegate should] equal:locationManager];
        });
    });
});

SPEC_END
