//
//  Player.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "Player.h"

#import "Game.h"

@implementation Player

@synthesize name, currentGame, money, points, currentBid, previousBid;

- (id)initWithName:(NSString *)playerName {
    self = [super init];

    if (self) {
        [self setName:playerName];
    }

    return self;
}

- (void)prepareForGame:(Game *)game {
    // Initialize the player's game-specific data.
    [self setCurrentGame:game];
    [self setMoney:[game startingMoney]];
    [self setPoints:0];
    [self setCurrentBid:0];
    [self setPreviousBid:0];
}

- (void)submitBid:(int)bid {
    [self setCurrentBid:bid];
    [self notifyGameOfBid];
}

- (void)notifyGameOfBid {
    // Let the game know that this player has bid.
    [[self currentGame] acceptBidForPlayer:self];
}

- (void)spendBid {
    // Actually subtract the bid from the player's money.
    [self setMoney:[self money] - [self currentBid]];

    // Set the previous bid.
    [self setPreviousBid:[self currentBid]];
}

- (void)addPoint {
    // Give the player a point.
    [self setPoints:[self points] + 1];
}

@end
