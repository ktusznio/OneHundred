//
//  MultiplayerGame.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-07.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "Game.h"
#import "GCHelper.h"

typedef enum {
    GameStateWaitingForMatch = 0,
    GameStateWaitingForServerDesignation,
    GameStateWaitingForStart,
    GameStateActive,
    GameStateDone
} GameState;

typedef enum {
    GameEndReasonWin,
    GameEndReasonLose,
    GameEndReasonDisconnect
} GameEndReason;

@interface MultiplayerGame : Game <GCHelperDelegate>

@property (nonatomic) BOOL isServer;
@property (nonatomic) BOOL resolvedServerDesignation;
@property (nonatomic) int serverDesignation;
@property (nonatomic) GameState state;

- (void)sendData:(NSData *)data;
- (void)sendServerDesignationMessage;
- (void)sendGameBeginMessage;
- (void)tryToStartGame;

@end
