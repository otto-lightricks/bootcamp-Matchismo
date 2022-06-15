//
//  PlayingCard.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
