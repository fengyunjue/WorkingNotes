//
//  HBLoginViewController.m
//  WorkingNotes
//
//  Created by admin on 14-11-10.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBLoginViewController.h"
#import "LTView.h"
#import "HBAppDelegate.h"
#import "NSString+Helper.h"
#import "LoginUser.h"

@interface HBLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *textArray;

@end

@implementation HBLoginViewController
#pragma mark - AppDelegate 的助手方法
- (HBAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (NSArray *)textArray
{
    if (_textArray == nil) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化视图
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 50)];
    label.text = @"登录";
    label.font = [UIFont systemFontOfSize:28];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    NSArray *labelNames=@[@"用户名",@"密码", @"服务器"];
    NSArray *placeHolders=@[@"请输入用户名",@"请输入密码",@"请输入服务器地址"];
    CGFloat y=80;
    for (int i=0; i<[labelNames count]; i++) {
        
        LTView *ltview=[[LTView alloc]initWithFrame:CGRectMake(10, y, 280, 30) labelText:[labelNames objectAtIndex:i] placeholder:[placeHolders objectAtIndex:i] spacing:0];
        ltview.delegate=self;
        ltview.tag = 100+i;//设置ltview的tag值，通过tag值取得ltview上的textField
#pragma mark ---根据tag值并判断tag值，设置对应文本框键盘的Return键
        if (ltview.tag!=102) {
            ltview.textField.returnKeyType=UIReturnKeyNext;
        }
        else{
            ltview.textField.returnKeyType=UIReturnKeyDone;
            
        }
        
        if (ltview.tag == 101) {
            ltview.textField.secureTextEntry = YES;
        }
        [self.view addSubview:ltview];
        y+=50;
        
        [self.textArray addObject:ltview.textField];
    }
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setFrame:CGRectMake(50, 220, 50, 44)];
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.tag = 1;
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [registerBtn setFrame:CGRectMake(150, 220, 50, 44)];
    [self.view addSubview:registerBtn];
}

//回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.superview.tag != 102)
    {
        LTView *nextView = (LTView *)[[UIApplication sharedApplication].keyWindow viewWithTag:textField.superview.tag+1];
        [nextView.textField becomeFirstResponder];
    }else{
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark _Actions
- (void)loginBtn:(UIButton *)button
{
    // 1. 检查用户输入是否完整，在商业软件中，处理用户输入时
    // 通常会截断字符串前后的空格（密码除外），从而可以最大程度地降低用户输入错误
    NSArray *strArray = [self.textArray valueForKeyPath:@"text"];
    LoginUser *user = [[LoginUser alloc]init];
    
    user.userName = [strArray[0] trimString];
    // 用些用户会使用空格做密码，因此密码不能去除空白字符
    user.password = strArray[1];
    user.hostName = [strArray[2] trimString];
    if ([user.userName isEmptyString] ||
        [user.password isEmptyString] ||
        [user.hostName isEmptyString]) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alter show];
        
        return;
    }
    
//    // 2. 将用户登录信息写入系统偏好
//    [[LoginUser sharedLoginUser] setUserName:userName];
//    [[LoginUser sharedLoginUser] setPassword:password];
//    [[LoginUser sharedLoginUser] setHostName:hostName];
    
    // 3. 让AppDelegate开始连接
    // 告诉AppDelegate，当前是注册用户
    NSString *errorMessage = nil;
    
    if (button.tag == 1) {
        [self appDelegate].isRegisterUser = YES;
        errorMessage = @"注册用户失败！";
    } else {
        errorMessage = @"用户登录失败！";
    }

    [[self appDelegate] connectWithLoginUser:user Completion:^{
        
    } failed:^{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alter show];
    }];
}

@end
