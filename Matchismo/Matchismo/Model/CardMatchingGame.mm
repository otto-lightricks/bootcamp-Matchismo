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
@property (nonatomic, readwrite) NSAttributedString * lastMoveDescription;
@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic, strong) NSMutableArray<Card *> *chosenCards;
@end

@implementation CardMatchingGame

constexpr int TWO_MATCH_BONUS = 4;
constexpr int THREE_THREE_MATCH_BONUS = 5;
constexpr int THREE_TWO_MATCH_BONUS = 3;
constexpr int MISMATCH_PENALTY = 2;
constexpr int COST_TO_CHOOSE = 1;

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

- (void)setLastMoveDescription:(NSAttributedString *)lastMoveDescription {
  _lastMoveDescription = lastMoveDescription;
  if (![lastMoveDescription isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]) {
    if (!self.moveHistory) {
      self.moveHistory = [[NSMutableAttributedString alloc] initWithAttributedString:lastMoveDescription];
    } else {
      [self.moveHistory appendAttributedString:self.lastMoveDescription];
    }
    [self.moveHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\r"]];
  }
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
  self.moveHistory = [[NSMutableAttributedString alloc] initWithString:@""];
  return YES;
}

- (Card *)cardAtIndex: (NSUInteger)index {
  return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex: (NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  if (!card.matched) {
    if (card.chosen) {
      card.chosen = NO;
      [self.chosenCards removeObject:card];
      self.lastMoveDescription = [[NSAttributedString alloc] initWithString:@""];
    } else {
      self.score -= COST_TO_CHOOSE;
      card.chosen = YES;
      
      if (self.chosenCards.count == 0) {
        [self.chosenCards addObject:card];
        self.lastMoveDescription = card.contents;
        return;
      }
      
      // Max number of cards flipped
      if (self.chosenCards.count + 1 == self.mode) {
        MatchResult matchResult = [card match:self.chosenCards];
        // If more than one card chosen, compare all cards with each other to find the best match
        if (self.chosenCards.count > 1) {
          for (Card *chosenCard in self.chosenCards) {
            NSMutableArray<Card *> *cardsToCompare = [@[card] mutableCopy];
            
            auto predicate = [NSPredicate predicateWithFormat:@"contents != %@",
                                                                      chosenCard.contents];
            auto otherCards = [self.chosenCards filteredArrayUsingPredicate:predicate];
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
          NSMutableAttributedString *descriptionString = [[[NSAttributedString alloc]
                                                             initWithString: @"Matched"]
                                                          mutableCopy];
          for (Card *c in matchResult.matches) {
            [descriptionString appendAttributedString:[[NSAttributedString alloc]
                                                         initWithString:@" "]];
            [descriptionString appendAttributedString:c.contents];
          }
          [descriptionString appendAttributedString:
             [[NSAttributedString alloc] initWithString:
                [NSString stringWithFormat:@" for %d points.", points]]];
          [self.chosenCards addObject:card];
          self.lastMoveDescription = descriptionString;
          [self.chosenCards removeAllObjects];
        } else { // No match
          self.score -= MISMATCH_PENALTY;
          Card *cardToUnchoose = self.chosenCards[self.chosenCards.count-1];
          cardToUnchoose.chosen = NO;
          [self.chosenCards insertObject:card atIndex:0];
          NSMutableAttributedString *descriptionString = [[[NSAttributedString alloc]
                                                           initWithAttributedString:
                                                             card.contents] mutableCopy];
          for (Card *c in self.chosenCards) {
            if (c == card) continue;
            [descriptionString appendAttributedString:[[NSAttributedString alloc]
                                                         initWithString:@" "]];
            [descriptionString appendAttributedString:c.contents];
          }
          [descriptionString appendAttributedString:
             [[NSAttributedString alloc] initWithString:
                [NSString stringWithFormat:@" don't match! %d point penalty!", MISMATCH_PENALTY]]];
          self.lastMoveDescription = descriptionString;
          [self.chosenCards removeObject:cardToUnchoose];
        }
      } else { // More cards can be flipped
        [self.chosenCards insertObject:card atIndex:0];
        self.lastMoveDescription = card.contents;
      }
    }
  }
}

@end
