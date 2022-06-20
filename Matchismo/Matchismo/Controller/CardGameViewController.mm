//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "CardGameViewController.h"

#import "Card.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@implementation CardGameViewController

- (Deck *)deck {
  if (!_deck) {
    _deck = [self createDeck];
  }
  return _deck;
}

- (CardMatchingGame *)game {
  if (!_game) {
    _game = [self initializeGame];
  }
  return _game;
}

- (CardMatchingGame *)initializeGame {
  return [[CardMatchingGame alloc] initWithCardCount:self.cardsCollection.count
                                           usingDeck:[self createDeck]];
}

- (Deck *)createDeck {
  return nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  const auto appearance = [[UITabBarAppearance alloc] init];
  [appearance setBackgroundColor:self.view.backgroundColor];
  [[self.tabBarController tabBar] setStandardAppearance:appearance];
  [[self.tabBarController tabBar] setScrollEdgeAppearance:appearance];
  
  const auto navBarAppeareance = [[UINavigationBarAppearance alloc] init];
  [navBarAppeareance setBackgroundColor:self.view.backgroundColor];
  [[self.navigationController navigationBar] setStandardAppearance:navBarAppeareance];
  [[self.navigationController navigationBar] setScrollEdgeAppearance:navBarAppeareance];
}

- (void)updateUI {
  return;
}

- (IBAction)touchCardButton:(UIButton *)sender {
  [self handleCardSelectionAtIndex: [self.cardsCollection indexOfObject:sender]];
  if (self.gameModeControl.enabled) {
    [self.gameModeControl setEnabled:NO];
  }
}

- (void)handleCardSelectionAtIndex:(NSUInteger)index {
  [self.game chooseCardAtIndex:index];
  [self updateUI];
}

- (IBAction)newGameButtonClicked:(id)sender {
  [self startNewGame];
  [self.gameModeControl setEnabled:YES];
}

- (void)startNewGame {
  return;
}

- (IBAction)modeChanged:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case 0:
      self.game.mode = GameMode::two;
      break;
    case 1:
      self.game.mode = GameMode::three;
      break;
  };
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString: @"showHistory"]) {
    if ([segue.destinationViewController isKindOfClass: [HistoryViewController class]]) {
      const auto hVC = (HistoryViewController *)segue.destinationViewController;
      hVC.historyText = self.game.moveHistory;
    }
  }
}

@end
