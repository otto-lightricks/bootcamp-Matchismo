//
//  SetCardDeck.h
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#import "Deck.h"

@interface SetCardDeck : Deck

- (instancetype)initWithShapes:(NSArray *)shapes Colors:(NSArray *)colors;

@end
