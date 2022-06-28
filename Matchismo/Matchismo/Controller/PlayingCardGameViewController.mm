//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "PlayingCardGameViewController.h"

#import "CardMatchingGame.h"
#import "CardViewConstants.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)makeGame {
  return [[CardMatchingGame alloc] initWithCardCount:[self defaultNumberOfCards]
                                           usingDeck:[self createDeck]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.game.mode = self.gameModeControl.selectedSegmentIndex == 0
                    ? GameMode::twoCard : GameMode::threeCard;
}

- (void)createCardViewToPoint:(CGPoint)point withCard:(Card *)card {
  if (![card isKindOfClass:[PlayingCard class]]) {
    return;
  }
  PlayingCard *playingCard = (PlayingCard *)card;
  CGRect cardFrame = CGRectMake(point.x, point.y, self.cardWidth, self.cardHeight);
  auto playingCardView = [[PlayingCardView alloc] initWithFrame:cardFrame];
  playingCardView.suit = playingCard.suit;
  playingCardView.rank = playingCard.rank;
  playingCardView.faceUp = NO;
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                                  action:@selector(handleCardSelection:)];
  [playingCardView addGestureRecognizer:tapRecognizer];
  
  [self.cardsView addSubview:playingCardView];
  [self.cardViews addObject:playingCardView];
}

- (void)updateUI {
  int i = 0;
  while (i < self.cardViews.count) {
    if (![self.cardViews[i] isKindOfClass:[PlayingCardView class]]) {
      continue;
    }
    PlayingCardView *playingCardView = (PlayingCardView *)self.cardViews[i];
    auto *card = [self.game cardAtIndex:i];
    if (card.matched) {
      [self.cardViews[i] setAlpha:0.7];
    }
    playingCardView.faceUp = card.chosen;
    i++;
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  [self.gameModeControl setEnabled:NO];
}

- (void)startNewGame {
  [super startNewGame];
  [self.gameModeControl setEnabled:YES];
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
