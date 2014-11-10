//
//  HBCheckTableViewCell.h
//  WorkingNotes
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RectButton.h"

#define kRowHeight 80

typedef enum
{
    kUnknow = 0,
    kAttend,
    kAbsent
}kState;


@interface HBCheckTableViewCell : UITableViewCell

@property (strong, nonatomic) RectButton *button1;
@property (strong, nonatomic) RectButton *button2;
// 是否缺席
- (void)setIsAttend:(kState)isAttend;


@end
