//
//  QuickControl.m
//  CGAVPlayerDemo
//
//  Created by Chris Gaptain on 16/10/9.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import "QuickControl.h"

@implementation QuickControl

@end

#pragma mark - UIButton Category

@implementation UIButton (QuickControl)

//快速创建按钮的方法
+(id)buttonWithFrame:(CGRect)frame
               title:(NSString *)title
               image:(NSString *)image
              target:(id)target
              action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    if (image.length) {
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setText:(NSString *)text
      textColor:(UIColor *)textColor
           font:(UIFont *)font
{
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.titleLabel.font = font;
}

@end
