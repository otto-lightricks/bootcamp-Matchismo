//
//  Deck.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Deck : NSObject

@property (nonatomic) NSUInteger size;

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
