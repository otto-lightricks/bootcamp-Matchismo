//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Otto Olkkonen on 10/06/2022.
//

#import "CardMatchingGame.h"

#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSString * lastCardFlipDescription;
@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic, strong) NSMutableArray<Card *> *chosenCards;
@end

@implementation CardMatchingGame

- (NSMutableArray<Card *> *)cards {
  if (!_cards) _cards = [[NSMutableArray<Card *> alloc] init];
  return _cards;
}

- (NSMutableArray<Card *> *)chosenCards {
  if (!_chosenCards) _chosenCards = [[NSMutableArray<Card *> alloc] init];
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

constexpr int TWO_MATCH_BONUS = 4;
constexpr int THREE_THREE_MATCH_BONUS = 5;
constexpr int THREE_TWO_MATCH_BONUS = 3;
constexpr int MISMATCH_PENALTY = 2;
constexpr int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex: (NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  if (!card.matched) {
    if (card.chosen) {
      card.chosen = NO;
      [self.chosenCards removeObject:card];
      self.lastCardFlipDescription = @"";
    } else {
      self.score -= COST_TO_CHOOSE;
      card.chosen = YES;
      
      if (self.chosenCards.count == 0) {
        [self.chosenCards addObject:card];
        self.lastCardFlipDescription = card.contents;
        return;
      }
      
      // Max number of cards flipped
      if (self.chosenCards.count + 1 == self.mode) {
        MatchResult matchResult = [card match:self.chosenCards];
        // If more than one card chosen, compare all cards with each other to find the best match
        if (self.chosenCards.count > 1) {
          for (Card *chosenCard in self.chosenCards) {
            NSMutableArray<Card *> *cardsToCompare = [@[card] mutableCopy];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contents != %@",
                                                                      chosenCard.contents];
            NSArray<Card *> *otherCards = [self.chosenCards filteredArrayUsingPredicate:predicate];
            [cardsToCompare addObjectsFromArray:otherCards];
            MatchResult res = [chosenCard match:cardsToCompare];
            // Update match result if better match found
            if (res.score > matchResult.score) {
              matchResult = res;
            }
          }
        }
        // Match
        if(matchResult.score) {
          int points = matchResult.score * (self.mode == GameMode::two
                                            ? TWO_MATCH_BONUS
                                            : (matchResult.matches.count == 2)
                                              ? THREE_TWO_MATCH_BONUS
                                              : THREE_THREE_MATCH_BONUS);
          self.score += points;
          card.matched = YES;
          for (Card * c in self.chosenCards) {
            c.matched = YES;
          }
          NSString *description = @"Matched";
          for (Card *c in matchResult.matches) {
            description = [description stringByAppendingString:[NSString stringWithFormat:@" %@", c.contents]];
          }
          description = [description stringByAppendingString:[NSString stringWithFormat:@" for %d points.", points]];
          self.lastCardFlipDescription = description;
          [self.chosenCards removeAllObjects];
        } else { // No match
          self.score -= MISMATCH_PENALTY;
          Card *cardToUnchoose = self.chosenCards[self.chosenCards.count-1];
          cardToUnchoose.chosen = NO;
          [self.chosenCards removeObject:cardToUnchoose];
          [self.chosenCards insertObject:card atIndex:0];
          self.lastCardFlipDescription = [NSString stringWithFormat:@"No match! %d point penalty!",
                                          MISMATCH_PENALTY];
        }
      } else { // More cards can be flipped
        [self.chosenCards insertObject:card atIndex:0];
        self.lastCardFlipDescription = card.contents;
      }
    }
  }
}

@end
