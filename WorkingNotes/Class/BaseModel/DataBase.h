//
//  DataBase.h
//  WorkingNotes
//
//  Created by homeboy on 14-9-13.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//  数据库操作

#import <Foundation/Foundation.h>
#import "Student.h"
#import <sqlite3.h>
@interface DataBase : NSObject

- (BOOL)insertStudent:(Student *)insertStudent;             //插入数据

- (BOOL)updataStudent:(Student *)updataStudent;             //更新数据

- (BOOL)deleteStudent:(Student *)deleteStudent;             //删除数据

- (BOOL)deleteAllStudent;                                   //删除所有对象

//查询数据库，搜索条件位为要查询数据的id，返回数据为查询到的student对象
- (NSMutableArray *)selectedStudents:(int)studentID;

- (NSMutableArray *)selectedAllStudents;                    //查询所有students对象


@end


