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
- (instancetype)initWithShapes:(Vec2Arrays)shapes Side:(int)side;
-(NSView*)createCubeView:(NSRect)rect OriginPos:(Vector2*)ori;
-(Vec2Array)nextShape;
-(Vec2Array)curShape;
-(NSInteger)nextShapeIndex;
-(void)shapeChange;
-(void)moveDown;
-(void)moveLeft;
-(void)moveRight;
-(Vec2Array)getPointsAfterMove:(Vector2*)offset;
-(NSView*)releaseCubes;
@end

NS_ASSUME_NONNULL_END
