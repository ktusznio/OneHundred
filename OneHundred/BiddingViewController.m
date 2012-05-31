//
//  BiddingViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-29.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "BiddingViewController.h"
#import "GameOverViewController.h"

#import "Game.h"
#import "Player.h"

@implementation BiddingViewController

@synthesize activePlayer, activePlayerDataLabel, activePlayerNameLabel, bidButton, bidTextField, game, opponentsView;

const CGFloat OPPONENT_VIEW_HEIGHT = 40;
const CGFloat NAME_LABEL_HEIGHT = 20;
const CGFloat DATA_LABEL_HEIGHT = 20;

- (id)initForGame:(Game *)aGame
     activePlayer:(Player *)anActivePlayer {
    self = [super init];

    if (self) {
        [self setGame:aGame];
        [self setActivePlayer:anActivePlayer];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // Set up the active player's view.
    [activePlayerNameLabel setText:[activePlayer name]];
    [activePlayerDataLabel setText:[NSString stringWithFormat:@"%d / %d / %d", [activePlayer money], [activePlayer points], [activePlayer previousBid]]];

    // Set up the opponents' view.
    int opponentCount = 0;
    for (Player *player in [game players]) {
        if (player != activePlayer) {
            // Create the view for this opponent and add it to the opponents' view.
            UIView *opponentView = [self opponentViewForPlayer:player
                                                         index:opponentCount];
            [[self opponentsView] addSubview:opponentView];

            // Increment the opponent count.
            opponentCount++;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setBidTextField:nil];
    [self setBidButton:nil];
    [self setOpponentsView:nil];
    [self setActivePlayerNameLabel:nil];
    [self setActivePlayerDataLabel:nil];
    [super viewDidUnload];
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
        [activePlayer submitBid:[bid intValue]];

        // Clear the bid text field.
        [bidTextField setText:@""];
    } else {
        // TODO: Alert the user that the bid is invalid.
    }
}

- (UIView *)opponentViewForPlayer:(Player *)player
                            index:(int)index {
    // Create the opponent view to return.
    CGRect opponentViewFrame = CGRectMake(0, index * OPPONENT_VIEW_HEIGHT, opponentsView.frame.size.width, OPPONENT_VIEW_HEIGHT);
    UIView *opponentView = [[UIView alloc] initWithFrame:opponentViewFrame];

    // Create the name label and add it to the opponent view.
    CGRect nameLabelFrame = CGRectMake(0, 0, opponentsView.frame.size.width, NAME_LABEL_HEIGHT);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
    [nameLabel setText:[player name]];
    [opponentView addSubview:nameLabel];

    // Create the data label (ie. money and points) and add it to the opponent view.
    CGRect dataLabelFrame = CGRectMake(0, NAME_LABEL_HEIGHT, opponentsView.frame.size.width, DATA_LABEL_HEIGHT);
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:dataLabelFrame];
    [dataLabel setText:[NSString stringWithFormat:@"%d / %d / %d", [player money], [player points], [player previousBid]]];
    [opponentView addSubview:dataLabel];

    return opponentView;
}

#pragma mark GameDelegate

- (void)gameWillBegin {
    // Have each player prepare for the game.
    for (Player *player in [game players]) {
        [player prepareForGame:game];
    }
}

- (void)roundWillBegin {
    [self viewWillAppear:NO];
}

- (void)gameDidEnd:(Player *)winner {
    GameOverViewController *gameOverViewController = [[GameOverViewController alloc] initForWinner:winner];
    [[self navigationController] pushViewController:gameOverViewController
                                           animated:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
