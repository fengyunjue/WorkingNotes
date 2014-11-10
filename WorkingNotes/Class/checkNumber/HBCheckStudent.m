//
//  HBCheckStudent.m
//  WorkingNotes
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "HBCheckStudent.h"

@implementation HBCheckStudent
#define ID   @"id"               //主键     int型
#define NAME @"name"             //姓名     string
#define SEX  @"sex"              //性别     string
#define NUMBER @"number"         //学号     int型
#define PHONE @"phone"           //电话     int型
#define ROOM @"room"             //寝室     string
#define FAVORITE @"favorite"     //爱好     string
#define MARK @"mark"             //备注     string
#define PIC @"pic"               //图片地址  string

+ (id)hbCheckStudentWithStudent:(Student *)student isCheck:(BOOL)isCheck kState:(kState)buttonState
{
    HBCheckStudent *CheckStudent = [[HBCheckStudent alloc]init];
    
    CheckStudent.isCheck = isCheck;
    CheckStudent.buttonState = buttonState;
    
    CheckStudent.id = student.id;
    CheckStudent.name = student.name;
    CheckStudent.sex = student.sex;
    CheckStudent.number = student.number;
    CheckStudent.room = student.room;
    CheckStudent.favorite = student.favorite;
    CheckStudent.mark = student.mark;
    CheckStudent.pic = student.pic;
    
    
    return CheckStudent;
}


@end
