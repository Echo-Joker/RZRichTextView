//
//  ViewController.m
//  RZRichTextView
//
//  Created by Admin on 2018/12/14.
//  Copyright © 2018 Rztime. All rights reserved.
//

#import "ViewController.h"
#import "RZRichTextView.h"
#import <RZColorful/RZColorful.h>
#import "RZRichTextInputAccessoryView.h"
#import "RZRTSliderView.h"
#import "RZRichTextConfigureManager.h"
#import "RZRTColorView.h"
#import "RZRichAlertViewController.h"
#import "RZRictAttributeSetingViewController.h"
#import "RZRichTextInputFontColorCell.h"
#import "RZRichTextInputFontBgColorCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 全局的自定义功能实现 (点击工具栏上的功能将会调用的方法)
    RZRichTextConfigureManager.manager.didClickedCell = ^BOOL(RZRichTextView * _Nonnull textView, RZRichTextAttributeItem * _Nonnull item) {
        if (item.type == RZRichTextAttributeTypeFontSize) {
            __block UIFont *font = textView.rz_attributedDictionays[NSFontAttributeName];
            rz_weakObj(textView);
            RZRictAttributeSetingViewController *vc = [[RZRictAttributeSetingViewController alloc] init];
            vc.displayLabel.text =  [NSString stringWithFormat:@"字号:%@", @(font.pointSize)];
            vc.displayLabel.font = font;
            rz_weakObj(vc);
            [vc sliderValue:font.pointSize min:5 max:100 didSliderValueChanged:^(CGFloat value) {
                NSInteger font = (NSInteger)value;
                vcWeak.displayLabel.font = [UIFont systemFontOfSize:font];
                vcWeak.displayLabel.text = [NSString stringWithFormat:@"字号:%@", @(font)];
            } complete:^(CGFloat value) {
                UIFont *tempfont = [font fontWithSize:((NSInteger)value)];
                textViewWeak.rz_attributedDictionays[NSFontAttributeName] = tempfont;
                [textViewWeak rz_reloadAttributeData];  // 刷新工具条
            }];
            [RZRichTextConfigureManager presentViewController:vc animated:YES];
            return YES;
        }
        return NO;
    };
    // 键盘上的工具栏的cell
    RZRichTextConfigureManager.manager.cellForItemAtIndePath = ^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, RZRichTextAttributeItem * _Nonnull item) {
        if (item.type == RZRichTextAttributeTypeFontColor || item.type == RZRichTextAttributeTypeStroke) {
            RZRichTextInputFontColorCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"def1Cell" forIndexPath:indexPath];
            cell.imageView.image = item.displayImage;
            UIColor *color = item.exParams[@"color"];
            cell.colorImageView.backgroundColor = color;
            return cell;
        }
        return nil;
    };
    // 全局的图片的处理
    RZRichTextConfigureManager.manager.rz_shouldInserImage = ^UIImage * _Nullable(UIImage * _Nullable image) {
        return image;
    };
    // 富文本输入框
    RZRichTextView *view = [[RZRichTextView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    view.backgroundColor = [UIColor grayColor];
    view.font = [UIFont systemFontOfSize:17];
    // 只针对当前textView的功能点击的实现
    view.didClickedCell = ^BOOL(RZRichTextView * _Nonnull textView, RZRichTextAttributeItem * _Nonnull item) {
        if (item.type == RZRichTextAttributeTypeFontColor) {
            UIColor *color = [textView.rz_attributedDictionays[NSForegroundColorAttributeName] copy];
            rz_weakObj(textView);
            RZRictAttributeSetingViewController *vc = [[RZRictAttributeSetingViewController alloc] init];
            vc.displayLabel.text = @"字体颜色";
            vc.displayLabel.textColor = color;
            rz_weakObj(vc);
            [vc color:color didChanged:^(UIColor * _Nonnull color) {
                vcWeak.displayLabel.textColor = color;
            } complete:^(UIColor * _Nonnull color) {
                textViewWeak.rz_attributedDictionays[NSForegroundColorAttributeName] = color;
                [textViewWeak rz_reloadAttributeData];  // 刷新工具条
            }];
            [RZRichTextConfigureManager presentViewController:vc animated:YES];
            return YES;
        }
        return NO;
    };
    // 只针对当前textView 的工具条cell的实现
    view.cellForItemAtIndePath = ^UICollectionViewCell * _Nonnull(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, RZRichTextAttributeItem * _Nonnull item) {
        if (item.type == RZRichTextAttributeTypeFontBackgroundColor) {
            RZRichTextInputFontBgColorCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"def2Cell" forIndexPath:indexPath];
            cell.imageView.image = item.displayImage;
            UIColor *color = item.exParams[@"color"];
            cell.colorImageView.backgroundColor = color;
            return cell;
        }
        return nil;
    };
    
    [self.view addSubview:view];
}

- (void)changedValue:(UISlider *)slider {
    NSLog(@"slide:%f", slider.value);
}

@end
