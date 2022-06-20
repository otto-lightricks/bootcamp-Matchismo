//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#import "SetCardDeck.h"

#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)initWithShapes:(NSArray *)shapes Colors:(NSArray *)colors {
  if (self = [super init]) {
    if (shapes.count != 3 || colors.count != 3) return nil;
    for (NSUInteger noOfShapes = 1; noOfShapes < 4; noOfShapes++) {
      for (NSString *shape in shapes) {
        for (UIColor *color in colors) {
          for (int shadingVal = 0; shadingVal < setCardShadingCount; shadingVal++) {
            auto card = [[SetCard alloc] init];
            card.noOfShapes = noOfShapes;
            card.shape = shape;
            card.color = color;
            SetCardShading shading = static_cast<SetCardShading>(shadingVal);
            card.shading = shading;
            [self addCard:card];
          }
        }
      }
    }
  }
  return self;
}

@end
