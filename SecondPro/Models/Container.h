//
//  Container.h
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Vector2.h"

NS_ASSUME_NONNULL_BEGIN

@interface Container : NSObject
@property (nonatomic, strong) Vector2* size;

- (instancetype)initWithView:(NSView*) view;
-(NSRect)getStartRect;

/**
 检索行，没有空格就删掉
 @param lines 行索引列表
 */
-(void)CheckLines:(NSArray*)lines;

/**
 是否能旋转
 @return bool
 */
-(bool)canRotate:(Vec2Array)postions;
/**
 是否能移动
 @param postions 下一次移动之后的位置
 @return bool
 */
-(bool)canMove:(Vec2Array)postions;
/**
 在容器中增加方块
 @param view 方块父识图
 */
-(NSArray*)addCube:(NSView*)view;
/**
 行移动，发生在消行之后
 @param lineIndex 移动行索引
 @param linesCount 移动行数
 */
-(void)lineMove:(int)lineIndex moveLineCount:(int)linesCount;
-(void)removeLine:(int)lineNum;
@end

NS_ASSUME_NONNULL_END
