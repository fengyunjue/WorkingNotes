//
//  LoginUser.m
//  企信通
//
//  Created by apple on 13-11-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "LoginUser.h"
#import "NSString+Helper.h"

#define kXMPPUserNameKey    @"xmppUserName"
#define kXMPPPasswordKey    @"xmppPassword"
#define kXMPPHostNameKey    @"xmppHostName"

@implementation LoginUser
//single_implementation(LoginUser)
//
#pragma mark - 私有方法
+ (NSString *)loadStringFromDefaultsWithKey:(NSString *)key
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    return (str) ? str : @"";
}

- (NSString *)myJIDName
{
    return [NSString stringWithFormat:@"%@@%@", self.userName, self.hostName];
}

+ (void)saveLoginUser:(LoginUser *)user
{
    
    [user.userName saveToNSDefaultsWithKey:kXMPPUserNameKey];
    [user.password saveToNSDefaultsWithKey:kXMPPPasswordKey];
    [user.hostName saveToNSDefaultsWithKey:kXMPPHostNameKey];
}

+ (LoginUser *)getLoginUser
{
    LoginUser *user = [[LoginUser alloc]init];
    user.userName = [self loadStringFromDefaultsWithKey:kXMPPUserNameKey];
    user.password = [self loadStringFromDefaultsWithKey:kXMPPPasswordKey];
    user.hostName = [self loadStringFromDefaultsWithKey:kXMPPHostNameKey];
    return user;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"userName:%@  password:%@  hostName:%@  myJIDName:%@",self.userName, self.password, self.hostName, self.myJIDName];
}

@end
