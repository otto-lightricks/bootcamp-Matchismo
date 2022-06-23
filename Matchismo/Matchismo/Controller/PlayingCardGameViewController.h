//
//  PlayingCardGameViewController.h
//  Matchismo
//
//  Created by Otto Olkkonen on 17/06/2022.
//

#import "AbstractCardGameViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PlayingCardGameModeControlIndex) {
  twoCardGameModeIndex = 0,
  threeCardGameModeIndex = 1
};

@interface PlayingCardGameViewController : AbstractCardGameViewController

@end

NS_ASSUME_NONNULL_END
