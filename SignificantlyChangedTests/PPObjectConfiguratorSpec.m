//
//  PPObjectConfiguratorSpec.m
//  SignificantlyChanged
//
//  Created by PAWAN POUDEL on 8/15/14.
//  Copyright (c) 2014 Pawan Poudel. All rights reserved.
//

#import "Kiwi.h"
#import "PPObjectConfigurator.h"

SPEC_BEGIN(PPObjectConfiguratorSpec)

describe(@"PPObjectConfigurator", ^{
    describe(@"#sharedInstance", ^{
        it(@"returns the same instance every time", ^{
            PPObjectConfigurator *objectConfigurator1 = [PPObjectConfigurator sharedInstance];
            PPObjectConfigurator *objectConfigurator2 = [PPObjectConfigurator sharedInstance];
            [[objectConfigurator1 should] beIdenticalTo:objectConfigurator2];
        });
    });
});

SPEC_END
