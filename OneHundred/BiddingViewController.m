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

@synthesize bidButton, bidTextField, player, pointsLabel, remainingMoneyLabel;

- (id)initWithPlayer:(Player *)aPlayer {
    self = [super init];

    if (self) {
        [self setPlayer:aPlayer];
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

@end
