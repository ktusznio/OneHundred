//
//  OpponentSelectionViewController.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-31.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface OpponentSelectionViewController : UIViewController

@property (strong, nonatomic) NSArray *opponentNames;
@property (strong, nonatomic) NSDictionary *availableOpponents;
@property (strong, nonatomic) NSMutableArray *activatedOpponents;

@property (weak, nonatomic) IBOutlet UILabel *activePlayerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFirstOpponentButton;
@property (weak, nonatomic) IBOutlet UIButton *addSecondOpponentButton;
@property (weak, nonatomic) IBOutlet UIButton *addThirdOpponentButton;

- (IBAction)onOpponentButtonTap:(id)sender;
- (IBAction)onBackButtonTap:(id)sender;
- (IBAction)onStartButtonTap:(id)sender;

@end
