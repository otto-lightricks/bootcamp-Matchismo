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

- (void)createCardViewToPoint:(CGPoint)point withCard:(Card *)card {
  if (![card isKindOfClass:[SetCard class]]) {
    return;
  }
  SetCard *setCard = (SetCard *)card;
  CGRect cardFrame = CGRectMake(point.x, point.y, [self cardWidth], [self cardHeight]);
  auto setCardView = [[SetCardView alloc] initWithFrame:cardFrame];
  setCardView.numberOfShapes = setCard.numberOfShapes;
  setCardView.shape = setCard.shape;
  setCardView.shading = setCard.shading;
  setCardView.color = setCard.color;
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                                  action:@selector(handleCardSelection:)];
  [setCardView addGestureRecognizer:tapRecognizer];
  
  [self.cardsView addSubview:setCardView];
  [self.cardViews addObject:setCardView];
}

- (void)updateUI {
  int i = 0;
  while (i < self.cardViews.count) {
    auto *card = [self.game cardAtIndex:i];
    if (card.matched) {
      [self.cardViews[i] removeFromSuperview];
      [self.game removeCard:card];
      [self.cardViews removeObject:self.cardViews[i]];
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

- (CGPoint)findNextFreeCardPosition {
  CGFloat xPos = 0;
  CGFloat yPos = 0;
  int i = 1;
  auto hitView = [self.cardsView hitTest:CGPointMake(xPos + [self cardWidth] / 2,
                                                     yPos + [self cardHeight] / 2)
                               withEvent:nil];
  while ([hitView isKindOfClass:[SetCardView class]]) {
    if (i % self.numberOfCardsPerRow == 0) {
      xPos = 0;
      yPos += [self cardHeight] + self.defaultGapBetweenCards;
    } else {
      xPos += [self cardWidth] + self.defaultGapBetweenCards;
    }
    ++i;
    hitView = [self.cardsView hitTest:CGPointMake(xPos + [self cardWidth] / 2,
                                                  yPos + [self cardHeight] / 2) withEvent:nil];
  }
  return CGPointMake(xPos, yPos);
}

- (void)addCard {
  Card *card = [self.deck drawRandomCard];
  if (card) {
    if ([card isKindOfClass:[SetCard class]]) {
      SetCard *setCard = (SetCard *)card;
      CGPoint point = [self findNextFreeCardPosition];
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
