//
//  GameOverViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-31.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "GameOverViewController.h"

#import "Player.h"

@implementation GameOverViewController

@synthesize winner, winnerLabel;

- (id)initForWinner:(Player *)aWinner {
    self = [super init];

    if (self) {
        [self setWinner:aWinner];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [winnerLabel setText:[NSString stringWithFormat:@"%@ wins!", [[self winner] name]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationItem] setHidesBackButton:YES];
}

- (void)viewDidUnload {
    [self setWinnerLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
