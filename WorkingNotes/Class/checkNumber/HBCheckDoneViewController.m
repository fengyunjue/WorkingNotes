//
//  HBCheckDoneViewController.m
//  WorkingNotes
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBCheckDoneViewController.h"


@interface HBCheckDoneViewController ()
{
    ReloadBlock _block;
}

@end

@implementation HBCheckDoneViewController

- (id)initWithBlock:(ReloadBlock)block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"DADADA");
    [super viewDidLoad];
    HBButton *button = [HBButton buttonWithTitle:@"迟到" SelectColor:nil];
    [button setFrame:CGRectMake(40, 350, 60, 60)];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(absent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    HBButton *done = [HBButton buttonWithTitle:@"完成" SelectColor:nil];
    [done setFrame:CGRectMake(220, 350, 60, 60)];
    [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:done];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 90, 50)];
    
    [title setText:@"提示"];
    [title setFont:[UIFont systemFontOfSize:30]];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 80, 44)];
    [label1 setText:@"总人数:"];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, 80, 44)];
    [label2 setText:@"已到人数:"];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 80, 44)];
    [label3 setText:@"未到人数:"];
        
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 40, 44)];
    [countLabel setText:[NSString stringWithFormat:@"%d",self.count]];
    UILabel *attendLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 105, 40, 44)];
    [attendLabel setText:[NSString stringWithFormat:@"%d",self.attendCount]];
    UILabel *absentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 150, 40, 44)];
    [absentLabel setText:[NSString stringWithFormat:@"%d",self.absentCount]];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:title];
    [self.view addSubview:countLabel];
    [self.view addSubview:attendLabel];
    [self.view addSubview:absentLabel];
    
    
    
    if (!self.isFirst) {
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 195, 80, 44)];
        [label3 setText:@"迟到人数:"];
        UILabel *lateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 195, 40, 44)];
        [lateLabel setText:[NSString stringWithFormat:@"%d",self.lateCount]];
        [self.view addSubview:label4];
        [self.view addSubview:lateLabel];
    }
}

- (void)absent:(HBButton *)button
{
    if (self.absentCount != 0) {
        _block();
        
        [self dismissViewControllerAnimated:YES completion:Nil];
    }else{
          NSLog(@"所有成员均已出席");
    }
    
    
    
}

- (void)done:(HBButton *)button
{
    NSLog(@"完成");
}

@end
