//
//  PPGeocoder.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/14/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPGeocoder.h"
@import CoreLocation;

@interface PPGeocoder()

@property (nonatomic) CLGeocoder *geocoder;

@end

@implementation PPGeocoder

#pragma mark - Accessors

- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

#pragma mark - Reverse geocoding

- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(PPReverseGeocodeCompletionHandler)completionHandler
{
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            NSString *streetAddress = nil;
                            if (error == nil) {
                                streetAddress = [self streetAddressFromPlacemark:placemarks[0]];
                            }
                            
                            if (completionHandler) {
                                completionHandler(placemarks[0], streetAddress, error);
                            }
                        }];
}

- (NSString *)streetAddressFromPlacemark:(CLPlacemark *)placemark {
    NSMutableString *address = [[NSMutableString alloc] init];
    if (placemark.subThoroughfare)
        [address appendFormat:@"%@ ", placemark.subThoroughfare];
    
    if (placemark.thoroughfare)
        [address appendFormat:@"%@ ", placemark.thoroughfare];
    
    if (placemark.locality)
        [address appendFormat:@"%@ ", placemark.locality];
    
    if (placemark.administrativeArea)
        [address appendFormat:@"%@ ", placemark.administrativeArea];
    
    if (placemark.postalCode)
        [address appendFormat:@"%@ ", placemark.postalCode];
    
    if (placemark.country)
        [address appendFormat:@"%@", placemark.country];
    
    return address;
}

@end
