//
//  PPObjectConfigurator.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/15/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "PPObjectConfigurator.h"

@implementation PPObjectConfigurator

+ (PPObjectConfigurator *)sharedInstance {
    static PPObjectConfigurator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
