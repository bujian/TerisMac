//
//  Container.m
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "Container.h"
#import "Vector2.h"
#import "CubeSet.h"
#import "NSView+Frame.h"

@interface Container()
typedef NSMutableArray<NSMutableArray*>* StateArrays;

@property (nonatomic, strong) StateArrays states;
@property (nonatomic, assign) int xMax;
@property (nonatomic, assign) int yMax;
@property (nonatomic, strong) NSView* containerView;
@end

@implementation Container

- (instancetype)initWithView:(NSView*) view{
    self = [super init];
    if (self) {
        _containerView = view;
        _containerView.wantsLayer = YES;
        _containerView.layer.masksToBounds = YES;
        _xMax = 10;
        _yMax = 18;
        _states = [NSMutableArray array];
        for (int i = 0; i < _yMax + EMPTY_ROW_COUNT; i++) {
            NSMutableArray* subArray = [NSMutableArray array];
            for (int j = 0; j < _xMax; j++) {
                [subArray addObject: @""];
            }
            [_states addObject:subArray];
        }
    }
    return self;
}

-(void)removeLines:(NSArray*)lineNums{
    for (int i = 0; i < lineNums.count; i++) {
        int num = [lineNums[i] intValue] ;
        [self removeLine: num];
    }
}

-(bool)CheckIfLineHasEmptyPlace:(int)lineNum{
    bool hasEmpty = false;
    for (int i = 0; i < _states[lineNum].count; i++) {
        if([_states[lineNum][i] isEqual:@""]){
            hasEmpty = true;
            break;
        }
    }
    return hasEmpty;
}

- (void)moveOtherLinesAfterRemoveLines:(NSArray *)linesNeedToRemove {
    int min = [linesNeedToRemove[0] intValue];
    for (int i = min + 1; i < _yMax; i++) {
        int moveCount = 0;
        for(int j = 0; j < linesNeedToRemove.count; j++){
            int lineNum = [linesNeedToRemove[j] intValue];
            //被删掉的行不需要移动
            if(i == lineNum)
            {
                moveCount = 0;
                break;
            }
            else if(i > lineNum) moveCount++;
        }
        [self lineMove:i moveLineCount:moveCount];
    }
}

-(NSInteger)checkLinesNeededToRemove:(NSArray*)lines{
    NSMutableArray* linesNeedToRemove = [NSMutableArray array];
    for (int i = 0; i < lines.count; i++) {
        NSNumber* num = lines[i];
        bool hasEmpty = [self CheckIfLineHasEmptyPlace:num.intValue];
        if(!hasEmpty)
        {
            [linesNeedToRemove addObject:num];
        }
    }
    if(linesNeedToRemove.count == 0) return 0;
    [linesNeedToRemove sortedArrayUsingSelector:@selector(compare:)];
    //排序
    NSArray* sortedLines = [linesNeedToRemove sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger o1 = ((NSNumber*)obj1).integerValue;
        NSInteger o2 = ((NSNumber*)obj2).integerValue;
        if(o1 < o2) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    //消行
    [self removeLines:sortedLines];
    //移动
    [self moveOtherLinesAfterRemoveLines:sortedLines];
    
    return linesNeedToRemove.count;
}

- (bool)checkLinesOverContainer{
    bool ret = false;
    for (int i = 0; i < _xMax; i++) {
        if(![_states[_yMax][i] isEqual:@""]){
            ret = true;
        }
    }
    return ret;
}

-(void)removeLine:(int)lineNum{
    //消除行
    for (int i = 0; i < _states[lineNum].count; i++) {
        CubeView* view = _states[lineNum][i];
        [view removeFromSuperview];
        _states[lineNum][i] = @"";

    }

}

-(bool)canRotate:(NSArray*)positions{
    bool ret = true;
    for (int i = 0; i < positions.count; i++) {
        Vector2* pos = positions[i];
        //超过边框
        if(pos.x < 0 || pos.x >= _xMax || pos.y < 0)
        {
            ret = false;
        }
        //在上面
        else if(pos.y >= _yMax)
        {
            
        }
        //撞到已有的方块
        else if(![_states[pos.y][pos.x] isEqual: @""]){
            ret = false;
            break;
        }
    }
    return ret;
}

-(bool)canMove:(NSArray*)postions{
    return [self canRotate:postions];
}

-(NSArray*)addCube:(NSView *)lastFatherView{
   //lastFatherView.subviews
    NSMutableArray* lines = [NSMutableArray array];
    NSMutableArray* views = [NSMutableArray arrayWithArray:lastFatherView.subviews];
    for (CubeView* sub in views) {
        NSRect rect = [sub convertRect:sub.bounds toView:_containerView];
        [_containerView addSubview:sub];
        sub.frame = rect;
        _states[sub.pos.y][sub.pos.x] = sub;
        
        bool hadRepeatedValue = false;
        for (int i = 0; i < lines.count; i++) {
            if([lines[i] isEqualToNumber:@(sub.pos.y)]){
                hadRepeatedValue = true;
                break;
            }
        }
        if(!hadRepeatedValue) [lines addObject:@(sub.pos.y)];
    }
    return [lines copy];
}

-(NSRect)getStartRect{
    CGSize size = _containerView.bounds.size;
    float width = size.width / _xMax;
    float height = size.height / _yMax;
    return NSMakeRect(size.width / 2, size.height, width, height);
}

-(void)lineMove:(int)lineIndex moveLineCount:(int)linesCount{
    if(linesCount == 0) return;
    int toIndex = lineIndex - linesCount;
    for (int i = 0; i < _xMax; i++) {
        CubeView* cube = _states[toIndex][i] = _states[lineIndex][i];
        if(![cube isEqual:@""]) cube.bj_y -= cube.frame.size.height * linesCount;
        _states[lineIndex][i] = @"";
    }
}

-(void)disableContainer{
    for (int i = 0; i < _states.count; i++) {
        for (int j = 0; j < _states[i].count; j++) {
            CubeView* cube = _states[i][j];
            if(![cube isEqual:@""]){
                [cube setViewBackgrounImage:@"red"];
            }
        }
    }
}

-(void)clearContainer{
    for (int i = 0; i < _states.count; i++) {
        for (int j = 0; j < _states[i].count; j++) {
            CubeView* cube = _states[i][j];
            if(![cube isEqual:@""]){
                [cube removeFromSuperview];
                _states[i][j] = @"";
            }
        }
    }
}


- (Vector2 *)size{
    return [[Vector2 alloc]initWith:_xMax and:_yMax];
}

@end
