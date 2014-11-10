//
//  ViewController.m
//  AnimationMaximize
//
//  Created by mayur on 7/31/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import "ViewController.h"
#import "SampleCell.h"
#import "DetailViewController.h"
#import "Student.h"
#import "DataBase.h"


#define TABLE_HEIGHT 80

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

// 学生列表
@property (strong, nonatomic) NSMutableArray *studentList;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStylePlain];
    [self.navigationItem setTitle:@"学生列表"];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    NSString *path = [self getFileWithFileName:@"studentList.plist"];
    if ([self isFileExist:@"studentList.plist"]) {
        self.studentList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }else
    {
        [self loadJson];
    }
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
#pragma mark - 加载JSON
- (void)loadJson
{
    // 从web服务器直接加载数据
    NSString *str = @"http://192.168.1.220/~admin/studentList.php";
    
    // 提示：NSData本身具有同步方法，但是在实际开发中，不要使用此方法
    // 在使用NSData的同步方法时，无法指定超时时间，如果服务器连接不正常，会影响用户体验
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    
    // 1. 建立NSURL
    NSURL *url = [NSURL URLWithString:str];
    // 2. 建立NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // 3. 利用NSURLConnection的同步方法加载数据
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

}];
    // 不要忘记错误处理
    if (data != nil) {
        // 仅用于跟踪调试使用
        //        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        // 做JSON数据的处理
        // 提示：在处理网络数据时，不需要将NSData转换成NSString
        [self handlerJSONData:data];
    } else if (data == nil && error == nil) {
        NSLog(@"空数据");
    } else {
        NSLog(@"错误----%@", error.localizedDescription);
    }
   
}
#pragma mark 处理JSON数据
- (void)handlerJSONData:(NSData *)data
{
    // JSON文件中的[]表示是一个数组
    // 反序列化JSON数据
    /*
     序列化：    将NSObject转换成序列数据，以便可以通过互联网进行传输
     反序列化：  将网络上获取的数据，反向生成我们需要的对象
     */
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//     NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    
    // 提示：如果开发网络应用，可以将反序列化出来的对象，保存至沙箱，以便后续开发使用
//    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [docs[0]stringByAppendingPathComponent:@"json.plist"];
//    [array writeToFile:path atomically:YES];
    
    // 给数据列表赋值
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        Student *student = [[Student alloc]init];
        
        // 给video赋值
        [student setValuesForKeysWithDictionary:dict];
        
        [arrayM addObject:student];
    }
    
    self.studentList = arrayM;
//    for (Student *student in arrayM) {
//        NSLog(@"name:%@",student.name);
//    }
//    NSLog(@"------%@",self.studentList);
    NSString *path = [self getFileWithFileName:@"studentList.plist"];
    [NSKeyedArchiver archiveRootObject:arrayM toFile:path];
    NSLog(@"下载了网络数据");
    // 刷新表格
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.studentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleCell *cell = (SampleCell*) [tableView dequeueReusableCellWithIdentifier:@"SampleCell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SampleCell" owner:[SampleCell class] options:nil];
        cell = (SampleCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
   Student *student = [self.studentList objectAtIndex:indexPath.row];
    
    cell.name.text = student.name;
    cell.describe.text = [NSString stringWithFormat:@"number:(%d) room:(%@)",student.number,student.room];
    cell.imageview.image = [UIImage imageNamed:@"temp.png"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%d行",indexPath.row);
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    DetailViewController* detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    detailViewController.student = [self.studentList objectAtIndex:indexPath.row];
    
    detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    [self.navigationController pushViewController:detailViewController animated:NO];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
