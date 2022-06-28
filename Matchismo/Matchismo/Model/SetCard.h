//
//  SetCard.h
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#import "Card.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SetCardShading) {
  setCardShadingOpen,
  setCardShadingSolid,
  setCardShadingStriped,
  setCardShadingCount
};

typedef NS_ENUM(NSInteger, SetCardShape) {
  setCardShapeDiamond,
  setCardShapeOval,
  setCardShapeSquiggle,
  setCardShapeCount
};

@interface SetCard : Card

@property (readonly, nonatomic) NSUInteger numberOfShapes;
@property (readonly, nonatomic) SetCardShape shape;
@property (readonly, nonatomic) SetCardShading shading;
@property (readonly, nonatomic) UIColor *color;

- (instancetype)initWithNumberOfShapes:(NSUInteger)numberOfShapes
                                 shape:(SetCardShape)shape
                               shading:(SetCardShading)shading
                                 color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
