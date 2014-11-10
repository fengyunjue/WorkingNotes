//
//  HBCheckTableViewCell.m
//  WorkingNotes
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBCheckTableViewCell.h"


@interface HBCheckTableViewCell()



@end
@implementation HBCheckTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawView];
      
    }
    return self;
}

- (void)drawView
{
    // 设置点到按钮
    self.button1 = [[RectButton alloc]initWithFrame:CGRectMake(150, 10, 60, 60) WithTitle:@"已到" SelectColor:[UIColor greenColor]];
    
    [self addSubview:self.button1];
    self.button2 = [[RectButton alloc]initWithFrame:CGRectMake(250, 10, 60, 60) WithTitle:@"未到" SelectColor:[UIColor redColor]];
    [self addSubview:self.button2];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setIsAttend:(kState)isAttend
{
    if (isAttend == kAttend) {
        [self FromButton:self.button1 toButton:self.button2];
    }else if(isAttend == kAbsent){
      [self FromButton:self.button2 toButton:self.button1];
    }else{
        self.button1.selected = NO;
        self.button1.enabled = YES;
        self.button2.selected = NO;
        self.button2.enabled = YES;
    }
}

- (void)FromButton:(RectButton *)button1 toButton:(RectButton *)button2
{
    button1.selected = YES;
    button1.enabled = NO;
    button2.selected = NO;
    button2.enabled = YES;
}

@end
