//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <UIKit/UIKit.h>

@class CardMatchingGame, Deck;

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardsCollection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (Deck *)createDeck;
- (void)startNewGame;
- (void)updateUI;
- (void)handleCardSelectionAtIndex:(NSUInteger)index;

@end

