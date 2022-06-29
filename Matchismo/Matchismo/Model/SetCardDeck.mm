//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#import "SetCardDeck.h"

#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardDeck


- (NSArray *)defaultColors {
  return @[UIColor.redColor, UIColor.greenColor, UIColor.purpleColor];
}

- (instancetype)init {
  return [self initWithColors:[self defaultColors]];
}

- (instancetype)initWithColors:(NSArray *)colors {
  if (self = [super init]) {
    if (colors.count != 3) {
      colors = [self defaultColors];
    }
    
    for (NSUInteger noOfShapes = 1; noOfShapes < 4; noOfShapes++) {
      for (int shapeVal = 0; shapeVal < setCardShapeCount; shapeVal++) {
        for (UIColor *color in colors) {
          for (int shadingVal = 0; shadingVal < setCardShadingCount; shadingVal++) {
            SetCardShading shading = static_cast<SetCardShading>(shadingVal);
            SetCardShape shape = static_cast<SetCardShape>(shapeVal);
            auto card = [[SetCard alloc] initWithNumberOfShapes:noOfShapes
                                                          shape:shape
                                                        shading:shading
                                                          color:color];
            [self addCard:card];
          }
        }
      }
    }
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
