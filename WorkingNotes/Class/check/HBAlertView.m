//
//  HBAlertView.m
//  WorkingNotes
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBAlertView.h"

@implementation HBAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

#pragma mark - CustomIOS7AlertView的View
+ (id)HBAlertViewWithAbsentCount:(NSInteger )absentCount AndCount:(NSInteger)count
{
    HBAlertView *view =  [[HBAlertView alloc]initWithFrame:CGRectMake(0, 0, 290, 200)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 90, 50)];
    
    [title setText:@"提示"];
    [title setFont:[UIFont systemFontOfSize:30]];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, 80, 30)];
    [label1 setText:@"总人数:"];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, 80, 30)];
    [label2 setText:@"已到人数:"];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 115, 80, 30)];
    [label3 setText:@"未到人数:"];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 55, 40, 30)];
    [countLabel setText:[NSString stringWithFormat:@"%d",count]];
    UILabel *attendLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, 40, 30)];
    [attendLabel setText:[NSString stringWithFormat:@"%d",count - absentCount]];
    UILabel *absentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 115, 40, 30)];
    [absentLabel setText:[NSString stringWithFormat:@"%d",absentCount]];
//    if (!self.isFirst) {
//        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 145, 80, 30)];
//        [label4 setText:@"迟到人数:"];
//        UILabel *LateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 145, 40, 30)];
//        [LateLabel setText:[NSString stringWithFormat:@"%d",self.studentList.count - absentCount]];
//        [view addSubview:label4];
//        [view addSubview:LateLabel];
//    }
    
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [view addSubview:title];
    [view addSubview:countLabel];
    [view addSubview:attendLabel];
    [view addSubview:absentLabel];
    
    return view;
}

@end
