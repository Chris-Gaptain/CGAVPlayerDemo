//
//  QuickControl.h
//  CGAVPlayerDemo
//
//  Created by Chris Gaptain on 16/10/9.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuickControl : NSObject

@end

#pragma mark - UIButton快捷创建方法
@interface UIButton (QuickControl)
//快速创建button
+ (id)buttonWithFrame:(CGRect)frame
                title:(NSString *)title
                image:(NSString *)image
               target:(id)target
               action:(SEL)action;
// 设置button属性
- (void)setText:(NSString *)text
      textColor:(UIColor *)textColor
           font:(UIFont *)font;

@end
