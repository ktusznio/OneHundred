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
@property (nonatomic) int currentBid;
@property (nonatomic) int previousBid;

- (id)initWithName:(NSString *)playerName;
- (void)prepareForGame:(Game *)game;
- (void)submitBid:(int)bid;
- (void)notifyGameOfBid;
- (void)spendBid;
- (void)addPoint;

@end
