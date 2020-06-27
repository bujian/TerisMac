//
//  Cube.m
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "CubeSet.h"
#import <Cocoa/Cocoa.h>
#import "NSView+Frame.h"
#import "CubeView.h"

@interface CubeSet()

@property (nonatomic, strong) Vec2Arrays shapes;
@property (nonatomic, assign) NSInteger curShapeIndex;
@property (nonatomic, assign) int sideLength;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSView* thisView;
@end

@implementation CubeSet
- (instancetype)initWithShapes:(Vec2Arrays)shapes Side:(int)side{
    self = [super init];
    if (self) {
        _shapes = shapes;
        _curShapeIndex = 0;
        _sideLength = side;
    }
    return self;
}

-(NSView*)createCubeView:(NSRect)rect OriginPos:(Vector2*)ori{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    NSView* cubes = [[NSView alloc]initWithFrame:NSMakeRect(rect.origin.x, rect.origin.y, width * _sideLength, height * _sideLength)];
    
    Vec2Array curShape = [self curShape];
    for (int i = 0; i < curShape.count; i ++) {
        Vector2* shapePoint = curShape[i];
        NSRect rect = NSMakeRect(shapePoint.x * width, shapePoint.y * height, width, height);
        CubeView* cube =[[CubeView alloc]initWithFrame:rect];
        cube.pos = shapePoint;
        [cube setViewBackgrounImage:shapePoint.imagePath];
        [cubes addSubview:cube];
    }
    _oriPos = ori;
    _cellWidth = width;
    _cellHeight = height;
    _thisView = cubes;
    return _thisView;
}

-(Vec2Array)nextShape{
    Vec2MutArray arrays = [NSMutableArray array];
    Vec2Array shape = _shapes[[self nextShapeIndex]];
    for (int i = 0; i < shape.count; i++) {
        [arrays addObject:[shape[i] add:_oriPos]];
    }
    return [arrays copy];
}

-(Vec2Array)curShape{
    return _shapes[_curShapeIndex];
}

-(NSInteger)nextShapeIndex{
    return _curShapeIndex + 1 >= _shapes.count ? 0 : _curShapeIndex + 1;
}

-(void)shapeChange{
    _curShapeIndex = [self nextShapeIndex];
    Vec2Array curShapePoints = [self curShape];
    NSMutableArray<CubeView *>* cubeViews = [NSMutableArray arrayWithArray: _thisView.subviews];
    for (int i = 0; i < curShapePoints.count; i++) {
        Vector2* shape = curShapePoints[i];
        cubeViews[i].pos = shape;
        cubeViews[i].frame = NSMakeRect(shape.x * _cellWidth, shape.y * _cellHeight, _cellWidth, _cellHeight);
    }
}

-(void)moveDown{
    _thisView.bj_y -= _cellHeight;
    _oriPos.y -= 1;
}

-(void)moveLeft{
    _thisView.bj_x -= _cellWidth;
    _oriPos.x -=1;
    
}

-(void)moveRight{
    _thisView.bj_x += _cellWidth;
    _oriPos.x += 1;
}

-(Vec2Array)getPointsAfterMove:(Vector2*)offset{
    Vec2Array curShape = [[self curShape] copy];
    Vec2MutArray newShape = [NSMutableArray array];
    for (int i = 0; i < curShape.count; i++) {
        [newShape addObject: [[curShape[i] add:_oriPos] add:offset]];
    }
    return [newShape copy];
}

-(NSView*)releaseCubes{
    for (CubeView* sub in _thisView.subviews) {
        sub.pos = [sub.pos add:_oriPos];
    }
    return _thisView;
}


@end
