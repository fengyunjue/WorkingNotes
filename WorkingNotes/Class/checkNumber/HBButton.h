//
//  HBButton.h
//  WorkingNotes
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RectButton.h"

//typedef enum
//{
//    kUnknow = 0,
//    kAttend,
//    kAbsent
//}kState;

@interface HBButton : RectButton

//@property (assign, nonatomic) kState button1State;

// 工厂方法
+ (id)buttonWithTitle:(NSString *)title SelectColor:(UIColor *)selectColor;

// 点击状态
- (void)click;

// 未点击状态
- (void)didClick;

@end
