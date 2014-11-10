//
//  HBCheckStudent.h
//  WorkingNotes
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"

typedef enum
{
    kUnknow = 0,
    kAttend,
    kAbsent
}kState;

@interface HBCheckStudent : Student

// 是否已经点过
@property (assign, nonatomic) BOOL isCheck;

// 点名状态是缺席或是出席
@property (assign, nonatomic) kState buttonState;

+ (id)hbCheckStudentWithStudent:(Student *)student isCheck:(BOOL)isCheck kState:(kState)buttonState;

@end
