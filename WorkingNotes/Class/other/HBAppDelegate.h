//
//  HBAppDelegate.h
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "LoginUser.h"

typedef void(^CompletionBlock)();

@interface HBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  全局的XMPPStream, 只读属性
 */
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
/**
 *  是否为注册
 */
@property (nonatomic, assign) BOOL isRegisterUser;
/**
 *  连接服务器时调用
 *
 *  @param completion 连接服务器成功时调用
 *  @param failed     连接服务器失败时调用
 */
- (void)connectWithLoginUser:(LoginUser *)user Completion:(CompletionBlock)completion failed:(CompletionBlock)failed;

/**
 *  注销用户登录
 */
- (void)logout;
@end
