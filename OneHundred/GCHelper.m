//
//  GCHelper.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-05.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper

@synthesize delegate, gameCenterAvailable, presentingViewController, match;

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

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GCHelperDelegate>)aDelegate {
    if (!gameCenterAvailable) {
        return;
    }

    matchStarted = NO;
    [self setMatch:nil];
    [self setPresentingViewController:viewController];
    [self setDelegate:aDelegate];
    [presentingViewController dismissModalViewControllerAnimated:NO];

    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    [request setMinPlayers:minPlayers];
    [request setMaxPlayers:maxPlayers];

    GKMatchmakerViewController *matchmakerViewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    [matchmakerViewController setMatchmakerDelegate:self];

    [presentingViewController presentModalViewController:matchmakerViewController
                                                animated:YES];
}

#pragma mark GKMatchmakerViewControllerDelegate

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    // The user has cancelled matchmaking.
    [presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController
                didFailWithError:(NSError *)error {
    // Matchmaking has failed with an error.
    [presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController
                    didFindMatch:(GKMatch *)theMatch {
    // A peer-to-peer match has been found, the game should start.
    [presentingViewController dismissModalViewControllerAnimated:YES];
    [self setMatch:theMatch];
    [match setDelegate:self];

    if (!matchStarted && [match expectedPlayerCount] == 0) {
        NSLog(@"Ready to start match!");
    }
}

#pragma mark GKMatchDelegate

- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    // The match received data sent from the player.
    if (match != theMatch) {
        return;
    }

    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    // The player state changed (eg. connected or disconnected)
    if (match != theMatch) {
        return;
    }

    switch (state) {
        case GKPlayerStateConnected:
            // Handle a new player connection.
            NSLog(@"Player connected!");

            if (!matchStarted && [theMatch expectedPlayerCount] == 0) {
                NSLog(@"Ready to start match!");
            }

            break;
        case GKPlayerStateDisconnected:
            // A player just disconnected.
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }
}

- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    // The match was unable to connect with the player due to an error.

    if (match != theMatch) {
        return;
    }

    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    // The match was unable to be established with any players due to an error.

    if (match != theMatch) {
        return;
    }

    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

@end
