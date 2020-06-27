//
//  NSView+Frame.m
//  SecondPro
//
//  Created by shgbit on 2020/6/23.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "NSView+Frame.h"

@implementation NSView (Frame)
- (void)setBj_x:(CGFloat)bj_x {
    NSRect rect = self.frame;
    rect.origin.x = bj_x;
    self.frame = rect;
}

- (CGFloat)bj_x {
    return self.frame.origin.x;
}


- (void)setBj_y:(CGFloat)bj_y {
    NSRect rect = self.frame;
    rect.origin.y = bj_y;
    self.frame = rect;
}

-(CGFloat)bj_y {
    return self.frame.origin.y;
}

- (void)setViewBackgrounImage:(NSString *)image {
    NSImage *img = [NSImage imageNamed:image];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithPatternImage:img].CGColor;
}


@end
