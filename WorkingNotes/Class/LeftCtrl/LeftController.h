//
//  LeftController.h
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftHeader.h"
#import "LeftDelegate.h"
@interface LeftController : UIViewController

@property (nonatomic,weak)id<LeftDelegate>delegate;

@end
