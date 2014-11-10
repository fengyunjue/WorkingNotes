//
//  HBCheckNumberCell.m
//  WorkingNotes
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBCheckNumberCell.h"



@interface HBCheckNumberCell()



@end

@implementation HBCheckNumberCell

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
    self.button1 = [HBButton buttonWithTitle:@"已到" SelectColor:[UIColor greenColor]];
    [self.button1 setFrame:CGRectMake(150, 10, 60, 60)];
    [self addSubview:self.button1];

    self.button2 = [HBButton buttonWithTitle:@"未到" SelectColor:[UIColor redColor]];
    [self.button2 setFrame:CGRectMake(250, 10, 60, 60)];
    [self addSubview:self.button2];

}


@end
