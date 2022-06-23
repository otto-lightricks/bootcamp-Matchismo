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

- (NSArray *)defaultShapes {
  return @[@"●", @"■", @"▲"];
}

- (NSArray *)defaultColors {
  return @[UIColor.redColor, UIColor.greenColor, UIColor.purpleColor];
}

- (instancetype)init {
  return [self initWithShapes:[self defaultShapes] colors:[self defaultColors]];
}

- (instancetype)initWithShapes:(NSArray *)shapes colors:(NSArray *)colors {
  if (self = [super init]) {
    if (shapes.count != 3) {
      shapes = [self defaultShapes];
    }
    if (colors.count != 3) {
      colors = [self defaultColors];
    }
    for (NSUInteger noOfShapes = 1; noOfShapes < 4; noOfShapes++) {
      for (NSString *shape in shapes) {
        for (UIColor *color in colors) {
          for (int shadingVal = 0; shadingVal < setCardShadingCount; shadingVal++) {
            SetCardShading shading = static_cast<SetCardShading>(shadingVal);
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
