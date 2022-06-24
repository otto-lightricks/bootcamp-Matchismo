//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Otto Olkkonen on 20/06/2022.
//

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
