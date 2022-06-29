//
//  AbstractCardGameViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 08/06/2022.
//

#import "AbstractCardGameViewController.h"

#import "Card.h"
#import "CardMatchingGame.h"
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractCardGameViewController() <UIDynamicAnimatorDelegate>

@property (readwrite, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIView *cardPileView;

@end

@implementation AbstractCardGameViewController

@synthesize numberOfCardsPerRow = _numberOfCardsPerRow;
@synthesize deck = _deck;

const CGFloat GAP_BETWEEN_CARDS = 8;
const int DEFAULT_NUMBER_OF_CARDS_PER_ROW = 4;
const int DEFAULT_NUMBER_OF_CARDS = 24;

- (CGFloat)defaultGapBetweenCards {
  return GAP_BETWEEN_CARDS;
}

- (int)defaultNumberOfCards {
  return DEFAULT_NUMBER_OF_CARDS;
}

- (int)defaultNumberOfCardsPerRow {
  return DEFAULT_NUMBER_OF_CARDS_PER_ROW;
}

- (void)setNumberOfCardsPerRow:(int)numberOfCardsPerRow {
  _numberOfCardsPerRow = numberOfCardsPerRow;
}

-(int)numberOfCardsPerRow {
  if (_numberOfCardsPerRow == 0) {
    _numberOfCardsPerRow = DEFAULT_NUMBER_OF_CARDS_PER_ROW;
  }
  return _numberOfCardsPerRow;
}

- (CGFloat)cardWidth {
  return (self.cardsView.bounds.size.width / self.numberOfCardsPerRow)
         - ((self.numberOfCardsPerRow - 1) * self.defaultGapBetweenCards)
         / self.numberOfCardsPerRow;
}

- (CGFloat)cardHeight {
  return [self cardWidth] * 1.2;
}

- (Deck *)deck {
  if (!_deck) {
    _deck = [self createDeck];
  }
  return _deck;
}

- (CardMatchingGame *)game {
  if (!_game) {
    _game = [self makeGame];
  }
  return _game;
}

- (UIDynamicAnimator *)animator {
  if(!_animator) {
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardsView];
    _animator.delegate = self;
  }
  return _animator;
}

- (CardMatchingGame *)makeGame {
  return nil;
}

- (Deck *)createDeck {
  NSAssert(NO, @"Abstract method, should not be called directly");
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cardViews = [[NSMutableArray alloc] init];
  [self.cardsView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(pinch:)]];
  [self setUpCards];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  const auto appearance = [[UITabBarAppearance alloc] init];
  [appearance setBackgroundColor:self.view.backgroundColor];
  [[self.tabBarController tabBar] setStandardAppearance:appearance];
  [[self.tabBarController tabBar] setScrollEdgeAppearance:appearance];
  
  const auto navBarAppeareance = [[UINavigationBarAppearance alloc] init];
  [navBarAppeareance setBackgroundColor:self.view.backgroundColor];
  [[self.navigationController navigationBar] setStandardAppearance:navBarAppeareance];
  [[self.navigationController navigationBar] setScrollEdgeAppearance:navBarAppeareance];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self resizeCards];
}

-(void) setUpCards {
  [self removeAllCardsFromView];
  CGFloat xPos = 0;
  CGFloat yPos = 0;
  
  for (int i = 1; i <= self.defaultNumberOfCards; i++) {
    Card *card = [self.game cardAtIndex:i-1];
    [self createCardViewToPoint:CGPointMake(xPos, yPos) withCard:card];
    if (i % [self numberOfCardsPerRow] == 0) {
      xPos = 0;
      yPos += self.cardHeight + self.defaultGapBetweenCards;
    } else {
      xPos += self.cardWidth + self.defaultGapBetweenCards;
    }
  }
}

- (void)createCardViewToPoint:(CGPoint)point withCard:(Card *)card {
  CGRect cardFrame = CGRectMake(-2 * self.cardWidth,
                                -2 * self.cardHeight,
                                [self cardWidth],
                                [self cardHeight]);
  auto cardView = [self createCardViewWithFrame:cardFrame withCard:card];
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                                  action:@selector(handleCardSelection:)];
  [cardView addGestureRecognizer:tapRecognizer];
  
  [self.cardsView addSubview:cardView];
  [self.cardViews addObject:cardView];

  [self animateCardView:cardView
             toPosition:point
              withDelay:0.01 * [self.cardViews indexOfObject:cardView]];
}

- (void)removeAllCardsFromView {
  for (CardView *cardView in self.cardViews) {
    [cardView removeFromSuperview];
  }
  [self.cardViews removeAllObjects];
  [self.cardPileView removeFromSuperview];
}

- (void)findSmallestNumberOfCardsPerRow {
  self.numberOfCardsPerRow = self.defaultNumberOfCardsPerRow;
  int rows = ceil(self.cardViews.count / (double)self.numberOfCardsPerRow);
  CGFloat maxY = rows * [self cardHeight] + (rows - 1) * self.defaultGapBetweenCards;
  CGFloat cardsViewMaxY = self.cardsView.bounds.origin.y + self.cardsView.bounds.size.height;
  while (maxY > cardsViewMaxY) {
    ++self.numberOfCardsPerRow;
    rows = ceil(self.cardViews.count / (double)self.numberOfCardsPerRow);
    maxY = rows * [self cardHeight] + (rows - 1) * self.defaultGapBetweenCards;
  }
}

- (void)animateCardView:(CardView *)cardView toPosition:(CGPoint)point withDelay:(CGFloat)delay {
  [UIView animateWithDuration:1.0
                        delay:delay
                      options:0
                   animations:^{
                       CGRect cardFrame = CGRectMake(point.x,
                                                     point.y,
                                                     [self cardWidth],
                                                     [self cardHeight]);
                       [cardView setFrame:cardFrame];
                     }
                   completion:nil];
}

- (void)resizeCards {
  [self findSmallestNumberOfCardsPerRow];
  CGFloat xPos = 0;
  CGFloat yPos = 0;
  for (int i = 1; i <= self.cardViews.count; i++) {
    CardView *cardView = self.cardViews[i-1];
    CGRect cardFrame = CGRectMake(xPos,
                                  yPos,
                                  [self cardWidth],
                                  [self cardHeight]);
    [cardView setFrame:cardFrame];
    if (i % self.numberOfCardsPerRow == 0) {
      xPos = 0;
      yPos += [self cardHeight] + self.defaultGapBetweenCards;
    } else {
      xPos += [self cardWidth] + self.defaultGapBetweenCards;
    }
  }
}

- (BOOL)cardsViewTooLarge {
  CGFloat maxY = [self.cardViews lastObject].frame.origin.y + [self cardHeight];
  CGFloat cardsViewMaxY = self.cardsView.bounds.origin.y + self.cardsView.bounds.size.height;
  return maxY > cardsViewMaxY;
}

- (void)updateUI {
  return;
}

- (void)handleCardSelection:(UITapGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
  auto *touchedView = [self.cardsView hitTest:location withEvent:nil];
  if ([touchedView isKindOfClass:[CardView class]]) {
    auto index = [self.cardViews indexOfObject:(CardView *)touchedView];
    if (index == NSNotFound) {
      return;
    }
    [self handleCardSelectionAtIndex:index];
  }
}

- (void)handleCardSelectionAtIndex:(int)index {
  [self.game chooseCardAtIndex:index];
  [self updateUI];
  [self resizeCards];
}

- (IBAction)newGameButtonClicked:(UIButton *)sender {
    [UIView animateWithDuration:1.0
                     animations:^{
                       for (CardView *cardView in self.cardViews) {
                         int x = (arc4random() % (int)(self.cardsView.bounds.size.width * 5))
                                 - (int)self.cardsView.bounds.size.width * 2;
                         int y = self.cardsView.bounds.size.height;
                         cardView.center = CGPointMake(x, -y);
                       }
                     }
                     completion:^(BOOL finished) {
                       [self startNewGame];
                     }];
}

- (void)startNewGame {
  self.deck = [self createDeck];
  self.game = [self makeGame];
  [self.animator removeAllBehaviors];
  [self removeAllCardsFromView];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  [self setUpCards];
  [self resizeCards];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
  if (self.animator.isRunning) {
    return;
  }
  [self.animator removeAllBehaviors];
  [self.cardPileView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(moveCardPile:)]];
  [self.cardPileView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(tapCardPile:)]];
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
  if ([self.cardsView.subviews containsObject:self.cardPileView]) {
    return;
  }
  CGPoint middle = CGPointMake(self.cardsView.bounds.origin.x
                               + self.cardsView.bounds.size.width / 2,
                               self.cardsView.bounds.origin.y
                               + self.cardsView.bounds.size.height / 2);
  for (CardView *cardView in self.cardViews) {
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView
                                                    snapToPoint:middle];
    snap.damping = 1.0;
    [self.animator addBehavior:snap];
  }
  
  self.cardPileView = [[UIView alloc] initWithFrame:CGRectMake(middle.x - self.cardWidth / 2,
                                                                middle.y - self.cardHeight / 2,
                                                                self.cardWidth,
                                                                self.cardHeight)];
  [self.cardsView addSubview:self.cardPileView];
}

- (void)moveCardPile:(UIPanGestureRecognizer *)recognizer {
  CGPoint position = [recognizer locationInView:self.cardsView];
  
  for (CardView *cardView in self.cardViews) {
    cardView.frame = CGRectMake(position.x - self.cardWidth / 2,
                                position.y - self.cardHeight / 2,
                                self.cardWidth,
                                self.cardHeight);
  }
  
  self.cardPileView.frame = CGRectMake(position.x - self.cardWidth / 2,
                                        position.y - self.cardHeight / 2,
                                        self.cardWidth,
                                        self.cardHeight);
}

- (void)tapCardPile:(UITapGestureRecognizer *)recognizer {
  CGFloat xPos = 0;
  CGFloat yPos = 0;
  for (int i = 1; i <= self.cardViews.count; i++) {
    CardView *cardView = self.cardViews[i-1];
    [self animateCardView:cardView toPosition:CGPointMake(xPos, yPos) withDelay:0.05 * (i-1)];
    if (i % self.numberOfCardsPerRow == 0) {
      xPos = 0;
      yPos += [self cardHeight] + self.defaultGapBetweenCards;
    } else {
      xPos += [self cardWidth] + self.defaultGapBetweenCards;
    }
  }
  [self.cardPileView removeFromSuperview];
  [self.animator removeAllBehaviors];
}

@end

NS_ASSUME_NONNULL_END
