//
//  HBAppDelegate.m
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBAppDelegate.h"
#import "DDMenuController.h"
#import "LeftController.h"
#import "MainController.h"
#import "HBLoginViewController.h"
#import "Singleton.h"
#import "LoginUser.h"
#import "NSString+Helper.h"

@interface HBAppDelegate()<XMPPStreamDelegate>
{
   // 用户信息
    LoginUser *_user;
    // XMPP重新连接XMPPStream
    XMPPReconnect *_xmppReconnect;
    // 登陆成功
    CompletionBlock _success;
    // 登陆失败
    CompletionBlock _failed;
}

// 用户登录
- (void)Login;
// 设置XMPPStream
- (void)setupStream;
// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardDownStream;
// 通知服务器用户上线
- (void)goOnline;
// 通知服务器用户下线
- (void)goOffline;
// 连接到服务器
- (void)connectWithLoginUser:(LoginUser *)user;
// 与服务器断开连接
- (void)disconnect;
@end

@implementation HBAppDelegate

/**
 *  连接服务器时调用
 *
 *  @param completion 连接服务器成功时调用
 *  @param failed     连接服务器失败时调用
 */
- (void)connectWithLoginUser:(LoginUser *)user Completion:(CompletionBlock)completion failed:(CompletionBlock)failed
{
    _success = completion;
    _failed = failed;
    _user = user;
    // 2. 如果已经存在连接，先断开连接，然后再次连接
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    // 3. 连接到服务器
    [self connectWithLoginUser:user];
}

- (void)dealloc
{
    // 释放XMPP相关对象及扩展模块
    [self teardDownStream];
}
#pragma mark - 切换视图控制器
- (void)viewControllerWithLogonState:(BOOL)isUserLogon
{
    UIViewController *viewController = nil;
    if (isUserLogon) {
        // 显示主控制器
        //创建一个左滑视图控制器 用于控制显示选中的视图控制器
        LeftController *leftCtrl =[[LeftController alloc]init];
        //创建一个学生列表控制器，也是该app的主控制器
        MainController *mainCtrl = [[MainController alloc]init];
        DDMenuController *menu = [[DDMenuController alloc]initWithRootViewController:mainCtrl];
        menu.leftViewController = leftCtrl;
        viewController = menu;
        leftCtrl.delegate = mainCtrl;
    }else{
        // 显示登陆控制器
        viewController = [[HBLoginViewController alloc]init];
    }
    
    // 在主线程队列负责切换viewController，而不影响后台代理的数据处理
    dispatch_async(dispatch_get_main_queue(), ^{
        // 把Storyboard的初始视图控制器设置为window的rootViewController
        self.window.rootViewController = viewController;
        if (!self.window.isKeyWindow) {
            [self.window makeKeyAndVisible];
        }
    });
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 设置XMPPStream
    [self setupStream];
    
    // 登录
    [self Login];
    
    return YES;
}
/**
 *  判断用户是否登录过
 *
 *  @return 登录过返回YES
 */
- (void)Login
{
    LoginUser *s = [LoginUser getLoginUser];
    if (![[LoginUser getLoginUser].userName isEmptyString]) {
        NSLog(@"%@  %@  %@",s.userName,s.hostName,s.password);
        [self connectWithLoginUser:s];
    }else{
        NSLog(@"----------%@  %@  %@",s.userName,s.hostName,s.password);
        [self viewControllerWithLogonState:NO];
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
//    NSLog(@"applicationWillResignActive");
//    [self disconnect];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [self connect];
}

#pragma mark - 设置XMPPStream

- (void)setupStream
{
    NSAssert(_xmppStream == nil, @"XMPPStream被多次实例化");
 
    // 1. 实例化XMPPStream
    _xmppStream = [[XMPPStream alloc]init];
    
    // 2. 添加代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    // 3. 扩展模块
    // 3.1 重新连接模块
    _xmppReconnect = [[XMPPReconnect alloc]init];
    // 3.2 将重新连接模块添加到XMPPStream
    [_xmppReconnect activate:_xmppStream];
}

#pragma marRk 销毁XMPPStream并注销已注册的扩展模块
- (void)teardDownStream
{
    // 1. 断开XMPPStream连接
    [_xmppStream disconnect];
    // 2. 取消激活在setupStream方法中激活的扩展模块
    [_xmppReconnect deactivate];
    // 3. 内存清理
    _xmppReconnect = nil;
    _xmppStream = nil;
}

#pragma mark 通知服务器用户上线
- (void)goOnline
{
    // 1. 实例化一个"展现",上线的报告,默认类型为available
    XMPPPresence *presence = [XMPPPresence presence];
    // 2. 发送Presence给服务器
    [_xmppStream sendElement:presence];
}
#pragma mark 通知服务器用户下线
- (void)goOffline
{
    // 1. 实例化一个下线展现
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    // 2. 发送Presence给服务器,通知服务器用户下线
    [_xmppStream sendElement:presence];
}

#pragma mark 连接到服务器
- (void)connectWithLoginUser:(LoginUser *)user
{
    // 1. 如果已经连接,直接返回
    if ([_xmppStream isConnected]) {
        return;
    }
    // 2. 设置XMPPStream的JID和主机(不能为空)
    if ([user.myJIDName isEmptyString] || [user.hostName isEmptyString]) {
        [self viewControllerWithLogonState:NO];
        return;
    }
    [_xmppStream setMyJID:[XMPPJID jidWithString:user.myJIDName]];
    // 不传主机也可以,不过验证速度会很慢,最好加上主机名,以减轻服务器的压力
    [_xmppStream setHostName:user.hostName];

    // 3. 开始连接
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        [self viewControllerWithLogonState:NO];
        NSLog(@"连接请求发送出错- %@", error.localizedDescription);
    }else{
        NSLog(@"连接请求成功");
    }
    
    _user = user;
}

#pragma mark 与服务器断开连接
- (void)disconnect
{
    // 1. 通知服务器下线
    [self goOffline];
   // 2. XMPPStream断开连接
    [_xmppStream disconnect];
}

#pragma mark - 代理方法
#pragma mark 连接完成调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
   
    NSString *password = _user.password ;

    if (_isRegisterUser) {
        // 用户注册,发送注册请求
        [_xmppStream registerWithPassword:password error:nil];
    }else if(!_isRegisterUser){
        // 用户登陆,发送登陆请求
        [_xmppStream authenticateWithPassword:password error:nil];
    }
}
#pragma mark 连接失败调用,或断开连接时调用(断开连接时error为空)
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"主机名出错");
        if (_failed != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _failed();
            });
        }
        
        [self viewControllerWithLogonState:NO];
    }
    [self viewControllerWithLogonState:NO];
}


#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    _isRegisterUser = NO;
    
    // 注册成功，直接发送验证身份请求，从而触发后续的操作
    [_xmppStream authenticateWithPassword:_user.password error:nil];
}

#pragma mark 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{

    if (_failed != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failed();
        });
    }
}

#pragma mark 身份验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    if (_success != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _success();
        });
    }
    // 2. 将用户登录信息写入系统偏好
    NSLog(@"213123123  %@",_user);
    [LoginUser saveLoginUser:_user];
    
    // 通知服务器用户上线
    [self goOnline];
    // 切换控制器
    [self viewControllerWithLogonState:YES];
}

#pragma mark 密码错误,身份验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"密码错误,身份验证失败");
    if (_failed != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failed();
        });
    }
    [self viewControllerWithLogonState:NO];

}

- (void)logout
{
    // 1. 通知服务器下线
    [self disconnect];
    // 2. 显示登陆页面
    [self viewControllerWithLogonState:NO];
}
@end
