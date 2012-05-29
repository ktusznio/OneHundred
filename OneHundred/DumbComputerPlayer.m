//
//  DumbComputerPlayer.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "DumbComputerPlayer.h"

@implementation DumbComputerPlayer

- (id)initWithName:(NSString *)playerName game:(Game *)game {
    self = [super initWithName:playerName game:game];

    if (self) {

    }

    return self;
}

- (void)computeAndSubmitBid {
    [self submitBid:5];
}

@end
