//
//  OpponentSelectionViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-31.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "OpponentSelectionViewController.h"

#import "AggressiveComputerPlayer.h"
#import "AppDelegate.h"
#import "BiddingViewController.h"
#import "DumbComputerPlayer.h"
#import "Game.h"
#import "Player.h"
#import "RandomComputerPlayer.h"

static NSString *initialOpponentButtonText = @"Tap to add opponent";

@implementation OpponentSelectionViewController

@synthesize opponentNames, availableOpponents, activatedOpponents;
@synthesize activePlayerNameLabel, addFirstOpponentButton, addSecondOpponentButton, addThirdOpponentButton;

- (id)init {
    self = [super init];

    if (self) {
        // Set up the available opponents dictionary.
        NSArray *opponentClasses = [NSArray arrayWithObjects:[DumbComputerPlayer class], [RandomComputerPlayer class], [AggressiveComputerPlayer class], nil];
        [self setOpponentNames:[NSArray arrayWithObjects:@"Dumbox", @"WEPQUP", @"la la LA LA", nil]];
        [self setAvailableOpponents:[NSDictionary dictionaryWithObjects:opponentClasses
                                                                forKeys:[self opponentNames]]];

        // Initialize the activated opponents array.
        [self setActivatedOpponents:[NSMutableArray array]];
    }

    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the active player name label.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [activePlayerNameLabel setText:[[appDelegate activePlayer] name]];

    // Initialize the add opponent button texts. The first opponent is enabled by default.
    [addFirstOpponentButton setTitle:[[self opponentNames] objectAtIndex:0] forState:UIControlStateNormal];
    [addSecondOpponentButton setTitle:initialOpponentButtonText forState:UIControlStateNormal];
    [addThirdOpponentButton setTitle:initialOpponentButtonText forState:UIControlStateNormal];
}

- (void)viewDidUnload {
    [self setActivePlayerNameLabel:nil];
    [self setAddFirstOpponentButton:nil];
    [self setAddSecondOpponentButton:nil];
    [self setAddThirdOpponentButton:nil];
    [super viewDidUnload];
}

- (IBAction)onOpponentButtonTap:(id)sender {
    UIButton *tappedButton = (UIButton *)sender;
    NSString *buttonText = [[tappedButton titleLabel] text];

    // If the text on the button represents an non-existent opponent, select the first opponent in the array.
    // Otherwise, iterate to the next opponent.
    int selectedOpponentIndex = [[self opponentNames] indexOfObject:buttonText];
    if (selectedOpponentIndex == NSNotFound) {
        [tappedButton setTitle:[[self opponentNames] objectAtIndex:0] forState:UIControlStateNormal];
    } else {
        NSString *nextOpponentName = [[self opponentNames] objectAtIndex:(selectedOpponentIndex + 1) % [[self opponentNames] count]];
        [tappedButton setTitle:nextOpponentName forState:UIControlStateNormal];
    }
}

- (IBAction)onBackButtonTap:(id)sender {

}

- (IBAction)onStartButtonTap:(id)sender {
    // Get the app delegate.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    // Create the bidding view controller.
    BiddingViewController *biddingViewController = [[BiddingViewController alloc] init];

    // Create a new game and set the current game in the app delegate.
    Game *currentGame = [[Game alloc] initWithTargetPoints:6 startingMoney:100 delegate:biddingViewController];
    [appDelegate setCurrentGame:currentGame];

    // Add the active player to the game.
    [currentGame addPlayer:[appDelegate activePlayer]];

    // Loop over the add opponent buttons, adding the selected opponents to the game.
    NSArray *addOpponentButtons = [NSArray arrayWithObjects:addFirstOpponentButton, addSecondOpponentButton, addThirdOpponentButton, nil];
    for (UIButton *addOpponentButton in addOpponentButtons) {
        NSString *opponentName = [[addOpponentButton titleLabel] text];
        Class opponentClass = [availableOpponents objectForKey:opponentName];
        if (opponentClass != nil) {
            [currentGame addPlayer:[[opponentClass alloc] initWithName:opponentName]];
        }
    }

    // Start the game.
    [currentGame startGame];

    // Push to the bidding screen.
    [[self navigationController] pushViewController:biddingViewController animated:YES];
}

@end
