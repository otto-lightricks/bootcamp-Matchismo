//
//  SetCard.m
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#include "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCard()

@property (readwrite, nonatomic) NSUInteger numberOfShapes;
@property (readwrite, nonatomic) SetCardShape shape;
@property (readwrite, nonatomic) SetCardShading shading;
@property (readwrite, nonatomic) UIColor *color;

@end

@implementation SetCard

- (instancetype)initWithNumberOfShapes:(NSUInteger)numberOfShapes
                                 shape:(SetCardShape)shape
                               shading:(SetCardShading)shading
                                 color:(UIColor *)color {
  if (self = [super init]) {
    self.numberOfShapes = numberOfShapes;
    self.shape = shape;
    self.shading = shading;
    self.color = color;
  }
  return self;
}

- (NSString *)contents {
  return nil;
}

// Checks if all setcards have the same number of shapes
- (BOOL)checkEqualNumberOfShapes:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (card.numberOfShapes != self.numberOfShapes) {
      return NO;
    }
  }
  return YES;
}

// Checks if all setcards have different number of shapes
- (BOOL)checkDifferentNumberOfShapes:(NSArray<SetCard *> *)otherCards {
  NSMutableSet<NSNumber *> *set = [[NSMutableSet alloc] init];
  [set addObject:@(self.numberOfShapes)];
  for (SetCard *card in otherCards) {
    if ([set containsObject:@(card.numberOfShapes)]) {
      return NO;
    } else {
      [set addObject:@(card.numberOfShapes)];
    }
  }
  return YES;
}

// Checks if all setcards have the same shapes
- (BOOL)checkEqualShapes:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (card.shape != self.shape) {
      return NO;
    }
  }
  return YES;
}

// Checks if all setcards have different shapes
- (BOOL)checkDifferentShapes:(NSArray<SetCard *> *)otherCards {
  NSMutableSet<NSNumber *> *set = [[NSMutableSet alloc] init];
  [set addObject:@(self.shape)];
  for (SetCard *card in otherCards) {
    if ([set containsObject:@(card.shape)]) {
      return NO;
    } else {
      [set addObject:@(card.shape)];
    }
  }
  return YES;
}

// Checks if all setcards have the same shadings
- (BOOL)checkEqualShadings:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (card.shading != self.shading) {
      return NO;
    }
  }
  return YES;
}

// Checks if all setcards have different shadings
- (BOOL)checkDifferentShadings:(NSArray<SetCard *> *)otherCards {
  NSMutableSet<NSNumber *> *set = [[NSMutableSet alloc] init];
  [set addObject:@(self.shading)];
  for (SetCard *card in otherCards) {
    if ([set containsObject:@(card.shading)]) {
      return NO;
    } else {
      [set addObject:@(card.shading)];
    }
  }
  return YES;
}

// Checks if all setcards have the same colors
- (BOOL)checkEqualColors:(NSArray<SetCard *> *)otherCards {
  for (SetCard *card in otherCards) {
    if (![card.color isEqual:self.color]) {
      return NO;
    }
  }
  return YES;
}

// Checks if all setcards have different colors
- (BOOL)checkDifferentColors:(NSArray<SetCard *> *)otherCards {
  NSMutableSet<UIColor *> *set = [[NSMutableSet alloc] init];
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

- (MatchResult)match:(NSArray *)otherCards {
  MatchResult result;
  result.score = 0;
  const auto noOfShapesCondition = [self checkEqualNumberOfShapes:otherCards]
                                     || [self checkDifferentNumberOfShapes:otherCards];
  const auto shapeCondition = [self checkEqualShapes:otherCards]
                                || [self checkDifferentShapes:otherCards];
  const auto shadingCondition = [self checkEqualShadings:otherCards]
                                  || [self checkDifferentShadings:otherCards];
  const auto colorCondition = [self checkEqualColors:otherCards]
                                || [self checkDifferentColors:otherCards];
  BOOL isMatch = (noOfShapesCondition && shapeCondition
                   && shadingCondition && colorCondition);
  if (isMatch) {
    result.score = 3;
    result.matches = [otherCards mutableCopy];
    [result.matches addObject:self];
  }
  
  return result;
}

@end

NS_ASSUME_NONNULL_END
