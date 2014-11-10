//
//  MainController.m
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "MainController.h"
#import "LeftController.h"
#import "Student.h"
#import "DataBase.h"

#import "ViewController.h"
#import "ChatViewController.h"
#import "HBCheckNumberViewController.h"
#import "HBCheckViewController.h"

@interface MainController ()

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ViewController *vc1 = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    [self addChildViewController:navigationController];
    
    HBCheckViewController *vc2 = [[HBCheckViewController alloc]init];
  
    [self addChildViewController:vc2];
    
    ChatViewController *vc3 = [[ChatViewController alloc]init];
   
    [self addChildViewController:vc3];

    //默认显示是第一个控制器
    [self.view addSubview:navigationController.view];
    
    }
#pragma mark - 实现代理方法，切换视图控制器的view
- (void)dockItem:(DockItem *)dockItem dockItemFrom:(int)from to:(int)to
{
    NSLog(@"from:%d------to:%d",from,to);
    UIViewController *oldVC = self.childViewControllers[from];
    [oldVC.view removeFromSuperview];
    UIViewController *newVC = self.childViewControllers[to];
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHight = self.view.frame.size.height;
    newVC.view.frame = CGRectMake(0, 0, viewWidth, viewHight);
    [self.view addSubview:newVC.view];
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
    