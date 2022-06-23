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

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;

@end

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
                    ? GameMode::twoCard : GameMode::threeCard;
}

- (void)handleCardSelectionAtIndex:(NSUInteger)index {
  [self.game chooseCardAtIndex:index];
  [self updateUI];
  [self.gameModeControl setEnabled:NO];
}

- (void)updateMoveDescriptionLabel {
  NSString *moveDescription = self.game.lastMoveDescription;
  
  auto heartsAndDiamondsPattern = @"[0-9JKQA]+[♥︎♦︎]";
  auto spadesAndClubsPattern = @"[0-9JKQA]+[♠︎♣︎]";
  
  auto heartsAndDiamondsRegex = [NSRegularExpression
                                  regularExpressionWithPattern:heartsAndDiamondsPattern
                                                       options:0
                                                         error:nil];
  auto spadesAndClubsRegex = [NSRegularExpression
                               regularExpressionWithPattern:spadesAndClubsPattern
                                                    options:0
                                                      error:nil];

  auto textRange = NSMakeRange(0, moveDescription.length);
  auto heartsAndDiamondsMatches = [heartsAndDiamondsRegex matchesInString:moveDescription
                                                                  options:0
                                                                    range:textRange];
  auto spadesAndClubsMatches = [spadesAndClubsRegex matchesInString:moveDescription
                                                            options:0
                                                              range:textRange];
  
  auto *redColorAttribute = @{NSForegroundColorAttributeName : UIColor.redColor};
  auto *blackColorAttribute = @{NSForegroundColorAttributeName : UIColor.blackColor};
  auto attributedDescription = [[NSMutableAttributedString alloc] initWithString:moveDescription];
  
  for (NSTextCheckingResult *res in heartsAndDiamondsMatches) {
    [attributedDescription addAttributes:redColorAttribute range:res.range];
  }
  
  for (NSTextCheckingResult *res in spadesAndClubsMatches) {
    [attributedDescription addAttributes:blackColorAttribute range:res.range];
  }
  
  self.descriptionLabel.attributedText = attributedDescription;
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardsCollection) {
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    if ([card isKindOfClass:[PlayingCard class]]) {
      auto playingCard = (PlayingCard *)card;
      auto attributedTitle = [[NSAttributedString alloc]
                                initWithString:[self titleForCard:card]
                                    attributes:@{NSForegroundColorAttributeName
                                                  : [self colorForCard:playingCard]}];
      [cardButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    }
    [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                          forState:UIControlStateNormal];
    [cardButton setEnabled:!card.matched];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  [self updateMoveDescriptionLabel];
}

- (NSString *)titleForCard: (Card *)card {
  return card.chosen ? card.contents : @"";
}

- (UIColor *)colorForCard: (PlayingCard *)card {
  return ([card.suit isEqualToString:@"♥︎"] || [card.suit isEqualToString:@"♦︎"])
           ? UIColor.redColor : UIColor.blackColor;
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (void)startNewGame {
  if (![self.game startNewGameWithCardCount:self.cardsCollection.count
                                  usingDeck:[self createDeck]]) {
    return;
  }
  [self resetCardButtons];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.text = @"";
  [self.gameModeControl setEnabled:YES];
}

- (void)resetCardButtons {
  for (UIButton *cardButton in self.cardsCollection) {
    [cardButton setBackgroundImage:[UIImage imageNamed: @"cardback"]
                          forState:UIControlStateNormal];
    [cardButton setEnabled:YES];
    [cardButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@""]
                          forState:UIControlStateNormal];
  }
}

- (IBAction)modeChanged:(UISegmentedControl *)sender {
  switch (sender.selectedSegmentIndex) {
    case twoCardGameModeIndex:
      self.game.mode = GameMode::twoCard;
      break;
    case threeCardGameModeIndex:
      self.game.mode = GameMode::threeCard;
      break;
  };
}

@end

NS_ASSUME_NONNULL_END
