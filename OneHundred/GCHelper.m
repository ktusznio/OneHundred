//
//  GCHelper.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-05.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper

@synthesize gameCenterAvailable;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;

+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }

    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // Check for presence of GKLocalPlayer API.
    Class gcClass = NSClassFromString(@"GKLocalPlayer");

    // Check if the device is running iOS 4.1 or later.
    NSString *requiredSystemVersion = @"4.1";
    NSString *currentSystemVersion = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = [currentSystemVersion compare:requiredSystemVersion
                                                    options:NSNumericSearch] != NSOrderedAscending;

    return gcClass && osVersionSupported;
}

- (id)init {
    self = [super init];

    if (self) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter addObserver:self
                                   selector:@selector(authenticationChanged)
                                       name:GKPlayerAuthenticationDidChangeNotificationName
                                     object:nil];
        }
    }

    return self;
}

- (void)authenticationChanged {
    if ([[GKLocalPlayer localPlayer] isAuthenticated] && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = YES;
    } else if (![[GKLocalPlayer localPlayer] isAuthenticated] && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = NO;
    }
}

#pragma mark User functions

- (void)authenticateLocalUser {
    if (!gameCenterAvailable) {
        return;
    }

    NSLog(@"Authenticating local user...");
    if (![[GKLocalPlayer localPlayer] isAuthenticated]) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}


@end
