//
//  BiddingViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "BiddingViewController.h"

#import "Game.h"
#import "Player.h"

@implementation BiddingViewController

@synthesize bidButton, bidTextField, game, player, pointsLabel, remainingMoneyLabel;

- (id)initWithPlayer:(Player *)aPlayer {
    self = [super init];

    if (self) {
        [self setPlayer:aPlayer];
        [self setGame:[aPlayer currentGame]];
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [remainingMoneyLabel setText:[NSString stringWithFormat:@"$%d", [player money]]];
    [pointsLabel setText:[NSString stringWithFormat:@"%d out of %d", [player points], [[player currentGame] targetPoints]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setRemainingMoneyLabel:nil];
    [self setBidTextField:nil];
    [self setBidButton:nil];
    [self setPointsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)onBidButtonTap:(id)sender {
    // Dismiss the keyboard.
    [bidTextField resignFirstResponder];

    // If the player entered a valid bid, submit it.  Otherwise, let the player know.
    NSString *bid = [bidTextField text];
    if ([bid length] > 0) {
        // Submit the player's bid.
        [player submitBid:[bid intValue]];

        // Clear the bid text field.
        [bidTextField setText:@""];
    } else {
        // TODO: Alert the user that the bid is invalid.
    }
}

#pragma mark GameDelegate

- (void)roundWillBegin {
    [self viewWillAppear:NO];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
