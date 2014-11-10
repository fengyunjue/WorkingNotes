//
//  Students.h
//  WorkingNotes
//
//  Created by homeboy on 14-9-11.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ID   @"id"               //主键     int型
#define NAME @"name"             //姓名     string
#define SEX  @"sex"              //性别     string
#define NUMBER @"number"         //学号     int型
#define PHONE @"phone"           //电话     int型
#define ROOM @"room"             //寝室     string
#define FAVORITE @"favorite"     //爱好     string
#define MARK @"mark"             //备注     string
#define PIC @"pic"               //图片地址  string
#warning ----------数据库接口使用方式-------------
//先初始化号数据库
//在初始化student对象
//数据库在进行操作
@interface Student : NSObject <NSCoding>
@property(nonatomic)int id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic)int number;
@property(nonatomic)int phone;
@property(nonatomic,copy)NSString *room;
@property(nonatomic,copy)NSString *favorite;
@property(nonatomic,copy)NSString *mark;
@property(nonatomic,copy)NSString *pic;
@end
