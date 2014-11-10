//
//  HBCheckNumberViewController.m
//  WorkingNotes
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBCheckNumberViewController.h"
#import "Student.h"
#import "HBCheckNumberCell.h"
#import "DataBase.h"
#import "HBButton.h"
#import "HBCheckDoneViewController.h"
#import "HBCheckStudent.h"

static NSString *CellID = @"myCell";
#define kTagStart 100

@interface HBCheckNumberViewController ()
// 学生列表
@property (strong, nonatomic) NSMutableArray *studentList;

@property (weak, nonatomic) UITableView *tableView;
// 缺席名单
@property (strong, nonatomic) NSMutableArray *absentList;
// 上次点名的出席人数
@property (assign, nonatomic) NSInteger oldAttendCount;
// 学生总数
@property (assign, nonatomic) NSInteger StudentCount;
// 出席的总人数
@property (assign, nonatomic) NSInteger attendCount;
// 点名前的学生列表
@property (strong, nonatomic) NSArray *oldStudentList;


@end

@implementation HBCheckNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    table.delegate = self;
    table.dataSource = self;
    
    self.tableView = table;
    DataBase *dataBase = [[DataBase alloc]init];
    NSMutableArray *array = [dataBase selectedAllStudents];
    self.studentList = [NSMutableArray arrayWithCapacity:array.count];
    for (Student *student in array) {
        HBCheckStudent *checkStudent = [HBCheckStudent hbCheckStudentWithStudent:student isCheck:NO kState:kUnknow];
        [self.studentList addObject:checkStudent];
    }
	
    // 设置行高
    [self.tableView setRowHeight:kRowHeight];
    
    // 注册cell
    [self.tableView registerClass:[HBCheckNumberCell class] forCellReuseIdentifier:CellID];
    
    [self.view addSubview:table];
    
    // 初始化是否是第一次进入点到系统
    self.isFirst = YES;
    self.oldAttendCount = 0;
    self.StudentCount = self.studentList.count;
    
}




#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"buttonState%@",[self.studentList valueForKeyPath:@"buttonState"]);
//    NSLog(@"isCheck%@",[self.studentList valueForKeyPath:@"isCheck"]);
    self.oldStudentList = [NSArray arrayWithArray:self.studentList];
    NSLog(@"buttonState%@",[self.oldStudentList valueForKeyPath:@"buttonState"]);
    NSLog(@"isCheck%@",[self.oldStudentList valueForKeyPath:@"isCheck"]);
    
    return self.studentList.count;
}

#pragma mark - 代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HBCheckNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Student *student = self.studentList[indexPath.row];
    [cell.textLabel setText:student.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d",student.number]];
    UIImage *image = [UIImage imageNamed:student.pic];
    [cell.imageView setImage:image];
    
    // button的状态
        HBCheckStudent  *sta = self.studentList[indexPath.row];
        if (kUnknow == sta.buttonState) {
            cell.button1.color = [UIColor lightGrayColor];
            cell.button2.color = [UIColor lightGrayColor];
            cell.button1.enabled = YES;
            cell.button2.enabled = YES;
        }else if(kAttend == sta.buttonState){
            cell.button1.color = [UIColor greenColor];
            cell.button2.color = [UIColor lightGrayColor];
        }else if (kAbsent == sta.buttonState){
            cell.button2.color = [UIColor redColor];
            cell.button1.color = [UIColor lightGrayColor];
            cell.button1.enabled = YES;
        }
            
     // button1和button2的监听方法
    [cell.button1 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button2 addTarget:self action:@selector(tap1:) forControlEvents:UIControlEventTouchUpInside];
       
    // 记录tag值,用于区分cell
    cell.tag = kTagStart +indexPath.row;
    return cell;

}



#pragma mark - Action

-(void)tap:(HBButton *)button
{
    // 用于两个button的状态切换
    HBCheckNumberCell *cell = (HBCheckNumberCell *)[[button superview] superview];
    [button click];
     button.enabled = NO;
    [cell.button2 didClick];
    cell.button2.enabled = YES;
    
    NSInteger i = cell.tag - kTagStart;
    HBCheckStudent *student = self.studentList[i];
    
    // 更改记录中的数据
    student.buttonState = kAttend;
    student.isCheck = YES;
    [self.studentList replaceObjectAtIndex:i withObject:student];
    
}
- (void)tap1:(HBButton *)button
{
    // 用于两个button的状态切换
    HBCheckNumberCell *cell = (HBCheckNumberCell *)[[button superview] superview];
    [button click];
    button.enabled = NO;
    [cell.button1 didClick];
    cell.button1.enabled = YES;
    
    NSInteger i = cell.tag - kTagStart;
    HBCheckStudent *student = self.studentList[i];
    
    // 更改记录中的数据
    student.buttonState = kAbsent;
    student.isCheck = YES;
    [self.studentList replaceObjectAtIndex:i withObject:student];
    

}
#pragma mark 取消点到,重设数值
- (void)reset:(UIBarButtonItem *)left
{
    NSLog(@"123");
    
    NSLog(@"%@",self.oldStudentList);
    
    [self.studentList removeAllObjects];
    self.studentList =[NSMutableArray arrayWithArray:self.oldStudentList];
    NSLog(@"%@",[self.oldStudentList valueForKeyPath:@"buttonState"]);
    NSLog(@"%@",[self.oldStudentList valueForKeyPath:@"isCheck"]);
    [self.tableView reloadData];
}

#pragma mark 点到完成
- (void)done:(UIBarButtonItem *)right
{
    // 判断点名是否完成
    NSInteger count = 0;
    
    if (self.absentList.count != 0) {
        [self.absentList removeAllObjects];
    }else{
        self.absentList = [NSMutableArray arrayWithCapacity:self.studentList.count];
        
        
        NSLog(@"absentList被实例化");
    }
    NSLog(@"%@",self.studentList);
    for (HBCheckStudent *checkStudent in self.studentList) {
        count += checkStudent.isCheck;
        if (kAbsent == checkStudent.buttonState) {
            [self.absentList addObject:checkStudent];
        }
    }
 
    if (count == self.studentList.count) {
        // 实例化提示框
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        [alertView setContainerView:[self createDemoView:self.absentList.count]];
         [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [alertView setDelegate:self];
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
            [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];
        
        
        self.oldAttendCount = count - self.absentList.count;
    }else{
        NSString *strMessage = [NSString stringWithFormat:@"点名未完成!!!还有%d个同学未被点到,请继续点名",self.studentList.count - count];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:strMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }

}

#pragma mark - CustomIOS7AlertView代理方法
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        HBCheckDoneViewController *checkDone = [[HBCheckDoneViewController alloc]initWithBlock:^{
            [self.studentList removeAllObjects];
            self.studentList = [NSMutableArray arrayWithArray:self.self.absentList];
            self.isFirst = NO;
            
            [self.tableView reloadData];
        }];
        
        checkDone.absentCount = self.absentList.count;
       
        checkDone.attendCount = self.attendCount;
        checkDone.count = self.StudentCount;
        checkDone.lateCount = self.studentList.count - self.absentList.count;
        checkDone.isFirst = self.isFirst;
        checkDone = checkDone;
        checkDone.absentCount = self.absentList.count;
        [self presentViewController:checkDone animated:YES completion:Nil];
    }
    
    
    NSLog(@"Alert的代理方法");
}


#pragma mark - CustomIOS7AlertView的View
- (UIView *)createDemoView:(NSInteger )absentCount
{
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 200)];
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
    [countLabel setText:[NSString stringWithFormat:@"%d",self.StudentCount]];
    UILabel *attendLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, 40, 30)];
    [attendLabel setText:[NSString stringWithFormat:@"%d",self.studentList.count - absentCount + self.oldAttendCount]];
    self.attendCount = self.studentList.count - absentCount + self.oldAttendCount;
    UILabel *absentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 115, 40, 30)];
    [absentLabel setText:[NSString stringWithFormat:@"%d",absentCount]];
    
    NSLog(@"oldAttendCount %d  absentCount %d  studentList.count %d ",self.oldAttendCount,absentCount,self.studentList.count);
    
    
    
    if (!self.isFirst) {
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 145, 80, 30)];
        [label4 setText:@"迟到人数:"];
        UILabel *LateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 145, 40, 30)];
        [LateLabel setText:[NSString stringWithFormat:@"%d",self.studentList.count - absentCount]];
        [view addSubview:label4];
        [view addSubview:LateLabel];
    }
    
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [view addSubview:title];
    [view addSubview:countLabel];
    [view addSubview:attendLabel];
    [view addSubview:absentLabel];
    
    NSLog(@"画图方法");
    
    
    return view;
}


@end
