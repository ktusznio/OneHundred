//
//  GameOverViewController.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-31.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface GameOverViewController : UIViewController

@property (strong, nonatomic) Player *winner;

@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

- (id)initForWinner:(Player *)aWinner;

@end
