//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Otto Olkkonen on 10/06/2022.
//

#import "CardMatchingGame.h"

#import "Card.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame()

@property (readwrite, nonatomic) NSInteger score;
@property (nonatomic) NSMutableArray<Card *> *cards;
@property (nonatomic) NSMutableArray<Card *> *chosenCards;

@end

@implementation CardMatchingGame

- (NSMutableArray<Card *> *)cards {
  if (!_cards) {
    _cards = [[NSMutableArray<Card *> alloc] init];
  }
  return _cards;
}

- (NSMutableArray<Card *> *)chosenCards {
  if (!_chosenCards) {
    _chosenCards = [[NSMutableArray<Card *> alloc] init];
  }
  return _chosenCards;
}

- (instancetype)initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck {
  if (self = [super init]) {
    if (![self startNewGameWithCardCount:count usingDeck:deck]) {
      self = nil;
    }
  }
  return self;
}

- (BOOL)startNewGameWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck {
  [self.cards removeAllObjects];
  [self.chosenCards removeAllObjects];
  if (deck.size < count) {
    return NO;
  }
  for (int i=0; i < count; i++) {
    Card *card = [deck drawRandomCard];
    if (card) {
      [self.cards addObject:card];
    } else {
      return NO;
    }
  }
  self.score = 0;
  return YES;
}

- (Card *)cardAtIndex: (NSUInteger)index {
  return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)addCard:(Card *)card {
  [self.cards addObject:card];
}

- (void)removeCard:(Card *)card {
  [self.cards removeObject:card];
}

- (MatchResult)checkForMatch {
  MatchResult matchResult;
  matchResult.score = 0;
  // If more than one card chosen, compare all cards with each other to find the best match
  if (self.chosenCards.count > 1) {
    for (Card *chosenCard in self.chosenCards) {
      NSMutableArray<Card *> *cardsToCompare = [[NSMutableArray alloc]
                                                initWithCapacity:self.chosenCards.count - 1];
      for (Card *card in self.chosenCards) {
        if (![card isEqual:chosenCard]) {
          [cardsToCompare addObject:card];
        }
      }
      MatchResult res = [chosenCard match:cardsToCompare];
      // Update match result if better match found
      if (res.score > matchResult.score) {
        matchResult = res;
      }
    }
  }
  return matchResult;
}

- (void) handleMatch:(MatchResult)matchResult {
  int points = matchResult.score * (self.mode == GameMode::twoCard
                                    ? TWO_MATCH_BONUS
                                    : (matchResult.matches.count == 2)
                                      ? THREE_TWO_MATCH_BONUS
                                      : THREE_THREE_MATCH_BONUS);
  self.score += points;
  for (Card *card in self.chosenCards) {
    card.matched = YES;
  }
  [self.chosenCards removeAllObjects];
}

- (void) handleMismatch {
  self.score -= MISMATCH_PENALTY;
  Card *cardToUnchoose = self.chosenCards[self.chosenCards.count-1];
  cardToUnchoose.chosen = NO;
  [self.chosenCards removeObject:cardToUnchoose];
}

- (void)chooseCardAtIndex: (NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  if (!card.matched) {
    if (card.chosen) {
      card.chosen = NO;
      [self.chosenCards removeObject:card];
    } else {
      self.score -= COST_TO_CHOOSE;
      card.chosen = YES;
      
      if (self.chosenCards.count == 0) {
        [self.chosenCards addObject:card];
        return;
      }
      [self.chosenCards insertObject:card atIndex:0];
      // Max number of cards flipped
      if (self.chosenCards.count == self.mode) {
        MatchResult matchResult = [self checkForMatch];
        // Match
        if(matchResult.score > 0) {
          [self handleMatch:matchResult];
        } else { // No match
          [self handleMismatch];
        }
      }
    }
  }
}

@end

NS_ASSUME_NONNULL_END
