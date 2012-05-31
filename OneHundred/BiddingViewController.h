//
//  BiddingViewController.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Game.h"

@class Game;
@class Player;

@interface BiddingViewController : UIViewController <GameDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) Player *activePlayer;

@property (weak, nonatomic) IBOutlet UILabel *remainingMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *bidTextField;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIView *opponentsView;

- (id)initWithActivePlayer:(Player *)anActivePlayer;

- (IBAction)onBidButtonTap:(id)sender;
- (UIView *)opponentViewForPlayer:(Player *)player
                            index:(int)index;

@end
