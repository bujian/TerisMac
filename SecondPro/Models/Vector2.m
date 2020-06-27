//
//  Vector2.m
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "Vector2.h"

@implementation Vector2
- (instancetype)initWith:(NSInteger)col and: (NSInteger)row
{
    self = [super init];
    if (self) {
        _y = row;
        _x = col;
    }
    return self;
}

-(Vector2*)add:(Vector2*) vec{
    return [[Vector2 alloc]initWith:vec.x + _x and: vec.y + _y];
}
@end
