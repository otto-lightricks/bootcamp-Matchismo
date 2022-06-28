//
//  CardView.m
//  Matchismo
//
//  Created by Otto Olkkonen on 24/06/2022.
//

#import "CardView.h"

#import "CardViewConstants.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CardView

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

-(void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

-(instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)drawRect:(CGRect)rect {
  const auto roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                      cornerRadius:[self cornerRadius]];
  
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
}

@end

NS_ASSUME_NONNULL_END
