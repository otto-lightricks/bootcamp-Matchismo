//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init {
  if (self = [super init]) {
    for (NSString *suit in [PlayingCard validSuits]) {
      for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
        auto card = [[PlayingCard alloc] init];
        card.rank = rank;
        card.suit = suit;
        [self addCard:card];
      }
    }
  }
  return self;
}

@end
