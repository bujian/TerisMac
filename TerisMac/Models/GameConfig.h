//
//  GameConfig.h
//  TerisMac
//
//  Created by shgbit on 2020/6/30.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameConfig : NSObject
@property (nonatomic, assign) float speedTime;
-(void)writeConfig;
-(void)updateScore;
-(bool)addRemovedLines:(NSInteger)linesCount;
-(bool)addCubesCubesScore:(NSInteger)cubesCount;
-(void)initConfig;
@end

NS_ASSUME_NONNULL_END
