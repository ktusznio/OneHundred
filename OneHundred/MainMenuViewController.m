//
//  MainMenuViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-05.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "MainMenuViewController.h"

#import "OpponentSelectionViewController.h"

@implementation MainMenuViewController

@synthesize singlePlayerButton, multiplayerButton;

- (id)init {
    self = [super init];

    if (self) {

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    // Hide the navigation bar.
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidUnload {
    [self setSinglePlayerButton:nil];
    [self setMultiplayerButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)onSinglePlayerButtonTap:(id)sender {
    // Push the opponent selection view.
    [[self navigationController] pushViewController:[[OpponentSelectionViewController alloc] init] animated:YES];
}

- (IBAction)onMultiplayerButtonTap:(id)sender {

}

@end
