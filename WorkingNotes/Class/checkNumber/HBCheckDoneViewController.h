//
//  HBCheckDoneViewController.h
//  WorkingNotes
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBButton.h"
#import "Student.h"

typedef void(^ReloadBlock)();

@interface HBCheckDoneViewController : UIViewController

@property (assign, nonatomic)  BOOL isFirst;

// 总人数
@property (assign, nonatomic) NSInteger count;
// 未到人员
@property (assign, nonatomic) NSInteger absentCount;
// 迟到
@property (assign, nonatomic) NSInteger lateCount;
// 已到人数
@property (assign, nonatomic) NSInteger attendCount;

- (id)initWithBlock:(ReloadBlock)block;

@end
