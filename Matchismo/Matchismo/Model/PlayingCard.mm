//
//  PlayingCard.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "PlayingCard.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard()

@property (readwrite, nonatomic) NSString *suit;
@property (readwrite, nonatomic) NSUInteger rank;

@end

@implementation PlayingCard

@synthesize suit = _suit;

- (instancetype)initWithSuit:(NSString *)suit rank:(NSUInteger)rank {
  if (self = [super init]) {
    self.suit = suit;
    self.rank = rank;
  }
  return self;
}

+ (NSArray<NSString *> *)rankStrings {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
  return [self rankStrings].count - 1;
}

+ (NSArray<NSString *> *)validSuits {
  return @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
}

- (NSString *)contents {
  return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit {
  if ([[PlayingCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

- (NSString *)suit {
  return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
  if (rank <= [PlayingCard maxRank]) {
    _rank = rank;
  }
}

- (MatchResult)match:(NSArray *)otherCards {
  MatchResult res;
  res.score = 0;
  res.matches = [[NSMutableArray alloc] init];
  for (PlayingCard * otherCard in otherCards) {
    if (otherCard.rank == self.rank) {
      res.score += 4;
      [res.matches addObject:otherCard];
    } else if (otherCard.suit == self.suit) {
      res.score++;
      [res.matches addObject:otherCard];
    }
  }
  [res.matches addObject:self];
  return res;
}

@end

NS_ASSUME_NONNULL_END
