//
//  HBButton.m
//  WorkingNotes
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBButton.h"

@interface HBButton()

@property (weak, nonatomic) UIColor *selectColor;

@end

@implementation HBButton
/**
 *  初始化方法
 *
 *  @param frame button的大小位置
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
/**
 *  工厂方法
 *
 *  @param title       标题
 *  @param selectColor 选中颜色
 *
 *  @return id
 */
+ (id)buttonWithTitle:(NSString *)title SelectColor:(UIColor *)selectColor
{
    HBButton *button = [[HBButton alloc]init];
    // 设置按钮文字
    button.title = title;
    
    // 将颜色传给slectColor
    button.selectColor = selectColor;
    return button;
}
/**
 *  click
 */
- (void)click
{
    self.color = self.selectColor;
}

- (void)didClick
{
    self.color = [UIColor lightGrayColor];
}



@end
