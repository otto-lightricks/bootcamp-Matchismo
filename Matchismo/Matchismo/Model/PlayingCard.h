//
//  PlayingCard.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard : Card

@property (readonly, nonatomic) NSString *suit;
@property (readonly, nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

- (instancetype)initWithSuit:(NSString *)suit rank:(NSUInteger)rank;

@end

NS_ASSUME_NONNULL_END
