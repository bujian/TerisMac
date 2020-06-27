//
//  NSView+Frame.h
//  SecondPro
//
//  Created by shgbit on 2020/6/23.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSView (Frame)

@property(nonatomic, assign)CGFloat bj_x;
@property(nonatomic, assign)CGFloat bj_y;

- (void)setViewBackgrounImage:(NSString *)image;

@end


