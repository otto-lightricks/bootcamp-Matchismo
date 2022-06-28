//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Otto Olkkonen on 10/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GameMode) {
  twoCard = 2,
  threeCard = 3
};

typedef NS_ENUM(NSInteger, GamePoints) {
  COST_TO_CHOOSE = 1,
  MISMATCH_PENALTY = 2,
  THREE_TWO_MATCH_BONUS = 3,
  TWO_MATCH_BONUS = 4,
  THREE_THREE_MATCH_BONUS = 5
};

@class Card, Deck;

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex: (NSUInteger)index;
- (Card *)cardAtIndex: (NSUInteger)index;
- (BOOL)startNewGameWithCardCount: (NSUInteger)count usingDeck: (Deck *)deck;
- (void)addCard:(Card *)card;
- (void)removeCard:(Card *)card;

@property (readonly, nonatomic) NSInteger score;
@property (nonatomic) GameMode mode;

@end

NS_ASSUME_NONNULL_END
