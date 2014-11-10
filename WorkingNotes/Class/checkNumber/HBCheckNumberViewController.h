//
//  HBCheckNumberViewController.h
//  WorkingNotes
//
//  Created by admin on 14-9-14.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@interface HBCheckNumberViewController : UIViewController <CustomIOS7AlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>

@property (assign, nonatomic)  BOOL isFirst;


@end
