//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "PlayingCardGameViewController.h"

#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  for (UIButton *cardButton in self.cardsCollection) {
    [cardButton.titleLabel setLineBreakMode:NSLineBreakByClipping];
    [cardButton.titleLabel setNumberOfLines:1];
    [cardButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cardButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
  }
  self.game.mode = self.gameModeControl.selectedSegmentIndex == 0
                    ? GameMode::two : GameMode::three;
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardsCollection) {
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    [cardButton setEnabled:!card.matched];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.attributedText = self.game.lastMoveDescription;
}

- (NSAttributedString *)titleForCard: (Card *)card {
  return card.chosen ? card.contents : [[NSAttributedString alloc] initWithString: @""];
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (void)handleCardSelectionAtIndex:(NSUInteger)index {
  [super handleCardSelectionAtIndex:index];
  if (self.gameModeControl.enabled) {
    [self.gameModeControl setEnabled:NO];
  }
}

- (void)startNewGame {
  if (![self.game startNewGameWithCardCount:self.cardsCollection.count usingDeck
                                           :[self createDeck]]) {
    return;
  }
  for (UIButton *cardButton in self.cardsCollection) {
    [cardButton setTitle:@"" forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[UIImage imageNamed: @"cardback"]
                          forState:UIControlStateNormal];
    [cardButton setEnabled:YES];
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.text = @"";
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

@end
