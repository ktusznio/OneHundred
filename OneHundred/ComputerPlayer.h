//
//  ComputerPlayer.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Player.h"

@class Game;

@interface ComputerPlayer : Player

- (void)computeAndSubmitBid;

@end
