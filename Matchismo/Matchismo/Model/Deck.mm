//
//  Deck.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "Card.h"
#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray<Card *> *cards;
@end

@implementation Deck

- (NSMutableArray *)cards {
  if(!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }
  return _cards;
}

- (NSUInteger)size {
  return self.cards.count;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}

- (void)addCard:(Card *)card {
  [self addCard:card atTop:NO];
}

-(Card *)drawRandomCard {
  Card *randomCard = nil;
  if (self.cards.count) {
    unsigned index = arc4random() % self.cards.count;
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  return randomCard;
}

@end
