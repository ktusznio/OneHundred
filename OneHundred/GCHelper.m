//
//  GCHelper.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-05.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "GCHelper.h"

#import "Message.h"

@implementation GCHelper

@synthesize delegate, gameCenterAvailable, players, presentingViewController, match, pendingInvitation, pendingPlayersToInvite;

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

        // Set up an invitation handler.
        [[GKMatchmaker sharedMatchmaker] setInviteHandler:^(GKInvite *invitation, NSArray *playersToInvite) {
            NSLog(@"Received invitation.");
            [self setPendingInvitation:invitation];
            [self setPendingPlayersToInvite:playersToInvite];
            [delegate receivedInvite];
        }];
    } else if (![[GKLocalPlayer localPlayer] isAuthenticated] && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = NO;
    }
}

- (void)lookupPlayers {
    NSLog(@"Looking up %d players...", [[match playerIDs] count]);
    [GKPlayer loadPlayersForIdentifiers:[match playerIDs]
                  withCompletionHandler:^(NSArray *thePlayers, NSError *error) {
        if (error) {
            NSLog(@"Error retrieving player info: %@", [error localizedDescription]);
            matchStarted = NO;
            [delegate matchEnded];
        } else {
            // Populate the players dictionary.
            [self setPlayers:[NSMutableDictionary dictionaryWithCapacity:[thePlayers count]]];
            for (GKPlayer *player in thePlayers) {
                NSLog(@"Found player: %@", [player alias]);
                [players setObject:player forKey:[player playerID]];
            }

            // Notify the delegate that the match can begin.
            matchStarted = YES;
            [delegate matchStarted];
        }
    }];
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

    GKMatchmakerViewController *matchmakerViewController;
    if ([self pendingInvitation]) {
        matchmakerViewController = [[GKMatchmakerViewController alloc] initWithInvite:pendingInvitation];
    } else {
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        [request setMinPlayers:minPlayers];
        [request setMaxPlayers:maxPlayers];
        [request setPlayersToInvite:pendingPlayersToInvite];

        matchmakerViewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    }

    [matchmakerViewController setMatchmakerDelegate:self];

    [self setPendingInvitation:nil];
    [self setPendingPlayersToInvite:nil];

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
        [self lookupPlayers];
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
                [self lookupPlayers];
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
