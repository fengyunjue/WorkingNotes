//
//  DockItem.m
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "DockItem.h"

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        //图片内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        //调整文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    }
    return self;
}
#pragma mark 复写覆盖父类在highlight时的所有操作
- (void)setHighlighted:(BOOL)highlighted
{
}
#pragma mark 调整内部ImageView的fram
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width*0.2;
    CGFloat imageHight = kButtonHight;
    return CGRectMake(imageX, imageY, imageWidth, imageHight);
}
#pragma mark 调整内部调整内部的title的fram
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = contentRect.size.width*0.2;
        CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width*0.8;
    CGFloat titleHight = kButtonHight;
    return CGRectMake(titleX, titleY, titleWidth, titleHight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
