//
//  DataBase.m
//  WorkingNotes
//
//  Created by homeboy on 14-9-13.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "DataBase.h"
#define ID   @"id"               //主键     int型
#define NAME @"name"             //姓名     string
#define NUMBER @"number"         //学号     int型
#define SEX  @"sex"              //性别     string
#define PHONE @"phone"           //电话     int型
#define ROOM @"room"             //寝室     string
#define FAVORITE @"favorite"     //爱好     string
#define MARK @"mark"             //备注     string
#define PIC @"pic"               //图片地址  string
//我定义了id为自增长，可以读，但不能更改
//--------name,number(int),sex,phone(int),room,favorite,mark,pic-----
#define tableName  @"students"   //表名
#define initDataBase [self openDataBase] && [self createTable:tableName]
@implementation DataBase
{
    sqlite3 *database;
    sqlite3_stmt *statement;    //句柄
    char *errorMsg;
}
- (id)init
{
    return self;
}
//数据库的path
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingString:@"data.sqlite"];
}
//打开数据库操作
- (BOOL)openDataBase
{
    if (sqlite3_open([[self dataFilePath]UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"-----打开数据库失败-----");
        return NO;
    }else{
        NSLog(@"打开数据库成功");
        return YES;
    }
}

- (BOOL)createTable:(NSString *)name
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,number INT, sex TEXT,phone INT,room TEXT,favorite TEXT,mark TEXT,pic TEXT)",tableName];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"-----数据库建表失败-----");
        return NO;
    }else{
        NSLog(@"数据库建表成功");
        return YES;
    }
}
- (BOOL)insertStudent:(Student *)insertStudent
{
    NSString *sql = [[NSString alloc]initWithFormat:@"INSERT INTO %@ (name,number,sex,phone,room,favorite,mark,pic) VALUES(?,?,?,?,?,?,?,?)",tableName];
    if (initDataBase) {
       //判断sql语句是否编译错误
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK){
            sqlite3_bind_text(statement, 1, [insertStudent.name UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 2, insertStudent.number);
            sqlite3_bind_text(statement, 3, [insertStudent.sex UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 4, insertStudent.phone);
            sqlite3_bind_text(statement, 5, [insertStudent.room UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 6, [insertStudent.favorite UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 7, [insertStudent.mark UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 8, [insertStudent.pic UTF8String], -1, NULL);
                     }
         /* sqlite3_step() has finished executing */
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"插入数据失败");
            return NO;
        }else{
            NSLog(@"插入数据成功");
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        }
    return NO;
}
- (BOOL)updataStudent:(Student *)updataStudent
{
    NSString *sql = [[NSString alloc]initWithFormat:@"UPDATE %@ SET name = ?,number = ?,sex = ?,phone = ?,room = ?,favorite = ?,mark = ?,pic = ? WHERE id = ?",tableName];
            if (initDataBase) {
                if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_bind_text(statement, 1,[updataStudent.name UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 2,updataStudent.number);
                    sqlite3_bind_text(statement, 3,[updataStudent.sex UTF8String], -1, SQLITE_TRANSIENT);
                      sqlite3_bind_int(statement, 4,updataStudent.phone);
                    sqlite3_bind_text(statement, 5,[updataStudent.room UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6,[updataStudent.favorite UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 7,[updataStudent.mark UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 8,[updataStudent.pic UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement, 9, updataStudent.id);
                 }
                if(sqlite3_step(statement) == SQLITE_ERROR){
                    NSLog(@"更新数据失败");
                    return NO;
                }else{
                    NSLog(@"更新数据成功");
                    sqlite3_finalize(statement);
                    sqlite3_close(database);
                    return YES;
                }
            }
            return NO;
}
- (BOOL)deleteStudent:(Student *)deleteStudent
{
    NSString *sql = [[NSString alloc]initWithFormat:@"DELETE FROM %@ WHERE id = ?",tableName];
            if (initDataBase) {
                if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(statement, 1, deleteStudent.id);
                }
                if (sqlite3_step(statement) == SQLITE_ERROR) {
                    NSLog(@"删除数据失败");
                    return NO;
                }else{
                    NSLog(@"删除数据成功");
                    sqlite3_finalize(statement);
                    sqlite3_close(database);
                    return YES;
                }
                
    }
    return NO;
}
- (BOOL)deleteAllStudent
{
    NSString *sql = [[NSString alloc]initWithFormat:@"DELETE * FROM %@",tableName];
            if (initDataBase) {
                if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK  && sqlite3_step(statement) == SQLITE_DONE) {
                    NSLog(@"删除所有数据成功");
                    sqlite3_finalize(statement);
                    sqlite3_close(database);
                    return YES;
                }else{
                    NSLog(@"删除所有数据成功");
                    return NO;
                }
    }
    return NO;
}
//查询数据库，searchID为要查询数据的ID，返回数据为查询到的数据
- (NSMutableArray *)selectedStudents:(int)studentID
{
    NSMutableArray *students = [NSMutableArray arrayWithCapacity:5];
    NSString *sql = [[NSString alloc]initWithFormat:
                     @"SELECT * FROM %@ WHERE id  = %d",tableName,studentID];
            if (initDataBase) {
                if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        int id = (int)sqlite3_column_int(statement, 0);
                        char *name = (char *)sqlite3_column_text(statement, 1);
                        NSString *nameStr = [NSString stringWithUTF8String:name];
                        int number = (int)sqlite3_column_int(statement, 2);
                        char *sex = (char *)sqlite3_column_text(statement, 3);
                        NSString *sexStr = [NSString stringWithUTF8String:sex];
                        int phone = (int)sqlite3_column_int(statement, 4);
                        char *room = (char *)sqlite3_column_text(statement, 5);
                        NSString *roomStr = [NSString stringWithUTF8String:room];
                        char *favorite = (char *)sqlite3_column_text(statement, 6);
                        NSString *favoriteStr = [NSString stringWithUTF8String:favorite];
                        char *mark = (char *)sqlite3_column_text(statement, 7);
                        NSString *markStr = [NSString stringWithUTF8String:mark];
                        char *pic = (char *)sqlite3_column_text(statement, 8);
                        NSString *picStr = [NSString stringWithUTF8String:pic];
                        Student *student = [[Student alloc]init];
                        student.id = id;
                        student.name = nameStr;
                        student.number = number;
                        student.sex = sexStr;
                        student.phone = phone;
                        student.room = roomStr;
                        student.favorite = favoriteStr;
                        student.mark = markStr;
                        student.pic =picStr;
                        [students addObject:student];
                    }
                    NSLog(@"查询student成功");
                    sqlite3_finalize(statement);
                    sqlite3_close(database);
                    return students;
                }else{
                    NSLog(@"查询student失败");
                    return nil;
                }
            }
    return nil;
}
- (NSMutableArray *)selectedAllStudents
{
    NSMutableArray *allStudents = [NSMutableArray arrayWithCapacity:10];
    NSString *sql = [[NSString alloc]initWithFormat:@"SELECT * FROM %@",tableName];
            if (initDataBase) {
                if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
                    //执行SQL语句，遍历表
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        int id = (int)sqlite3_column_int(statement, 0);
                        char *name = (char *)sqlite3_column_text(statement, 1);
                        NSString *nameStr = [NSString stringWithUTF8String:name];
                        int number = (int)sqlite3_column_int(statement, 2);
                        char *sex = (char *)sqlite3_column_text(statement, 3);
                        NSString *sexStr = [NSString stringWithUTF8String:sex];
                      int phone = (int)sqlite3_column_int(statement, 4);
                        char *room = (char *)sqlite3_column_text(statement, 5);
                        NSString *roomStr = [NSString stringWithUTF8String:room];
                        char *favorite = (char *)sqlite3_column_text(statement, 6);
                        NSString *favoriteStr = [NSString stringWithUTF8String:favorite];
                        char *mark = (char *)sqlite3_column_text(statement, 7);
                        NSString *markStr = [NSString stringWithUTF8String:mark];
                        char *pic = (char *)sqlite3_column_text(statement, 8);
                        NSString *picStr = [NSString stringWithUTF8String:pic];
                        Student *student = [[Student alloc]init];
                        student.id = id;
                        student.name = nameStr;
                        student.number = number;
                        student.sex = sexStr;
                        student.phone = phone;
                        student.room = roomStr;
                        student.favorite = favoriteStr;
                        student.mark = markStr;
                        student.pic =picStr;
                        [allStudents addObject:student];
                    }
                    NSLog(@"查询所有students成功");
                    sqlite3_finalize(statement);
                    sqlite3_close(database);
                    return allStudents;
                }else{
                    NSLog(@"查询所有students失败");
                    return nil;
                            }
        }
            return nil;
}
@end
        
