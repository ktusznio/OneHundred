//
//  GCHelper.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-05.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate

- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;

@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    BOOL matchStarted;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (strong, nonatomic) UIViewController *presentingViewController;
@property (strong, nonatomic) GKMatch *match;
@property (strong, nonatomic) id <GCHelperDelegate> delegate;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GCHelperDelegate>)aDelegate;

@end
