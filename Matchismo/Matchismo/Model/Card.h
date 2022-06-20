//
//  Card.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

struct MatchResult {
  int score;
  NSMutableArray<Card *> *matches;
};

@property (strong, nonatomic) NSAttributedString *contents;
@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;

- (MatchResult)match:(NSArray *)otherCards;

@end
