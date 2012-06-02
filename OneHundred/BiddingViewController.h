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

@property (weak, nonatomic) IBOutlet UILabel *activePlayerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activePlayerDataLabel;
@property (weak, nonatomic) IBOutlet UITextField *bidTextField;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet UIView *opponentsView;

- (IBAction)onBidButtonTap:(id)sender;
- (IBAction)onBackgroundTap:(id)sender;
- (UIView *)opponentViewForPlayer:(Player *)player
                            index:(int)index;

@end
