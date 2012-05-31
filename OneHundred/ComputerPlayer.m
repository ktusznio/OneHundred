//
//  ComputerPlayer.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "ComputerPlayer.h"

@implementation ComputerPlayer

- (id)initWithName:(NSString *)playerName {
    self = [super initWithName:playerName];

    if (self) {

    }

    return self;
}

- (void)computeAndSubmitBid {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
