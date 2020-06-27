//
//  CubeView.h
//  SecondPro
//
//  Created by shgbit on 2020/6/23.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Vector2.h"

NS_ASSUME_NONNULL_BEGIN

@interface CubeView : NSView
@property (nonatomic, strong) Vector2* pos;
@end

NS_ASSUME_NONNULL_END
