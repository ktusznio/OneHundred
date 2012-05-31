//
//  Game.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@protocol GameDelegate

- (void)roundWillBegin;
- (void)gameDidEnd:(Player *)winner;

@end

@interface Game : NSObject

@property (strong, nonatomic) id<GameDelegate> delegate;
@property (nonatomic) int targetPoints;
@property (nonatomic) int startingMoney;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) NSMutableSet *playersWithBids;

- (id)initWithTargetPoints:(int)points startingMoney:(int)money;
- (void)addPlayer:(Player *)player;
- (void)startNewRound;
- (void)clearPlayersWithBids;
- (void)obtainPlayerBids;
- (void)acceptBidForPlayer:(Player *)player;
- (void)computeResults;
- (void)declareWinner:(Player *)winner;

@end