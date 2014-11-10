//
//  LeftDelegate.h
//  WorkingNotes
//
//  Created by homeboy on 14-9-9.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DockItem;
@protocol LeftDelegate <NSObject>
- (void)dockItem:(DockItem *)dockItem dockItemFrom:(int)from to:(int)to;
@end
