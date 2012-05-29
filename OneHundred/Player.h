//
//  Player.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@interface Player : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Game *currentGame;
@property (nonatomic) int money;
@property (nonatomic) int points;
@property (nonatomic) BOOL bidRequested;
@property (nonatomic) int currentBid;

- (id)initWithName:(NSString *)playerName game:(Game *)game;
- (void)submitBid:(int)bid;
- (void)spendBid;
- (void)addPoint;

@end
