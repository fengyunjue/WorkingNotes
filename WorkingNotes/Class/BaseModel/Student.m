//
//  Students.m
//  WorkingNotes
//
//  Created by homeboy on 14-9-11.
//  Copyright (c) 2014年 com.homeboy. All rights reserved.
//

#import "Student.h"

@implementation Student

//初始化方法
- (id)init
{
    _id = 0;
    _name = @"";
    _sex = @"";
    _number = 0;
    _phone  = 0;
    _room = @"";
    _favorite = @"";
    _mark = @"";
    _pic = @"";
    return self;
}

#pragma mark- 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeInteger:_number forKey:@"number"];
    [aCoder encodeInteger:_phone forKey:@"phone"];
    [aCoder encodeObject:_room forKey:@"room"];
    [aCoder encodeObject:_favorite forKey:@"favorite"];
    [aCoder encodeObject:_mark forKey:@"mark"];
    [aCoder encodeObject:_pic forKey:@"pic"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:@"name"];
    _sex = [aDecoder decodeObjectForKey:@"sex"];
    _number = [aDecoder decodeIntegerForKey:@"number"];
    _phone = [aDecoder decodeIntegerForKey:@"phone"];
    _room = [aDecoder decodeObjectForKey:@"room"];
    _favorite = [aDecoder decodeObjectForKey:@"favorite"];
    _mark = [aDecoder decodeObjectForKey:@"mark"];
    _pic = [aDecoder decodeObjectForKey:@"pic"];
    return self;
}
@end

