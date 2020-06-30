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

@property (nonatomic, strong) NSArray* shapes;
@property (nonatomic, assign) int sideLength;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSView* thisView;
@property (nonatomic, strong) NSArray* colorArray;
@end

@implementation CubeSet
- (instancetype)initWithShapes:(NSArray*)shapes{
    self = [super init];
    if (self) {
        [self getShape:shapes];
    }
    return self;
}

-(void)getShape:(NSArray*)initData{
    
    NSArray* colorArray = [[NSArray alloc] initWithObjects:@"blue", @"blue2",@"cyan",@"green", @"orange",@"orange2",@"purple",@"red", @"yellow" , nil];
    _sideLength = 0;
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < initData.count && i + 1 < initData.count; i += 2) {
        int x = [initData[i] intValue];
        int y = [initData[i + 1] intValue];
        Vector2* pos = [[Vector2 alloc] initWith:x and:y];
        if(_sideLength < x) _sideLength = x;
        if(_sideLength < y) _sideLength = y;
        
        int num = arc4random() % colorArray.count;
        pos.imagePath = colorArray[num];
        [array addObject:pos];
    }
    _shapes = [array copy];
    _sideLength += 1;
}

- (void)drawCubeView:(NSView *)cubes height:(CGFloat)height width:(CGFloat)width {
    NSArray* curShape = _shapes;
    for (int i = 0; i < curShape.count; i ++) {
        
        Vector2* shapePoint = curShape[i];
        NSRect rect = NSMakeRect(shapePoint.x * width, shapePoint.y * height, width, height);
        CubeView* cube =[[CubeView alloc]initWithFrame:rect];
        cube.pos = shapePoint;
        [cube setViewBackgrounImage:shapePoint.imagePath];
        [cubes addSubview:cube];
    }
}

-(NSView*)createCubeSetViewWithCubeRect:(NSRect)rect OriginPos:(Vector2*)ori{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    NSView* cubes = [[NSView alloc]initWithFrame:NSMakeRect(rect.origin.x, rect.origin.y, width * _sideLength, height * _sideLength)];
    
    [self drawCubeView:cubes height:height width:width];
    _oriPos = ori;
    _cellWidth = width;
    _cellHeight = height;
    _thisView = cubes;
    return _thisView;
}

-(NSView*)createCubeSetViewWithViewRect:(NSRect)rect{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    NSView* cubes = [[NSView alloc]initWithFrame:NSMakeRect(rect.origin.x, rect.origin.y, width, height)];
    
    [self drawCubeView:cubes height:height/_sideLength width:width/_sideLength];
    _thisView = cubes;
    return _thisView;
}

-(NSArray*)getPointsAfterRotate{
    return [self getContainerPoints: [self arraysRotate:_shapes]];
}

-(void)shapeChange{
    NSArray* curShapePoints = [self arraysRotate:_shapes];
    NSMutableArray<CubeView *>* cubeViews = [NSMutableArray arrayWithArray: _thisView.subviews];
    for (int i = 0; i < curShapePoints.count; i++) {
        Vector2* shape = curShapePoints[i];
        cubeViews[i].pos = shape;
        cubeViews[i].frame = NSMakeRect(shape.x * _cellWidth, shape.y * _cellHeight, _cellWidth, _cellHeight);
    }
    _shapes = curShapePoints;
}


-(void)doMove:(Vector2*)offset{
    _oriPos = [_oriPos add:offset];
    _thisView.bj_x += _cellWidth * offset.x;
    _thisView.bj_y += _cellHeight * offset.y;
}

-(NSArray*)getPointsAfterMove:(Vector2*)offset{
    NSArray* curShape = _shapes;
    NSMutableArray* newShape = [NSMutableArray array];
    for (int i = 0; i < curShape.count; i++) {
        Vector2* point = curShape[i];
        [newShape addObject: [point add:offset]];
    }
    
    return [self getContainerPoints:newShape];
}

-(NSView*)releaseCubes{
    for (CubeView* sub in _thisView.subviews) {
        sub.pos = [sub.pos add:_oriPos];
    }
    return _thisView;
}

-(NSArray*)arraysRotate:(NSArray*)array{
    NSMutableArray* temp = [NSMutableArray array];
    int len = _sideLength;
    for (int i = 0; i < array.count; i++) {
        Vector2* old = array[i];
        Vector2* new = [[Vector2 alloc] initWith:old.y and:len - 1 - old.x];
        [temp addObject:new];
    }
    return [temp copy];
}

-(NSArray*)getContainerPoints:(NSArray*)points{
    NSMutableArray* newArray = [NSMutableArray array];
    for (int i = 0; i < points.count; i++) {
        Vector2* point = points[i];
        [newArray addObject: [point add: _oriPos]];
    }
    return [newArray copy];
}
@end
