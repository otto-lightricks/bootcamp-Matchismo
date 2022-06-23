//
//  AbstractCardGameViewController.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CardMatchingGame, Deck;

@interface AbstractCardGameViewController : UIViewController

@property (readonly, nonatomic) Deck *deck;
@property (readonly, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *cardsCollection;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (Deck *)createDeck;
- (void)startNewGame;
- (void)updateUI;
- (void)handleCardSelectionAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
