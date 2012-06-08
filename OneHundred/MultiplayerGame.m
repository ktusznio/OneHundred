//
//  MultiplayerGame.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-07.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "MultiplayerGame.h"

#import "GCHelper.h"
#import "Message.h"
#import "Player.h"

@implementation MultiplayerGame

@synthesize isServer, resolvedServerDesignation, serverDesignation, state;

- (id)initWithTargetPoints:(int)points
             startingMoney:(int)money
                  delegate:(id<GameDelegate>)delegate {
    self = [super initWithTargetPoints:points
                         startingMoney:money
                              delegate:delegate];

    if (self) {
        [self setServerDesignation:arc4random()];
        [self setResolvedServerDesignation:NO];
        [self setState:GameStateWaitingForMatch];
    }

    return self;
}

- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[[GCHelper sharedInstance] match] sendDataToAllPlayers:data
                                                              withDataMode:GKMatchSendDataReliable
                                                                     error:&error];
    if (!success) {
        NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

- (void)sendServerDesignationMessage {
    MessageServerDesignation message;
    message.message.messageType = MessageTypeServerDesignation;
    message.randomDesignation = [self serverDesignation];

    NSData *data = [NSData dataWithBytes:&message
                                  length:sizeof(MessageServerDesignation)];
    [self sendData:data];
}

- (void)sendGameBeginMessage {
    MessageGameBegin message;
    message.message.messageType = MessageTypeGameBegin;

    NSData *data = [NSData dataWithBytes:&message
                                  length:sizeof(MessageGameBegin)];
    [self sendData:data];
}

- (void)tryToStartGame {
    // If we are the server then tell the other players to begin.
    if ([self isServer] && [self state] == GameStateWaitingForStart) {
        [self setState:GameStateActive];
        [self sendGameBeginMessage];
    }
}


#pragma mark GCHelperDelegate

- (void)matchStarted {
    // Check whether we've received a server designation.
    NSLog(@"Match started! Checking for random number.");
    if ([self resolvedServerDesignation]) {
        [self setState:GameStateWaitingForStart];
    } else {
        [self setState:GameStateWaitingForServerDesignation];
    }

    [self sendServerDesignationMessage];
    [self tryToStartGame];
}

- (void)matchEnded {
    NSLog(@"Match ended!");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    Message *message = (Message *)[data bytes];
    if (message->messageType == MessageTypeServerDesignation) {
        MessageServerDesignation *serverDesignationMessage = (MessageServerDesignation *) [data bytes];
        NSLog(@"Received random number: %ud, ours %ud", serverDesignationMessage->randomDesignation, [self serverDesignation]);
        bool tie = NO;

        if ([self serverDesignation] == serverDesignationMessage->randomDesignation) {
            NSLog(@"TIE!");
            tie = true;

            // Break the tie by sending another random number.
            [self setServerDesignation:arc4random()];
            [self sendServerDesignationMessage];
        } else if ([self serverDesignation] > serverDesignationMessage->randomDesignation) {
            NSLog(@"We are player 1");
            [self setIsServer:YES];
        } else {
            NSLog(@"We are player 2");
            [self setIsServer:NO];
        }

        if (!tie) {
            [self setResolvedServerDesignation:YES];

            if ([self state] == GameStateWaitingForServerDesignation) {
                [self setState:GameStateWaitingForStart];
            }

            [self tryToStartGame];
        }
    } else if (message->messageType == MessageTypeGameBegin) {
        [self setState:GameStateActive];
    }
}

- (void)receivedInvite {
    NSLog(@"Received invitation.");
}

@end
