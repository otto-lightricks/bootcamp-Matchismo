//
//  SetCard.h
//  Matchismo
//
//  Created by Otto Olkkonen on 15/06/2022.
//

#import "Card.h"

#import <UIKit/UIKit.h>

@interface SetCard : Card

typedef enum {
  setCardShadingOpen,
  setCardShadingSolid,
  setCardShadingStriped,
  setCardShadingCount
} SetCardShading;

@property (nonatomic) NSUInteger noOfShapes;
@property (nonatomic) NSString *shape;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) UIColor *color;
@property (nonatomic) NSMutableDictionary *attributes;


@end
