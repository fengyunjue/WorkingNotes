//
//  LeftController.m
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//  左视图控制器用于选择栏目

#import "LeftController.h"
#import "DockItem.h"
@interface LeftController ()

@end

@implementation LeftController
{
    DockItem *_selectedItem;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:172.0/255.0 blue:237.0/255.0 alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 需要在主线程里添加
    dispatch_async(dispatch_get_main_queue(), ^{
        //1.添加一个DockItem即供选择的栏目，传入icon图片和选中时的图片名称
        [self setTitle:@"学生个人信息" iconName:@"user" ];
        
        //将button里的icon传入，有两个状态普通和被选中状态
        
        [self setTitle:@"点到" iconName:@"file"];
        
        [self setTitle:@"聊天论坛" iconName:@"star"];
        
        //
        //    [self setTitle:@"其他" iconName:@"info"];
    });

}
#pragma mark - 私有方法,添加一个选项卡
- (void)setTitle:(NSString *)title iconName:(NSString *)iconName
{
    DockItem *dock = [[DockItem alloc]init];
    [dock setTitle:title forState:UIControlStateNormal];
    
    [dock setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    
    [dock setImage:[UIImage imageNamed:[iconName stringByAppendingString:@"_selected"]] forState:UIControlStateSelected];
    //设置选中后的图片
    [dock setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateSelected];
    //监听item的点击事件
    [dock addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:dock];
   int count =  self.view.subviews.count;
    //设置dock的fram
    //默认选中第一行
    if (count == 1) {
        [self clickAction:dock];
    }
    //重置所以dockItem的fram
    for (int i = 0; i < count; i ++) {
        DockItem *dockItem = self.view.subviews[i];
        dockItem.tag = i;
        CGFloat ViewWidth = self.view.frame.size.width;
        CGFloat ViewHight = self.view.frame.size.height;
        dockItem.frame = CGRectMake(0, (ViewHight/5)+i*kButtonHight, (ViewWidth*2)/3,kButtonHight);
    }
   }
#pragma mark - left控制上按钮的点击事件
- (void)clickAction:(DockItem *)dockItem
{
   
    //如果代理控制器能响应，则赋值上去,_selectedItem.tag初始为0
    if ([_delegate respondsToSelector:@selector(dockItem:dockItemFrom:to:)]) {
    [_delegate dockItem:dockItem dockItemFrom:_selectedItem.tag to:dockItem.tag];}
    //首先取消上次button的选中状态
    _selectedItem.selected = NO;
    //将现在的button状态置为选中状态
    dockItem.selected = YES;
    //将现在的button的指针付给以选中item
    _selectedItem = dockItem;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
