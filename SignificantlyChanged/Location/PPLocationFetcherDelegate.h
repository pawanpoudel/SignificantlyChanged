//
//  PPLocationFetcherDelegate.h
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/13/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//s

@class CLLocation;
@class CLPlacemark;
@class PPLocationFetcher;

@protocol PPLocationFetcherDelegate <NSObject>

@optional

/**
    @description Tells the delegate that new location data is available.
    @param fetcher The location fetcher object that fetched the location.
    @param location The CLLocation object containing the location data.
                    The accuracy of this location could be lower than desired.
                    Location fetcher settles for lower accuracy after a few attempts
                    if a location with higher accuracy is not available.
 */
- (void)locationFetcher:(PPLocationFetcher *)fetcher
    didReceiveCurrentLocation:(CLLocation *)location;

/**
    @description Tells the delegate that the location fetcher was unable
                 to fetch the current location.
    @param fetcher The location fetcher object reporting the error.
    @param error The error object containing the reason the current location
                 could not be fetched.
 */
- (void)locationFetcher:(PPLocationFetcher *)fetcher
    fetchingLocationDidFailWithError:(NSError *)error;

/**
    @description Tells the delegate that current street address is available.
    @param fetcher The location fetcher object that fetched the street address.
    @param address A NSString object containing the street address.
    @param location A CLLocation object containing the location data used to
                    determine the street address.
 */
- (void)locationFetcher:(PPLocationFetcher *)fetcher
didReceiveStreetAddress:(NSString *)address
            forLocation:(CLLocation *)location;

/**
    @description Tells the delegate that the location fetcher was unable to
                 fetch current street address.
    @param fetcher The location fetcher object reporting the error.
    @param error The error object containing a reason the current street
                 address could not be fetched.
 */
- (void)locationFetcher:(PPLocationFetcher *)fetcher
    fetchingStreetAddressDidFailWithError:(NSError *)error;


/**
    @description Tells the delegate that a CLPlacemark for the current location
                 is available.
    @param fetcher The location fetcher object that fetched the placemark object.
    @param placemark The CLPlacemark of the current location.
 */
- (void)locationFetcher:(PPLocationFetcher *)fetcher
    didReceivePlacemark:(CLPlacemark *)placemark;

@end
