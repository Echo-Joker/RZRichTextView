//
//  RZRichStrikethroughCell.m
//  RZRichTextView
//
//  Created by Admin on 2018/10/30.
//  Copyright © 2018 Rztime. All rights reserved.
//

#import "RZRichStrikethroughCell.h"

@implementation RZRichStrikethroughCell
- (void)setViewModel:(RZRichTextViewModel *)viewModel {
    [super setViewModel:viewModel];
    __weak typeof(self) weakSelf = self;
    [self.textLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        if (weakSelf.viewModel.textModel.strikethrough) {
            confer.text(@"abc").font(RZFontNormal(16)).textColor(krz_rich_theme_color).strikeThrough(1).strikeThroughColor(krz_rich_theme_color);
        } else {
            confer.text(@"abc").font(RZFontNormal(15)).textColor(krz_rich_defult_color).strikeThrough(1).strikeThroughColor(krz_rich_defult_color);
        }
    }];
}
- (void)viewDidClicked {
    self.viewModel.textModel.strikethrough = !self.viewModel.textModel.strikethrough;
    if (self.viewModel.rz_changeRich) {
        self.viewModel.rz_changeRich(YES);
    }
}
@end
