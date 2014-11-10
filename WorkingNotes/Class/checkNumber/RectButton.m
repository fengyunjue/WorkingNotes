//
//  RectButton.m
//  WorkingNotes
//
//  Created by admin on 14-9-15.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "RectButton.h"

@interface RectButton()

@property (weak, nonatomic) UIColor *selectColor;

@end

@implementation RectButton

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title SelectColor:(UIColor *)selectedColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置圆形按钮边框的大小
        self.layer.borderWidth = 1;
        // 设置圆形按钮边框的颜色
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        // 设置圆形按钮的直径
        self.layer.cornerRadius = 30;
        // 设置
        self.layer.masksToBounds = YES;
        
        // 设置标题
        [self setTitle:title forState:UIControlStateNormal];
        
        // 设置标题选中时的颜色
        [self setTitleColor:selectedColor forState:UIControlStateSelected];
        self.selectColor = selectedColor;
        // 设置圆形按钮未选中时的颜色
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        // 监听selected属性变化
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)setRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSInteger i = [change[@"new"] intValue];
    if (i == 1) {
       self.layer.borderColor = self.selectColor.CGColor;
        [self setTitleColor:self.selectColor forState:UIControlStateNormal];
        self.enabled = NO;
    }else{
        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.enabled = YES;
    }
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selected"];
}

@end
