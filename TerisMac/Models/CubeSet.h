//
//  Cube.h
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2.h"
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MoveDir_Up,
    MoveDir_Down,
    MoveDir_Left,
    MoveDir_Right
} MoveDir;

@interface CubeSet : NSObject
@property (nonatomic, strong) Vector2* oriPos;
- (instancetype)initWithShapes:(NSArray*)shapes;
-(NSView*)createCubeSetViewWithCubeRect:(NSRect)rect OriginPos:(Vector2*)ori;
-(NSArray*)getPointsAfterRotate;
-(NSArray*)getPointsAfterMove:(Vector2*)offset;
-(void)shapeChange;
-(NSView*)releaseCubes;
-(void)doMove:(Vector2*)offset;
-(NSArray*)getContainerPoints:(NSArray*)points;
-(NSView*)createCubeSetViewWithViewRect:(NSRect)rect;
@end

NS_ASSUME_NONNULL_END
