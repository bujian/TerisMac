//
//  CubeSetFactory.m
//  SecondPro
//
//  Created by shgbit on 2020/6/24.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#define PRE_DATA_COUNT 3

#import "CubeSetFactory.h"
@interface CubeSetFactory()
@property (nonatomic, strong) NSMutableArray* preData;
@property (nonatomic, strong) NSArray* formatData;

@end

@implementation CubeSetFactory

- (void)initData {
    
    //o o
    //  o o
    //
    NSArray* shape1 = @[@(0),@(2),@(1),@(2), @(1),@(1),@(2),@(1)];
    //  o
    //o o o
    //
    NSArray* shape2 = @[@(0),@(1), @(1),@(1), @(1),@(2), @(2),@(1)];
    //  o o
    //o o
    //
    NSArray* shape3 = @[@(0),@(1), @(1),@(1), @(1),@(2), @(2),@(2)];
    //    o
    //o o o
    //
    NSArray* shape4 = @[@(0),@(1), @(1),@(1), @(2),@(1), @(2),@(2)];
    //o
    //o o o
    //
    NSArray* shape5 = @[@(0),@(2), @(0),@(1), @(1),@(1), @(2),@(1)];
    //
    //
    //o o o o
    //
    NSArray* shape6 = @[@(0),@(2), @(1),@(2), @(2),@(2), @(3),@(2)];
    //
    //o o
    //o o
    NSArray* shape7 = @[@(0),@(0), @(0),@(1), @(1),@(1), @(1),@(0)];
    //o o
    //  o
    //o o
    NSArray* shape8 = @[@(0),@(0), @(1),@(0), @(1),@(1), @(1),@(2),@(0),@(2)];
    //o o o
    //o   o
    //o o o
    NSArray* shape9 = @[@(0),@(0), @(1),@(0), @(2),@(0),@(2),@(1),@(2),@(2),
                       @(1),@(2),@(0),@(2),@(0),@(1)];
    //  o
    //o o o
    //  o
//    NSArray* shape10 = @[];
    //o
    //o o o
    //    o
//    NSArray* shape11 = @[];

    _formatData = @[shape1, shape2, shape3, shape4, shape5, shape6, shape7, shape8, shape9];
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

-(CubeSet*)getCubeSet{
    CubeSet* data = _preData[0];
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
    //num = 5;
    NSArray* data = _formatData[num];
    CubeSet* set = [[CubeSet alloc]initWithShapes:data];
    [_preData addObject: set];
}

-(NSArray*)getPreData{
    return [_preData copy];
}

@end
