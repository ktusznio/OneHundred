//
//  MainMenuViewController.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-05.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *singlePlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *multiplayerButton;

- (IBAction)onSinglePlayerButtonTap:(id)sender;
- (IBAction)onMultiplayerButtonTap:(id)sender;

@end
