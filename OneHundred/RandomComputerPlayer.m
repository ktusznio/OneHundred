//
//  RandomComputerPlayer.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-31.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#include <stdlib.h>

#import "RandomComputerPlayer.h"

#import "Game.h"

@implementation RandomComputerPlayer

- (id)initWithName:(NSString *)playerName game:(Game *)game {
    self = [super initWithName:playerName game:game];

    if (self) {

    }

    return self;
}

- (void)computeAndSubmitBid {
    // This computer player bids a random amount from 0 to (current money / points remaining to win).
    int maximumBid = [self money] / ([[self currentGame] targetPoints] - [self points]);
    int randomBid = arc4random_uniform(maximumBid);

    [self submitBid:randomBid];
}

@end


