//
//  ViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "ViewController.h"

#import "Card.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface ViewController ()

@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardsCollection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property int mode;
@end

@implementation ViewController

- (Deck *)deck {
  if (!_deck) {
    _deck = [self createDeck];
  }
  return _deck;
}

- (CardMatchingGame *)game {
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardsCollection count]
                                                        usingDeck:self.deck];
  
  return _game;
}

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  for (UIButton *cardButton in self.cardsCollection) {
    [cardButton.titleLabel setLineBreakMode:NSLineBreakByClipping];
    [cardButton.titleLabel setNumberOfLines:1];
    [cardButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cardButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    if (PlayingCard *playingCard = (PlayingCard *)card) {
      [cardButton setTitleColor:[self textColorForPlayingCard:(PlayingCard *) card]
                       forState:UIControlStateNormal];
    } else {
      [cardButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
  }
  self.game.mode = self.gameModeControl.selectedSegmentIndex == 0
                    ? GameMode::two : GameMode::three;
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardsCollection) {
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    [cardButton setEnabled:!card.matched];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.text = self.game.lastCardFlipDescription;
}

- (NSString *)titleForCard: (Card *)card {
  return card.chosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (UIColor *) textColorForPlayingCard: (PlayingCard *)card {
  return ([card.suit isEqualToString:@"♥︎"] || [card.suit isEqualToString:@"♦︎"])
          ? UIColor.redColor : UIColor.blackColor;
}

- (IBAction)touchCardButton:(UIButton *)sender {
  
  auto chosenCardIndex = [self.cardsCollection indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenCardIndex];
  [self updateUI];
  if (self.gameModeControl.enabled) {
    [self.gameModeControl setEnabled:NO];
  }
}

- (IBAction)newGameButtonClicked:(id)sender {
  [self startNewGame];
  [self.gameModeControl setEnabled:YES];
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
    if (PlayingCard *playingCard = (PlayingCard *)card) {
      [cardButton setTitleColor:[self textColorForPlayingCard:(PlayingCard *) card]
                       forState:UIControlStateNormal];
    } else {
      [cardButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
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
