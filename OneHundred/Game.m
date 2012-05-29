//
//  Game.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "ComputerPlayer.h"
#import "Game.h"

@implementation Game

@synthesize targetPoints, startingMoney, players, playersWithBids;

- (id)initWithTargetPoints:(int)points startingMoney:(int)money {
    self = [super init];

    if (self) {
        [self setTargetPoints:points];
        [self setStartingMoney:money];
        [self setPlayers:[NSMutableArray array]];
        [self setPlayers:[NSMutableSet set]];
    }

    return self;
}

- (void)addPlayer:(Player *)player {
    [[self players] addObject:player];
}

- (void)startNewRound {
    [self clearPlayersWithBids];
    [self obtainPlayerBids];
}

- (void)clearPlayersWithBids {
    // Empty the set of players who have bid.
    [[self playersWithBids] removeAllObjects];
}

- (void)obtainPlayerBids {
    // Ask all of the players to make their bids.
    for (Player *player in [self players]) {
        [player setBidRequested:YES];

        // Computer players will make their bids right away.
        if ([player isKindOfClass:[ComputerPlayer class]]) {
            [(ComputerPlayer *)player computeAndSubmitBid];
        }
    }
}

- (void)acceptBidForPlayer:(Player *)player {
    // Add the player to the set of players who have bid.
    [playersWithBids addObject:[player name]];

    // If all players have bid, compute results.
    if ([playersWithBids count] == [players count]) {
        [self computeResults];
    }
}

- (void)computeResults {
    int highestBid = -1;
    Player *highestBidder = nil;

    // Determine the highest bidder.
    for (Player *player in [self players]) {
        [player spendBid];

        if ([player currentBid] > highestBid) {
            highestBid = [player currentBid];
            highestBidder = player;
        } else if ([player currentBid] == highestBid) {
            // In case of tie, no one wins!
            highestBidder = nil;
        }
    }

    // If there's an outright highest bidder, he's won a point!  If not, start a new round.
    if (highestBidder != nil) {
        [highestBidder addPoint];

        // If the highest bidder has enough points, end the game.  Otherwise, start a new round.
        if ([highestBidder points] >= targetPoints) {
            [self declareWinner:highestBidder];
        } else {
            [self startNewRound];
        }
    } else {
        [self startNewRound];
    }
}

- (void)declareWinner:(Player *)winner {
    // Declare the winner!
}

@end
