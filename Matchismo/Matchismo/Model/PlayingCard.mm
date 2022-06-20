//
//  PlayingCard.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "PlayingCard.h"

#import <UIKit/UIKit.h>

@implementation PlayingCard

@synthesize suit = _suit;

+ (NSArray *)rankStrings {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
  return [self rankStrings].count - 1;
}

+ (NSArray *)validSuits {
  return @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
}

- (NSAttributedString *)contents {
  auto rankStrings = [PlayingCard rankStrings];
  
  auto textColor = ([self.suit isEqualToString:@"♥︎"] || [self.suit isEqualToString:@"♦︎"])
                          ? UIColor.redColor : UIColor.blackColor;
  
  NSMutableDictionary *attributes = [@{NSForegroundColorAttributeName:textColor}
                                      mutableCopy];
  return [[NSAttributedString alloc] initWithString:[rankStrings[self.rank]
                                                     stringByAppendingString:self.suit]
                                         attributes:attributes];
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

