//
//  RectButton.h
//  WorkingNotes
//
//  Created by admin on 14-9-15.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton

// 圆形按钮title
@property (strong, nonatomic) NSString *title;
// 圆形按钮半径
@property (assign, nonatomic) CGFloat radius;
// 圆形按钮颜色
@property (weak, nonatomic) UIColor *color;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title SelectColor:(UIColor *)selectedColor;

@end
