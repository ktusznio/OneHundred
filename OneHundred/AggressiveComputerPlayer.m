//
//  AggressiveComputerPlayer.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-02.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "AggressiveComputerPlayer.h"

#import "AppDelegate.h"
#import "Game.h"

@implementation AggressiveComputerPlayer

- (id)initWithName:(NSString *)playerName {
    self = [super initWithName:playerName];
    
    if (self) {
        
    }
    
    return self;
}

- (void)computeAndSubmitBid {
    // Get the current game.
    Game *currentGame = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentGame];
    
    // Find the highest bid made so far.
    int maxBid = -1;
    for (Player *player in [currentGame players]) {
        if (player != self) {
            NSMutableArray *playerBids = [[currentGame playerBiddingHistory] objectForKey:[player name]];
            for (NSNumber *bid in playerBids) {
                if ([bid intValue] > maxBid) {
                    maxBid = [bid intValue];
                }
            }
        }
    }
    
    // If we've found a bid, add one to it. Otherwise, play it cool and bid zero.
    int bid = (maxBid > -1) ? maxBid + 1 : 0;
    
    // If we can't afford the bid, then bid whatever's left.
    bid = MIN(bid, [self money]);

    // Submit the bid.
    [self submitBid:bid];
}


@end
