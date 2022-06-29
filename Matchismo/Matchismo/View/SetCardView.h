//
//  SetCardView.h
//  Matchismo
//
//  Created by Otto Olkkonen on 21/06/2022.
//

#import "CardView.h"

#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : CardView

@property (nonatomic) NSUInteger numberOfShapes;
@property (nonatomic) SetCardShape shape;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) UIColor *color;
 
@end

NS_ASSUME_NONNULL_END
