//
//  CubeSetFactory.h
//  SecondPro
//
//  Created by shgbit on 2020/6/24.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2.h"
NS_ASSUME_NONNULL_BEGIN
static const int PRE_DATA_COUNT = 2;

@interface CubeSetFactory : NSObject
-(Vec2MutArrays)getCubeShapes;
@end

NS_ASSUME_NONNULL_END
