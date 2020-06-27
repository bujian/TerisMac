//
//  CubeSetFactory.m
//  SecondPro
//
//  Created by shgbit on 2020/6/24.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "CubeSetFactory.h"
@interface CubeSetFactory()
@property (nonatomic, strong) NSArray* colorArray;
@property (nonatomic, strong) NSMutableArray* preData;
@property (nonatomic, strong) NSMutableArray<Vec2MutArrays>* formatData;

@end

@implementation CubeSetFactory
- (void)parseData:(NSArray<NSNumber *> *)unformat {
    _formatData = [NSMutableArray array];
    NSInteger cubeShapePointCount = 4;
    NSInteger cubeShapeCount = 4;
    NSInteger cubeShapeDataCount = 8;
    NSInteger cubeDataCount = cubeShapeDataCount * cubeShapeCount;
    NSInteger cubeCount = unformat.count / cubeDataCount;
    for (int i = 0; i < cubeCount; i++) {
        NSInteger cubeStartIndex = i * cubeDataCount;
        Vec2MutArrays shapeArray = [NSMutableArray array];
        for (int j = 0; j < cubeShapeCount; j++) {
            NSInteger shapeStartIndex = cubeStartIndex + j * cubeShapeDataCount;
            Vec2MutArray pointArray = [NSMutableArray array];
            for (int k = 0; k < cubeShapePointCount; k++) {
                NSInteger pointStartIndex = shapeStartIndex + k * 2;
                Vector2* pos = [[Vector2 alloc] initWith:unformat[pointStartIndex].integerValue and: unformat[pointStartIndex + 1].integerValue];
                int colorIndex = arc4random() % _colorArray.count;
                pos.imagePath = _colorArray[colorIndex];
                [pointArray addObject:pos];
            }
            [shapeArray addObject:pointArray];
        }
        [_formatData addObject:shapeArray];
    }
}

- (void)initData {
    _colorArray = [[NSArray alloc] initWithObjects:@"blue", @"blue2",@"cyan",@"green", @"orange",@"orange2",@"purple",@"red", @"yellow" , nil];
    NSArray<NSNumber*>* unformat = [[NSArray alloc] initWithObjects:
                                    //o o
                                    //  o o
                                    //
                                    @(0),@(2), @(1),@(2), @(1),@(1), @(2),@(1),
                                    @(1),@(0), @(1),@(1), @(2),@(1), @(2),@(2),
                                    @(0),@(1), @(1),@(1), @(1),@(0), @(2),@(0),
                                    @(0),@(0), @(0),@(1), @(1),@(1), @(1),@(2),
                                    //  o
                                    //o o o
                                    //
                                    @(0),@(1), @(1),@(1), @(1),@(2), @(2),@(1),
                                    @(1),@(0), @(1),@(1), @(1),@(2), @(2),@(1),
                                    @(0),@(1), @(1),@(1), @(1),@(0), @(2),@(1),
                                    @(0),@(1), @(1),@(1), @(1),@(0), @(1),@(2),
                                    //  o o
                                    //o o
                                    //
                                    @(0),@(1), @(1),@(1), @(1),@(2), @(2),@(2),
                                    @(1),@(1), @(1),@(2), @(2),@(1), @(2),@(0),
                                    @(0),@(0), @(1),@(0), @(1),@(1), @(2),@(1),
                                    @(0),@(2), @(0),@(1), @(1),@(1), @(1),@(0),
                                    //    o
                                    //o o o
                                    //
                                    @(0),@(1), @(1),@(1), @(2),@(1), @(2),@(2),
                                    @(1),@(0), @(1),@(1), @(1),@(2), @(2),@(0),
                                    @(0),@(0), @(0),@(1), @(1),@(1), @(2),@(1),
                                    @(0),@(2), @(1),@(2), @(1),@(1), @(1),@(0),
                                    //o
                                    //o o o
                                    //
                                    @(0),@(2), @(0),@(1), @(1),@(1), @(2),@(1),
                                    @(2),@(2), @(1),@(2), @(1),@(1), @(1),@(0),
                                    @(0),@(1), @(1),@(1), @(2),@(1), @(2),@(0),
                                    @(0),@(0), @(1),@(0), @(1),@(1), @(1),@(2),
                                    //o o o o
                                    //
                                    //
                                    //
                                    @(0),@(2), @(1),@(2), @(2),@(2), @(3),@(2),
                                    @(2),@(0), @(2),@(1), @(2),@(2), @(2),@(3),
                                    @(0),@(1), @(1),@(1), @(2),@(1), @(3),@(1),
                                    @(1),@(0), @(1),@(1), @(1),@(2), @(1),@(3),
                                    //
                                    //
                                    //o o
                                    //o o
                                    @(0),@(0), @(0),@(1), @(1),@(1), @(1),@(0),
                                    @(0),@(0), @(0),@(1), @(1),@(1), @(1),@(0),
                                    @(0),@(0), @(0),@(1), @(1),@(1), @(1),@(0),
                                    @(0),@(0), @(0),@(1), @(1),@(1), @(1),@(0),
                                    
                                    nil];
    [self parseData:unformat];
    [self initPreData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(Vec2MutArrays)getCubeShapes{
    Vec2MutArrays data = _preData[0];
    [_preData removeObject:data];
    [self generateSinglePreData];
    return data;
}

-(void)initPreData{
    int i = 0;
    _preData = [NSMutableArray array];
    while (i < PRE_DATA_COUNT) {
        [self generateSinglePreData];
        i++;
    }
}

-(void)generateSinglePreData{
    int num = arc4random() % _formatData.count;
    [_preData addObject: _formatData[num]];
}

@end
