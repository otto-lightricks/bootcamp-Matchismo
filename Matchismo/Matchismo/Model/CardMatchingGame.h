//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Otto Olkkonen on 10/06/2022.
//

#import <Foundation/Foundation.h>

@class Card, Deck;

@interface CardMatchingGame : NSObject

enum GameMode : int {
  two = 2,
  three = 3
};

- (instancetype)initWithCardCount: (NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex: (NSUInteger)index;
- (Card *)cardAtIndex: (NSUInteger)index;
- (BOOL)startNewGameWithCardCount: (NSUInteger)count usingDeck: (Deck *)deck;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) enum GameMode mode;
@property (nonatomic, readonly) NSString *lastCardFlipDescription;

@end
