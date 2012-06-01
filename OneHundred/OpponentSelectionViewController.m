//
//  OpponentSelectionViewController.m
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-05-31.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

#import "OpponentSelectionViewController.h"

#import "DumbComputerPlayer.h"
#import "RandomComputerPlayer.h"

static NSString *initialOpponentButtonText = @"Tap to add opponent";

@implementation OpponentSelectionViewController

@synthesize activePlayer, activatedOpponents, availableOpponents;
@synthesize addFirstOpponentButton, addSecondOpponentButton, addThirdOpponentButton;

- (id)init {
    self = [super init];
    
    if (self) {
        [self setActivatedOpponents:[NSMutableArray array]];
        
        // Set up the available opponents dictionary.
        NSArray *opponentClasses = [NSArray arrayWithObjects:[DumbComputerPlayer class], [RandomComputerPlayer class], nil];
        NSArray *opponentNames = [NSArray arrayWithObjects:@"Dumbox", @"WEPQUP", nil];
        [self setAvailableOpponents:[NSDictionary dictionaryWithObjects:opponentClasses
                                                                forKeys:opponentNames]];
    }
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the add opponent button texts. The first opponent is enabled by default.
    NSArray *opponentNames = [[self availableOpponents] allKeys];
    [addFirstOpponentButton setTitle:[opponentNames objectAtIndex:0] forState:UIControlStateNormal];
    [addSecondOpponentButton setTitle:initialOpponentButtonText forState:UIControlStateNormal];
    [addThirdOpponentButton setTitle:initialOpponentButtonText forState:UIControlStateNormal];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    [self setAddFirstOpponentButton:nil];
    [self setAddSecondOpponentButton:nil];
    [self setAddThirdOpponentButton:nil];
}

- (IBAction)onOpponentButtonTap:(id)sender {
    UIButton *tappedButton = (UIButton *)sender;
    NSString *buttonText = [[tappedButton titleLabel] text];
    NSArray *opponentNames = [[self availableOpponents] allKeys];
    
    if ([buttonText isEqualToString:initialOpponentButtonText]) {
        [tappedButton setTitle:[opponentNames objectAtIndex:0] forState:UIControlStateNormal];
    } else {
        // Find the array index of the selected opponent.
        int selectedOpponentIndex = -1;
        for (int i = 0; i < [opponentNames count]; i++) {
            if ([(NSString *)[opponentNames objectAtIndex:i] isEqualToString:buttonText]) {
                selectedOpponentIndex = i;
                break;
            }
        }
        
        // Select the next opponent or loop around to the first opponent if the last opponent is selected.
        if (selectedOpponentIndex == [opponentNames count] - 1) {
            [tappedButton setTitle:[opponentNames objectAtIndex:0] forState:UIControlStateNormal];
        } else {
            NSString *nextOpponentName = [opponentNames objectAtIndex:selectedOpponentIndex + 1];
            [tappedButton setTitle:nextOpponentName forState:UIControlStateNormal];
        }
    }
}

- (IBAction)onBackButtonTap:(id)sender {
    
}

- (IBAction)onStartButtonTap:(id)sender {
    
}

@end