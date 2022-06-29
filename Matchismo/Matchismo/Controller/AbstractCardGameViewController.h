//
//  AbstractCardGameViewController.h
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Card, CardMatchingGame, CardView, Deck;

@interface AbstractCardGameViewController : UIViewController

@property (nonatomic) Deck *deck;
@property (nonatomic) CardMatchingGame *game;
@property (nonatomic) NSMutableArray<CardView *>* cardViews;
@property (readonly, nonatomic) CGFloat defaultGapBetweenCards;
@property (readonly, nonatomic) int defaultNumberOfCardsPerRow;
@property (readonly, nonatomic) int defaultNumberOfCards;
@property (nonatomic) int numberOfCardsPerRow;
@property (readonly, nonatomic) CGFloat cardWidth;
@property (readonly, nonatomic) CGFloat cardHeight;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardsView;

- (Deck *)createDeck;
- (void)startNewGame;
- (void)setUpCards;
- (void)createCardViewToPoint:(CGPoint)point withCard:(Card *)card;
- (CardView *)createCardViewWithFrame:(CGRect)frame withCard:(Card *)card;
- (void)resizeCards;
- (BOOL)cardsViewTooLarge;
- (void)updateUI;
- (void)handleCardSelectionAtIndex:(int)index;
- (void)animateCardView:(CardView *)cardView toPosition:(CGPoint)point withDelay:(CGFloat)delay;

@end

NS_ASSUME_NONNULL_END
