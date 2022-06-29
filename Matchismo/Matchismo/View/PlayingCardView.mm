//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Otto Olkkonen on 20/06/2022.
//

#import "PlayingCardView.h"

#import "CardViewConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

- (CGFloat)faceCardScaleFactor {
  if (!_faceCardScaleFactor) {
    _faceCardScaleFactor = DEFAULT_FACE_SCALE_FACTOR;
  }
  return  _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

- (NSString *)rankAsString {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"]
          [self.rank];
}

- (UIColor *)textColor {
  return ([self.suit isEqualToString:@"♥︎"] || [self.suit isEqualToString:@"♦︎"])
           ? UIColor.redColor : UIColor.blackColor;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (self.faceUp) {
    const auto faceImage = [UIImage imageNamed:[NSString
                                                stringWithFormat:@"%@%@",
                                                [self rankAsString], self.suit]];
    if (faceImage) {
      const auto imageRect = CGRectInset(self.bounds,
                                         self.bounds.size.width * (1.0-self.faceCardScaleFactor),
                                         self.bounds.size.height * (1.0-self.faceCardScaleFactor));
      [faceImage drawInRect:imageRect];
    } else {
      [self drawPips];
    }

    [self drawCorners];
  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }
}

- (void)drawCorners {
  auto paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  auto cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  
  auto attributes = @{NSFontAttributeName : cornerFont,
                      NSParagraphStyleAttributeName : paragraphStyle,
                      NSForegroundColorAttributeName : [self textColor]};
  
  auto cornerText = [[NSAttributedString alloc] initWithString:
                      [NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit]
                                                    attributes:attributes];
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
  
  const auto context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
  [cornerText drawInRect:textBounds];
  
}

- (void)drawPips {
  if ((self.rank == 1)
      || (self.rank == 3)
      || (self.rank == 5)
      || (self.rank == 9)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 6)
      || (self.rank == 7)
      || (self.rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 2)
      || (self.rank == 3)
      || (self.rank == 7)
      || (self.rank == 8)
      || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.rank != 7)];
  }
  if ((self.rank == 4)
      || (self.rank == 5)
      || (self.rank == 6)
      || (self.rank == 7)
      || (self.rank == 8)
      || (self.rank == 9)
      || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];
  }
  if ((self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hOffset
                      verticalOffset:(CGFloat)vOffset
                          upsideDown:(BOOL)upsideDown {
  if (upsideDown) {
    [self pushContextAndRotateUpsideDown];
  }
  const auto middle = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
  auto pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:
                pipFont.pointSize * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  const auto attributedSuit = [[NSAttributedString alloc]
                                 initWithString:self.suit
                                     attributes:@{NSFontAttributeName : pipFont,
                                                  NSForegroundColorAttributeName : [self textColor]
                                                }];
  const auto pipSize = attributedSuit.size;
  auto pipOrigin = CGPointMake(middle.x-pipSize.width/2-hOffset*self.bounds.size.width,
                                     middle.y-pipSize.height/2-vOffset*self.bounds.size.height);
  [attributedSuit drawAtPoint:pipOrigin];
  if (hOffset) {
    pipOrigin.x += 2 * hOffset * self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) {
    [self popContext];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hOffset
                      verticalOffset:(CGFloat)vOffset
                  mirroredVertically:(BOOL)mirroredVerically {
  [self drawPipsWithHorizontalOffset:hOffset verticalOffset:vOffset upsideDown:NO];
  if (mirroredVerically) {
    [self drawPipsWithHorizontalOffset:hOffset verticalOffset:vOffset upsideDown:YES];
  }
  
}

- (void)pushContextAndRotateUpsideDown {
  const auto context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
  if ((gesture.state == UIGestureRecognizerStateChanged)
      || (gesture.state == UIGestureRecognizerStateEnded)) {
    self.faceCardScaleFactor *= gesture.scale;
    gesture.scale = 1.0;
  }
}

@end

NS_ASSUME_NONNULL_END
