//
//  Deck.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Card;

@interface Deck : NSObject

@property (readonly, nonatomic) NSUInteger size;
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;

@end

NS_ASSUME_NONNULL_END
