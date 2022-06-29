//
//  SetCardView.m
//  Matchismo
//
//  Created by Otto Olkkonen on 21/06/2022.
//

#import "SetCardView.h"

#import "CardViewConstants.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardView

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (self.numberOfShapes == 1) {
    [self drawOneShape];
  }
  if (self.numberOfShapes == 2) {
    [self drawTwoShapes];
  }
  if (self.numberOfShapes == 3) {
    [self drawThreeShapes];
  }
}

- (void)drawOneShape {
  switch (self.shape) {
    case setCardShapeDiamond:
      [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width / 2,
                                           self.bounds.size.height / 2)];
      break;
    case setCardShapeOval:
      [self drawOvalAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        self.bounds.size.height / 2)];
      break;
    case setCardShapeSquiggle:
      [self drawSquiggleAtPoint:CGPointMake(self.bounds.size.width / 2,
                                            self.bounds.size.height/2)];
      break;
    default:
      break;
  }
}

- (void)drawTwoShapes {
  CGFloat firstSymbolY = ((self.bounds.size.height / 2)
                         - (self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR) / 2
                         - SYMBOL_GAP * self.bounds.size.height);
  CGFloat secondSymbolY = ((self.bounds.size.height / 2)
                          + (self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR) / 2
                          + SYMBOL_GAP * self.bounds.size.height);
  switch (self.shape) {
    case setCardShapeDiamond:
      [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width / 2,
                                           firstSymbolY)];
      [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width / 2,
                                           secondSymbolY)];
      break;
    case setCardShapeOval:
      [self drawOvalAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        firstSymbolY)];
      [self drawOvalAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        secondSymbolY)];
      break;
    case setCardShapeSquiggle:
      [self drawSquiggleAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        firstSymbolY)];
      [self drawSquiggleAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        secondSymbolY)];
      break;
    default:
      break;
  }
}

- (void)drawThreeShapes {
  CGFloat firstSymbolY = ((self.bounds.size.height / 2)
                         - (self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR)
                         - SYMBOL_GAP * self.bounds.size.height);
  CGFloat secondSymbolY = self.bounds.size.height / 2;
  CGFloat thirdSymbolY = ((self.bounds.size.height / 2)
                         + (self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR)
                         + SYMBOL_GAP * self.bounds.size.height);
  
  switch (self.shape) {
    case setCardShapeDiamond:
      [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width / 2,
                                           firstSymbolY)];
      [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width / 2,
                                           secondSymbolY)];
      [self drawDiamondAtPoint:CGPointMake(self.bounds.size.width / 2,
                                           thirdSymbolY)];
      break;
    case setCardShapeOval:
      [self drawOvalAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        firstSymbolY)];
      [self drawOvalAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        secondSymbolY)];
      [self drawOvalAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        thirdSymbolY)];
      break;
    case setCardShapeSquiggle:
      [self drawSquiggleAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        firstSymbolY)];
      [self drawSquiggleAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        secondSymbolY)];
      [self drawSquiggleAtPoint:CGPointMake(self.bounds.size.width / 2,
                                        thirdSymbolY)];
      break;
    default:
      break;
  }
}

- (void)drawOvalAtPoint:(CGPoint)point {
  const auto context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  auto size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_SCALE_FACTOR,
                           self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR);
  
  auto ovalRect = [UIBezierPath bezierPathWithRoundedRect:
                                        CGRectMake(point.x - size.width / 2,
                                                   point.y - size.height / 2,
                                                   size.width,
                                                   size.height)
                                                   cornerRadius: OVAL_CORNER_RADIUS
                                                                 * [self cornerScaleFactor]];
  [ovalRect addClip];
  [self applyShadingToPath:ovalRect];
  CGContextRestoreGState(context);
}

- (void)drawDiamondAtPoint:(CGPoint)point {
  const auto context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  auto size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_SCALE_FACTOR,
                           self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR);
  
  auto path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(point.x, point.y - size.height / 2)];
  [path addLineToPoint:CGPointMake(point.x + size.width / 2, point.y)];
  [path addLineToPoint:CGPointMake(point.x, point.y + size.height / 2)];
  [path addLineToPoint:CGPointMake(point.x - size.width / 2, point.y)];
  [path closePath];
  
  [path addClip];
  [self applyShadingToPath:path];
  CGContextRestoreGState(context);
}

- (void)drawSquiggleAtPoint:(CGPoint)point {
  const auto context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  auto size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_SCALE_FACTOR,
                           self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR);

  auto path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(104, 15)];
  [path addCurveToPoint:CGPointMake(63, 54)
          controlPoint1:CGPointMake(112.4, 36.9)
          controlPoint2:CGPointMake(89.7, 60.8)];
  [path addCurveToPoint:CGPointMake(27, 53)
          controlPoint1:CGPointMake(52.3, 51.3)
          controlPoint2:CGPointMake(42.2, 42)];
  [path addCurveToPoint:CGPointMake(5, 40)
          controlPoint1:CGPointMake(9.6, 65.6)
          controlPoint2:CGPointMake(5.4, 58.3)];
  [path addCurveToPoint:CGPointMake(36, 12)
          controlPoint1:CGPointMake(4.6, 22)
          controlPoint2:CGPointMake(19.1, 9.7)];
  [path addCurveToPoint:CGPointMake(89, 14)
          controlPoint1:CGPointMake(59.2, 15.2)
          controlPoint2:CGPointMake(61.9, 31.5)];
  [path addCurveToPoint:CGPointMake(104, 15)
          controlPoint1:CGPointMake(95.3, 10)
          controlPoint2:CGPointMake(100.9, 6.9)];

  auto scale = CGAffineTransformMakeScale(1.0 * size.width / 100, 1.0 * size.height / 50);
  [path applyTransform:scale];
  CGFloat translationX = point.x - size.width / 2 - 3 * size.width / 100;
  CGFloat translationY = point.y - size.height / 2 - 8 * size.height / 50;
  auto translation = CGAffineTransformMakeTranslation(translationX, translationY);
  [path applyTransform:translation];
  
  [path addClip];
  [self applyShadingToPath:path];
  CGContextRestoreGState(context);
}

- (void)applyShadingToPath:(UIBezierPath *)path {
  switch (self.shading) {
    case setCardShadingSolid:
      [self.color setFill];
      [path fill];
      break;
    case setCardShadingStriped:
      [self drawStripedShadingForPath:path];
      break;
    default:
      break;
  }
  
  [self.color setStroke];
  [path stroke];
}

- (void)drawStripedShadingForPath:(UIBezierPath *)pathOfSymbol {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  CGRect bounds = [pathOfSymbol bounds];
  auto path = [[UIBezierPath alloc] init];

  for (int i = 0; i < bounds.size.width; i += SYMBOL_STRIPE_GAP) {
    [path moveToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y)];
    [path addLineToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y + bounds.size.height)];
  }
  
  [self.color setStroke];
  [path stroke];

  CGContextRestoreGState(context);
}

@end

NS_ASSUME_NONNULL_END
