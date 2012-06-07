//
//  MultiplayerMatchSetupViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-07.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "MultiplayerMatchSetupViewController.h"

#import "GCHelper.h"

@implementation MultiplayerMatchSetupViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)onJoinGameButtonTap:(id)sender {
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
}

#pragma mark GCHelperDelegate

- (void)matchStarted {
    NSLog(@"Match started!");
}

- (void)matchEnded {
    NSLog(@"Match ended!");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Match received data!");
}

@end
