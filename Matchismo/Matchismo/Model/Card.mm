//
//  Card.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Card

- (MatchResult)match:(NSArray<Card *> *)otherCards {
  MatchResult res;
  res.score = 0;
  res.matches = [[NSMutableArray alloc] init];
  for (Card *card in otherCards) {
    if ([card.contents isEqualToString:self.contents]) {
      res.score++;
      [res.matches addObject:card];
    }
  }
    return res;
}

@end

NS_ASSUME_NONNULL_END
