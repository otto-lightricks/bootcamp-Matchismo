//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Otto Olkkonen on 16/06/2022.
//

#import "HistoryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController()

@property (nonatomic) NSAttributedString *historyText;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HistoryViewController

- (void) setHistoryText:(NSAttributedString *)historyText {
  _historyText = historyText;
  if (self.isViewLoaded && self.view.window) {
    [self updateUI];
  }
}

- (void) setAttributedText:(NSAttributedString *)text {
  self.historyText = text;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateUI];
  
  const auto appearance = [[UITabBarAppearance alloc] init];
  [appearance setBackgroundColor:self.view.backgroundColor];
  [[self.tabBarController tabBar] setStandardAppearance:appearance];
  [[self.tabBarController tabBar] setScrollEdgeAppearance:appearance];
  
  const auto navBarAppeareance = [[UINavigationBarAppearance alloc] init];
  [navBarAppeareance setBackgroundColor:self.view.backgroundColor];
  [[self.navigationController navigationBar] setStandardAppearance:navBarAppeareance];
  [[self.navigationController navigationBar] setScrollEdgeAppearance:navBarAppeareance];
  
}

- (void)updateUI {
  self.textView.attributedText = self.historyText;
  NSRange range;
  range.location = 0;
  range.length = self.textView.text.length;
  [self.textView.textStorage addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}
                                     range:range];
}

@end

NS_ASSUME_NONNULL_END
