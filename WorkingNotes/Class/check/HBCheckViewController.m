//
//  HBCheckViewController.m
//  WorkingNotes
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBCheckViewController.h"
#import "CustomIOS7AlertView.h"
#import "HBCheckTableViewCell.h"
#import "Student.h"
#import "HBAlertView.h"
#import "HBCheckDoneViewController.h"


static NSString *CellID = @"myCell";
#define kTagStart 100

@interface HBCheckViewController ()<UITableViewDataSource, UITableViewDelegate,CustomIOS7AlertViewDelegate,UIAlertViewDelegate>
// table
@property (weak,nonatomic) UITableView *tableView;
// 学生列表
@property (strong, nonatomic) NSMutableArray *studentList;
// 记录学生状态
@property (strong, nonatomic) NSMutableArray *studentStates;

@end

@implementation HBCheckViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];

    // 获取学生数据
    NSString *path = [self getFileWithFileName:@"studentList.plist"];
    if ([self isFileExist:@"studentList.plist"]) {
        self.studentList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    // 设置行高
    [self.tableView setRowHeight:kRowHeight];
    
    // 注册cell
    [self.tableView registerClass:[HBCheckTableViewCell class] forCellReuseIdentifier:CellID];
    
}

-(NSMutableArray *)studentStates
{
    if (_studentStates == nil) {
        _studentStates = [NSMutableArray arrayWithCapacity:self.studentList.count];
        for (NSInteger i = 0; i < self.studentList.count; i++) {
            NSNumber *state = @(kUnknow);
            [_studentStates addObject:state];
        }
    }
    return _studentStates;
}
/**
 *  设置界面
 */
- (void)setupView
{
    UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [bar setBackgroundImage:[UIImage imageNamed:@"background.png"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"点到"];
    
    
    [bar setItems:@[item]];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(reset:)];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    
    [item setLeftBarButtonItem:leftButtonItem];
    [item setRightBarButtonItem:rightButtonItem];
    [self.view addSubview:bar];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate = self;
    self.tableView = table;
}

#pragma mark - 私有方法
#pragma mark 获取沙箱目录
- (NSString *)getFileWithFileName:(NSString *)fileName
{
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc = docs[0];
    NSString *path = [doc stringByAppendingPathComponent:fileName];
    return path;
}
#pragma mark 判断沙箱中文件是否存在
- (BOOL) isFileExist:(NSString *)name
{
    NSString *path = [self getFileWithFileName:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:path];
    NSLog(@"%d",result);
    return result;
}

/**
 *  行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.studentList.count;
}
/**
 *  代理方法
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置属性
    Student *student = self.studentList[indexPath.row];
    [cell.textLabel setText:student.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d",student.number]];
    UIImage *image = [UIImage imageNamed:student.pic];
    [cell.imageView setImage:image];
   
    // 设置按钮属性
    [cell.button1 addTarget:self action:@selector(Click1:) forControlEvents:UIControlEventTouchDown];
    [cell.button2 addTarget:self action:@selector(Click2:) forControlEvents:UIControlEventTouchDown];
    kState state = [self.studentStates[indexPath.row] intValue];
    [cell setIsAttend:state];
    
    cell.tag = kTagStart +indexPath.row;
    return cell;
}

#pragma mark 监听方法
- (void)Click1:(RectButton *)button1
{
    HBCheckTableViewCell *cell =  [self reloadButton:button1 withState:kAttend];
    button1.selected = YES;
    cell.button2.selected = NO;

}
- (void)Click2:(RectButton *)button2
{
    HBCheckTableViewCell *cell =  [self reloadButton:button2 withState:kAbsent];
    button2.selected = YES;
    cell.button1.selected = NO;
}

#pragma mark 更新buttonState
- (HBCheckTableViewCell *)reloadButton:(RectButton *)button withState:(kState)state
{
    HBCheckTableViewCell *cell = (HBCheckTableViewCell *)[[button superview] superview];
    NSInteger i = cell.tag - kTagStart;
    [self.studentStates replaceObjectAtIndex:i withObject:@(state)];
    return cell;
}

#pragma mark 点到完成
- (void)done:(UIBarButtonItem *)right
{
    NSInteger absent = 0;
    NSInteger attend = 0;
    NSInteger unKnow = 0;
    for (NSNumber *number in self.studentStates) {
        kState state = [number intValue];
        if (state == attend) {
            attend++;
        }else if (state == absent){
            absent++;
        }else{
            unKnow++;
        }
    }
    
    if (unKnow == 0) {
        // 实例化提示框
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        HBAlertView *view = [HBAlertView HBAlertViewWithAbsentCount:absent AndCount:self.studentStates.count];
        [alertView setContainerView:view];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [alertView setDelegate:self];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            [alertView close];
        }];
        [alertView setUseMotionEffects:true];

        [alertView show];
    }else{
        NSString *strMessage = [NSString stringWithFormat:@"点名未完成!!!还有%d个同学未被点到,请继续点名",unKnow];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:strMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - CustomIOS7AlertView代理方法
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSLog(@"确定");
    }
    
    NSLog(@"Alert的代理方法");
}

- (void)reset:(UIBarButtonItem *)right
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注意:取消后无法返回,确定取消这次点名?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.studentStates != nil) {
            [self.studentStates removeAllObjects];
        }
        for (NSInteger i = 0; i < self.studentList.count; i++) {
            NSNumber *state = @(kUnknow);
            [_studentStates addObject:state];
        }
        
        [self.tableView reloadData];
    }
}


@end
