//
//  PPGeocoder.h
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/14/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

@class CLLocation;
@class CLPlacemark;

@interface PPGeocoder : NSObject

/*!
    @description A block to be called when a geocoding request is complete.
    @param placemark A CLPlacemark object with the information for the location.
    @param streetAddress A NSString object containing the street address. It
                         contains the street address, city, zip code and country.
    @param error Contains a pointer to an error object (if any) indicating why
                 the street address was not returned.
 */
typedef void (^PPReverseGeocodeCompletionHandler)(CLPlacemark *placemark, NSString *streetAddress, NSError *error);

/*!
    @description Submits a reverse-geocoding request for the specified location.
    @param location The CLLocation object containing the coordinate data to look up.
    @param completionHandler A block object containing the code to execute at the
                             end of the request. This code is called whether the
                             request is successful or not.
 */
- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(PPReverseGeocodeCompletionHandler)completionHandler;

@end
