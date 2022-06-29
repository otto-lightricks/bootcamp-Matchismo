//
//  SetCardDeck.h
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardDeck : Deck

- (instancetype)initWithColors:(NSArray *)colors NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
