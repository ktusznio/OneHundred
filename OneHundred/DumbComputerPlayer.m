//
//  DumbComputerPlayer.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "DumbComputerPlayer.h"

@implementation DumbComputerPlayer

- (id)initWithName:(NSString *)playerName {
    self = [super initWithName:playerName];

    if (self) {

    }

    return self;
}

- (void)computeAndSubmitBid {
    [self submitBid:5];
}

@end
