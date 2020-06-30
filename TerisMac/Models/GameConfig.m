//
//  GameConfig.m
//  TerisMac
//
//  Created by shgbit on 2020/6/30.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "GameConfig.h"

@implementation GameConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self readConfig];
    }
    return self;
}

-(void)readConfig{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile: [self userlistPath]];
    if(!dic){
        _highestScore = @"0";
    }else{
        _highestScore = dic[@"highestScore"];
    }
}

-(void)writeConfig{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_highestScore forKey:@"highestScore"];
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
