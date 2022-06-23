//
//  SetViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 16/06/2022.
//

#import "SetCardGameViewController.h"

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardGameViewController()

@property (nonatomic) NSMutableArray<NSNumber *> *selectedCardIndices;

@end

@implementation SetCardGameViewController

- (Deck *)createDeck {
  return [[SetCardDeck alloc] initWithShapes:@[@"●", @"■", @"▲"]
                                      colors:@[UIColor.redColor,
                                              UIColor.greenColor,
                                              UIColor.purpleColor]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.selectedCardIndices = [[NSMutableArray alloc] init];
  [self setUpCards];
  self.game.mode = GameMode::threeCard;
}

-(void) setUpCards {
  for (UIButton *cardButton in self.cardsCollection) {
    [cardButton.titleLabel setLineBreakMode:NSLineBreakByClipping];
    [cardButton.titleLabel setNumberOfLines:3];
    [cardButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cardButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [cardButton setEnabled:YES];
    [cardButton setAlpha:1.0];
    const auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    const auto card = [self.game cardAtIndex:cardButtonIndex];
    if ([card isKindOfClass:[SetCard class]]) {
      const auto setCard = (SetCard *) card;
      auto *text = setCard.shape;
      for (int i = 1; i < setCard.numberOfShapes; i++) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"\r%@", setCard.shape]];
      }
      auto *attString = [[NSAttributedString alloc] initWithString:text
                                                        attributes:[self attributesForSetCard:setCard]];
      [cardButton setAttributedTitle:attString forState:UIControlStateNormal];
    }
  }
}

- (void)handleCardSelectionAtIndex:(NSUInteger)index {
  if ([self.selectedCardIndices containsObject:@(index)]) {
    [self.selectedCardIndices removeObject:@(index)];
  } else {
    [self.selectedCardIndices addObject:@(index)];
  }
  [self.game chooseCardAtIndex:index];
  [self updateUI];
}

- (NSDictionary *)attributesForSetCard: (SetCard *)card {
  NSMutableDictionary *attributes = [@{NSForegroundColorAttributeName : card.color} mutableCopy];
  switch (card.shading) {
    case setCardShadingStriped:
      attributes[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInt:
                                                       NSUnderlineStyleDouble];
      attributes[NSStrikethroughColorAttributeName] = UIColor.whiteColor;
      break;
    case setCardShadingOpen:
      attributes[NSStrokeWidthAttributeName] = @5;
      break;
    default:
      break;
  }
  return attributes;
}

- (void)updateLastMoveDescriptionLabel {
  NSString *moveDescription = self.game.lastMoveDescription;
  if (self.selectedCardIndices.count == 0 || moveDescription.length == 0) {
    self.descriptionLabel.text = moveDescription;
    return;
  }
  auto attributedDescription = [[NSMutableAttributedString alloc] initWithString:moveDescription];
  NSRange range = NSMakeRange(0, moveDescription.length);
  [attributedDescription addAttributes:@{NSForegroundColorAttributeName : UIColor.whiteColor}
                                 range:range];

  // To store already used locations in the description string
  NSMutableSet<NSNumber *> *locations = [[NSMutableSet alloc] init];
  
  // If less than 3 cards selected, the description text contains only the last selected card,
  // so start from the last element in the array
  int i = self.selectedCardIndices.count < 3 ? (int)(self.selectedCardIndices.count) - 1 : 0;
  
  // Find the setcard symbols in the description string and add attributes.
  // Different cards can have the same card contents so loop through
  // the selected cards and find each card's symbol in the description string
  // and apply the correct attributes to i
  while (i < self.selectedCardIndices.count) {
    NSNumber *index = self.selectedCardIndices[i];
    Card* card = [self.game cardAtIndex:index.intValue];
    if ([card isKindOfClass:[SetCard class]]) {
      SetCard *setCard = (SetCard *)card;

      auto *regex = [NSRegularExpression regularExpressionWithPattern:setCard.contents
                                                              options:0
                                                                error:nil];
      NSRange textRange = NSMakeRange(0, moveDescription.length);
      auto matches = [regex matchesInString:moveDescription
                                    options:NSMatchingReportProgress
                                      range:textRange];
      
      for (NSTextCheckingResult *res in matches) {
        range = res.range;
        if (![locations containsObject:@(range.location)]) {
          [locations addObject:@(range.location)];
          // Add color for the whole range, number and symbol
          [attributedDescription addAttributes:@{NSForegroundColorAttributeName : setCard.color}
                                         range:range];
          // Modify range to only include the symbol
          range.location = range.location + 1;
          range.length = range.length - 1;
          [attributedDescription addAttributes:[self attributesForSetCard:setCard]
                                         range:range];
          break;
        }
      }
      self.descriptionLabel.attributedText = attributedDescription;
      if (!card.chosen || card.matched) {
        [self.selectedCardIndices removeObject:index];
      } else {
        ++i;
      }
    }
  }
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardsCollection) {
    auto cardButtonIndex = [self.cardsCollection indexOfObject:cardButton];
    const auto *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setEnabled:!card.matched];
    [cardButton setAlpha:(card.chosen && !card.matched) ? 0.85 : 1.0];
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  [self updateLastMoveDescriptionLabel];
}

- (void)startNewGame {
  if (![self.game startNewGameWithCardCount:self.cardsCollection.count usingDeck
                                           :[self createDeck]]) {
    return;
  }
  [self setUpCards];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lld", (long long)self.game.score];
  self.descriptionLabel.text = @"";
  [self.selectedCardIndices removeAllObjects];
}

@end

NS_ASSUME_NONNULL_END
