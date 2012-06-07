//
//  MultiplayerMatchSetupViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-07.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "MultiplayerMatchSetupViewController.h"

#import "AppDelegate.h"
#import "BiddingViewController.h"
#import "MultiplayerGame.h"
#import "GCHelper.h"

@implementation MultiplayerMatchSetupViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)onJoinGameButtonTap:(id)sender {
    // Create the bidding view controller.
    BiddingViewController *biddingViewController = [[BiddingViewController alloc] init];

    // Create a multiplayer game.
    MultiplayerGame *game = [[MultiplayerGame alloc] initWithTargetPoints:6 startingMoney:100 delegate:biddingViewController];

    // Find a match.
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:game];
}

@end
