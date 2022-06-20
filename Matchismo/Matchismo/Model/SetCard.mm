//
//  SetCard.m
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#include "SetCard.h"

@interface SetCard()
- (BOOL)allSameNoOfShapes:(NSArray<SetCard *> *)otherCards;
- (BOOL)allDifferentNoOfShapes:(NSArray<SetCard *> *)otherCards;
- (BOOL)allSameShape:(NSArray<SetCard *> *)otherCards;
- (BOOL)allDifferentShape:(NSArray<SetCard *> *)otherCards;
- (BOOL)allSameShading:(NSArray<SetCard *> *)otherCards;
- (BOOL)allDifferentShading:(NSArray<SetCard *> *)otherCards;
- (BOOL)allSameColor:(NSArray<SetCard *> *)otherCards;
- (BOOL)allDifferentColor:(NSArray<SetCard *> *)otherCards;
@end

@implementation SetCard

- (NSMutableDictionary *)attributes {
  NSMutableDictionary *att = [@{NSForegroundColorAttributeName:self.color}
                                     mutableCopy];
  
  switch (self.shading) {
    case setCardShadingSolid:
      att[NSStrokeWidthAttributeName] = @-5;
      break;
    case setCardShadingStriped:
      att[NSStrokeWidthAttributeName] = @-5;
      att[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInt:
                                                       NSUnderlineStyleDouble];
      att[NSStrikethroughColorAttributeName] = UIColor.whiteColor;
      break;
    case setCardShadingOpen:
      att[NSStrokeWidthAttributeName] = @5;
      break;
    default:
      break;
  }
  
  return att;
}

- (NSAttributedString *)contents {

  auto text = [NSString stringWithFormat:@"%llu %@",
                 (long long)self.noOfShapes,
                 self.shape];
  NSMutableDictionary *attributes = [@{NSForegroundColorAttributeName:self.color}
                                     mutableCopy];
  auto *attributedString = [[NSMutableAttributedString alloc]
                                                initWithString:text attributes:attributes];
  const auto range = [[attributedString string] rangeOfString:self.shape];
  [attributedString setAttributes:self.attributes range:range];
 
  return attributedString;
}

- (BOOL)allSameNoOfShapes:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (card.noOfShapes != self.noOfShapes) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allDifferentNoOfShapes:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *set = [[[NSSet alloc] init] mutableCopy];
  [set addObject:@(self.noOfShapes)];
  for (SetCard *card in otherCards) {
    if ([set containsObject:@(card.noOfShapes)]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allSameShape:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (card.shape != self.shape) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allDifferentShape:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *set = [[[NSSet alloc] init] mutableCopy];
  [set addObject:self.shape];
  for (SetCard *card in otherCards) {
    if ([set containsObject:card.shape]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allSameShading:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (card.shading != self.shading) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allDifferentShading:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *set = [[[NSSet alloc] init] mutableCopy];
  [set addObject:@(self.shading)];
  for (SetCard *card in otherCards) {
    if ([set containsObject:@(card.shading)]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allSameColor:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (![card.color isEqual:self.color]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)allDifferentColor:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *set = [[[NSSet alloc] init] mutableCopy];
  [set addObject:self.color];
  for (SetCard *card in otherCards) {
    if ([set containsObject:card.color]) {
      return NO;
    } else {
      [set addObject:card.color];
    }
  }
  return YES;
}

- (MatchResult) match:(NSArray *)otherCards {
  MatchResult result;
  const auto noOfShapesCondition = [self allSameNoOfShapes:otherCards]
                                     || [self allDifferentNoOfShapes:otherCards];
  const auto shapeCondition = [self allSameShape:otherCards]
                                || [self allDifferentShape:otherCards];
  const auto shadingCondition = [self allSameShading:otherCards]
                                  || [self allDifferentShading:otherCards];
  const auto colorCondition = [self allSameColor:otherCards]
                                || [self allDifferentColor:otherCards];
  result.score = (noOfShapesCondition && shapeCondition
                   && shadingCondition && colorCondition);
  if (result.score) {
    result.score = 3;
    result.matches = [otherCards mutableCopy];
    [result.matches addObject:self];
  }
  
  return result;
}

@end
