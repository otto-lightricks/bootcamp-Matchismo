//
//  AbstractCardGameViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "AbstractCardGameViewController.h"

#import "Card.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractCardGameViewController()

@property (readwrite, nonatomic) Deck* deck;
@property (readwrite, nonatomic) CardMatchingGame* game;
@property (nonatomic) NSMutableAttributedString *moveHistory;

@end

@implementation AbstractCardGameViewController

- (Deck *)deck {
  if (!_deck) {
    _deck = [self createDeck];
  }
  return _deck;
}

- (CardMatchingGame *)game {
  if (!_game) {
    _game = [self makeGame];
  }
  return _game;
}

- (NSMutableAttributedString *)moveHistory {
  if (!_moveHistory) {
    _moveHistory = [[NSMutableAttributedString alloc] init];
  }
  return _moveHistory;
}

- (CardMatchingGame *)makeGame {
  return [[CardMatchingGame alloc] initWithCardCount:self.cardsCollection.count
                                           usingDeck:[self createDeck]];
}

- (Deck *)createDeck {
  NSAssert(NO, @"Abstract method, should not be called directly");
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
  [self.moveHistory appendAttributedString:self.descriptionLabel.attributedText];
  [self.moveHistory appendAttributedString:
     [[NSMutableAttributedString alloc] initWithString:@"\r"]];
}

- (void)handleCardSelectionAtIndex:(NSUInteger)index {
  [self.game chooseCardAtIndex:index];
  [self updateUI];
}

- (IBAction)newGameButtonClicked:(id)sender {
  [self startNewGame];
  self.moveHistory = [[NSMutableAttributedString alloc] initWithString:@""];
}

- (void)startNewGame {
  return;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if ([segue.identifier isEqualToString: @"showHistory"]) {
    if ([segue.destinationViewController isKindOfClass: [HistoryViewController class]]) {
      const auto hVC = (HistoryViewController *)segue.destinationViewController;
      [hVC setAttributedText:self.moveHistory];    }
  }
}

@end

NS_ASSUME_NONNULL_END
