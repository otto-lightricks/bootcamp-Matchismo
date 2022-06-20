//
//  SetViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 16/06/2022.
//

#import "SetCardGameViewController.h"

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@implementation SetCardGameViewController

- (Deck *)createDeck {
  return [[SetCardDeck alloc] initWithShapes:@[@"●", @"■", @"▲"]
                                      Colors:@[UIColor.redColor,
                                               UIColor.greenColor,
                                               UIColor.purpleColor]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpCards];
  self.game.mode = GameMode::three;
}

-(void) setUpCards {
  for (UIButton *cardButton in self.cardsCollection) {
    [cardButton.titleLabel setLineBreakMode:NSLineBreakByClipping];
    [cardButton.titleLabel setNumberOfLines:3];
    [cardButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cardButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [cardButton setEnabled:YES];
    [cardButton setAlpha:1.0];
    const auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    const auto *card = (SetCard *)[self.game cardAtIndex:cardButtonIndex];
    auto *text = card.shape;
    for (int i = 1; i < card.noOfShapes; i++) {
      text = [text stringByAppendingString:[NSString stringWithFormat:@"\r%@", card.shape]];
    }
    auto *attString = [[NSAttributedString alloc] initWithString:text
                                                      attributes:card.attributes];
    [cardButton setAttributedTitle:attString forState:UIControlStateNormal];
  }
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardsCollection) {
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    const auto *card = (SetCard *)[self.game cardAtIndex:cardButtonIndex];
    [cardButton setEnabled:!card.matched];
    [cardButton setAlpha:(card.chosen && !card.matched) ? 0.85 : 1.0];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.attributedText = self.game.lastMoveDescription;
}

- (void)startNewGame {
  if (![self.game startNewGameWithCardCount:self.cardsCollection.count usingDeck
                                           :[self createDeck]]) {
    return;
  }
  [self setUpCards];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.text = @"";
}

@end
