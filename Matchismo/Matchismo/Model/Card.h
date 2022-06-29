//
//  Card.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

struct MatchResult {
  int score;
  NSMutableArray<Card *> *matches;
};

@property (readonly, nonatomic) NSString *contents;
@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;

- (MatchResult)match:(NSArray *)otherCards;

@end

NS_ASSUME_NONNULL_END
