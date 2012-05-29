//
//  BiddingViewController.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;
@class Player;

@interface BiddingViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) Player *player;

@property (weak, nonatomic) IBOutlet UILabel *remainingMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *bidTextField;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

- (id)initWithPlayer:(Player *)aPlayer;

- (IBAction)onBidButtonTap:(id)sender;

@end
