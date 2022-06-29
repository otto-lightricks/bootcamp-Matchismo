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
#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardGameViewController

const int DEFAULT_NUMBER_OF_CARDS = 12;

- (int)defaultNumberOfCards {
  return DEFAULT_NUMBER_OF_CARDS;
}

- (Deck *)createDeck {
  return [[SetCardDeck alloc] initWithColors:@[UIColor.redColor,
                                              UIColor.greenColor,
                                              UIColor.purpleColor]];
}

- (CardMatchingGame *)makeGame {
  return [[CardMatchingGame alloc] initWithCardCount:DEFAULT_NUMBER_OF_CARDS
                                           usingDeck:self.deck];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.game.mode = GameMode::threeCard;
}

- (CardView *)createCardViewWithFrame:(CGRect)frame withCard:(Card *)card {
  if (![card isKindOfClass:[SetCard class]]) {
    return [[CardView alloc] initWithFrame:frame];
  }
  SetCard *setCard = (SetCard *)card;
  auto setCardView = [[SetCardView alloc] initWithFrame:frame];
  setCardView.numberOfShapes = setCard.numberOfShapes;
  setCardView.shape = setCard.shape;
  setCardView.shading = setCard.shading;
  setCardView.color = setCard.color;
  
  return setCardView;
}

- (void)updateUI {
  int i = 0;
  while (i < self.cardViews.count) {
    auto card = [self.game cardAtIndex:i];
    auto cardView = self.cardViews[i];
    if (card.matched) {
      [UIView animateWithDuration:1.0
                       animations:^{
                         int x = (arc4random() % (int)(self.cardsView.bounds.size.width * 5))
                                 - (int)self.cardsView.bounds.size.width * 2;
                         int y = self.cardsView.bounds.size.height;
                         self.cardViews[i].center = CGPointMake(x, -y);
                       }
                       completion:^(BOOL finished) {
                         [cardView removeFromSuperview];
                       }
      ];
      
      [self.game removeCard:card];
      [self.cardViews removeObject:cardView];
    } else {
      [self.cardViews[i] setAlpha:card.chosen ? 0.85 : 1.0];
      i++;
    }
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
}

- (void)startNewGame {
  self.numberOfCardsPerRow = self.defaultNumberOfCardsPerRow;
  [super startNewGame];
}

- (CGPoint)getNextFreeCardPosition {
  int rows = ceil(self.cardViews.count / (double)self.numberOfCardsPerRow);
  int cardsOnTheSameRow = self.cardViews.count - (rows - 1) * self.numberOfCardsPerRow;
  BOOL fitsOnRow = cardsOnTheSameRow < self.numberOfCardsPerRow;
  CGFloat xPos = 0;
  CGFloat yPos = rows * self.cardHeight + rows * self.defaultGapBetweenCards;
  if (fitsOnRow) {
    xPos = cardsOnTheSameRow * self.cardWidth
                   + cardsOnTheSameRow * self.defaultGapBetweenCards;
    yPos = (rows - 1) * self.cardHeight
                   + (rows - 1) * self.defaultGapBetweenCards;
  }
  return CGPointMake(xPos, yPos);
}

- (void)addCard {
  Card *card = [self.deck drawRandomCard];
  if (card) {
    if ([card isKindOfClass:[SetCard class]]) {
      SetCard *setCard = (SetCard *)card;
      CGPoint point = [self getNextFreeCardPosition];
      [self createCardViewToPoint:point withCard:setCard];
      [self.game addCard:card];
      if ([self cardsViewTooLarge]) {
        [self resizeCards];
      }
    }
  }
}

- (IBAction)addCardsButtonPressed:(UIButton *)sender {
  for(int i = 0; i < 3; i++) {
    [self addCard];
  }
}

@end

NS_ASSUME_NONNULL_END
