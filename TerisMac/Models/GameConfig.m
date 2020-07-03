//
//  GameConfig.m
//  TerisMac
//
//  Created by shgbit on 2020/6/30.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "GameConfig.h"
#define LEVEL_SCORE  100
#define LINE_SCORE   10
#define CUBE_SCORE   1

@interface GameConfig()
@property (nonatomic, assign) NSInteger highestScore;
@property (nonatomic, assign) NSInteger curScore;
@property (nonatomic, assign) NSInteger removeLines;
@property (nonatomic, assign) NSInteger speed;
@end

@implementation GameConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self readConfig];
    }
    return self;
}

- (float)speedTime{
    return 0.5 / self.speed;
}

-(void)initConfig{
    self.curScore = 0;
    self.speed = 1;
    self.removeLines = 0;
}

- (bool)checkSpeed {
    NSInteger speed = self.curScore / LEVEL_SCORE + 1;
    if(speed != self.speed){
        if(speed <= 5){
            self.speed = speed;
            return true;
        }
    }
    return false;
}

-(bool)addRemovedLines:(NSInteger)linesCount{
    if(linesCount == 0) return false;
    self.removeLines += linesCount;
    self.curScore += linesCount * LINE_SCORE;
    return [self checkSpeed];
}

-(bool)addCubesCubesScore:(NSInteger)cubesCount{
    self.curScore += cubesCount * CUBE_SCORE;
    return [self checkSpeed];
}

- (void)updateScore{
    if(self.highestScore < self.curScore){
    self.highestScore = self.curScore;
    }
}

-(void)readConfig{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile: [self userlistPath]];
    if(!dic){
        _highestScore = 0;
    }else{
        _highestScore = [dic[@"highestScore"] integerValue];
    }
}

-(void)writeConfig{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue: @(_highestScore) forKey:@"highestScore"];
    [dic writeToFile:[self userlistPath] atomically:YES];
}

- (NSString *)userlistPath {
    NSString *filePath = [[self defaultGameConfigDirectory] stringByAppendingPathComponent:@"GameConfig.plist"];
    NSLog(@"FilePath: %@", filePath);
    return filePath;
}

- (NSString *)defaultGameConfigDirectory {
    NSString *appName = [[NSProcessInfo processInfo] processName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    NSString *userListDirectory = [[basePath stringByAppendingPathComponent:appName] stringByAppendingPathComponent:@"Game"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:userListDirectory]) {
        return userListDirectory;
        
    }else {
        BOOL success = [fileManager createDirectoryAtPath:userListDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            return userListDirectory;
        }else {
            NSLog(@"用户列表路径创建失败");
            return nil;
        }
    }
}


@end
