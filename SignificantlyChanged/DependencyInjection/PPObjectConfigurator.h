//
//  PPObjectConfigurator.h
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/15/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

@class PPLocationManager;

@interface PPObjectConfigurator : NSObject

/**
    @description Returns a shared instance of PPObjectConfigurator.
    @discussion Call this method instead of alloc, init if you need
                the same instance that was created before. For most
                use cases, you shouldn't have to create multiple
                instances of this class since we generally need only
                one object configurator for the entire app.
 */
+ (PPObjectConfigurator *)sharedInstance;

/**
    @description A fully configured PPLocationManager object.
 */
- (PPLocationManager *)locationManager;

@end
