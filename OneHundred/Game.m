//
//  Game.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "Game.h"

#import "AppDelegate.h"
#import "ComputerPlayer.h"

@implementation Game

@synthesize delegate, targetPoints, startingMoney, players, playersWithBids, playerBiddingHistory;

- (id)initWithTargetPoints:(int)points
             startingMoney:(int)money
                  delegate:(id<GameDelegate>)aDelegate {
    self = [super init];

    if (self) {
        [self setTargetPoints:points];
        [self setStartingMoney:money];
        [self setDelegate:aDelegate];

        [self setPlayers:[NSMutableArray array]];
        [self setPlayersWithBids:[NSMutableSet set]];
        [self setPlayerBiddingHistory:[NSMutableDictionary dictionary]];
    }

    return self;
}

- (void)addPlayer:(Player *)player {
    [[self players] addObject:player];
    [[self playerBiddingHistory] setObject:[NSMutableArray array]
                                    forKey:[player name]];
}

- (void)startGame {
    [[self delegate] gameWillBegin];
    [self startNewRound];
}

- (void)startNewRound {
    [self clearPlayerBids];
    [self obtainComputerPlayerBids];
    [[self delegate] roundWillBegin];
}

- (void)clearPlayerBids {
    // Reset player bids.
    for (Player *player in [self players]) {
        [player setCurrentBid:0];
    }

    // Empty the set of players who have bid.
    [[self playersWithBids] removeAllObjects];
}

- (void)obtainComputerPlayerBids {
    // Ask computer players to make their bids.
    for (Player *player in [self players]) {
        if ([player isKindOfClass:[ComputerPlayer class]]) {
            [(ComputerPlayer *)player computeAndSubmitBid];
        }
    }
}

- (void)acceptBidForPlayer:(Player *)player {
    // Check that the bid is valid.
    int bid = [player currentBid];
    if (bid >= 0 && bid <= [player money]) {
        // Add the player to the set of players who have bid.
        [playersWithBids addObject:player];

        // If all players have bid, record their bids and compute results.
        if ([playersWithBids count] == [players count]) {
            [self recordRoundBidding];
            [self computeResults];
        }
    } else {
        // If the active player has made an invalid bid, notify the delegate.
        Player *activePlayer = [(AppDelegate *)[[UIApplication sharedApplication] delegate] activePlayer];
        if (player == activePlayer) {
            [[self delegate] invalidBidMade:bid];
        }
    }
}

- (void)recordRoundBidding {
    for (Player *player in [self players]) {
        NSMutableArray *playerBids = [[self playerBiddingHistory] objectForKey:[player name]];
        [playerBids addObject:[NSNumber numberWithInt:[player currentBid]]];
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
    [[self delegate] gameDidEnd:winner];
}

@end
