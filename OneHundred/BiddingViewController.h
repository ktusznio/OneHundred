//
//  BiddingViewController.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiddingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *remainingMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *bidTextField;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end
