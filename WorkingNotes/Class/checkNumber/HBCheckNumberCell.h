//
//  HBCheckNumberCell.h
//  WorkingNotes
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "HBButton.h"

#define kRowHeight 80

@interface HBCheckNumberCell : UITableViewCell

@property (strong, nonatomic) Student *student;

@property (strong, nonatomic) HBButton *button1;
@property (strong, nonatomic) HBButton *button2;

@end

