//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Otto Olkkonen on 10/06/2022.
//

#import <Foundation/Foundation.h>

@class Card, Deck;

@interface CardMatchingGame : NSObject

typedef enum {
  two = 2,
  three = 3
} GameMode;

- (instancetype)initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex: (NSUInteger)index;
- (Card *)cardAtIndex: (NSUInteger)index;
- (BOOL)startNewGameWithCardCount: (NSUInteger)count usingDeck: (Deck *)deck;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) GameMode mode;
@property (nonatomic, readonly) NSAttributedString *lastMoveDescription;
@property (nonatomic) NSMutableAttributedString *moveHistory;

@end
