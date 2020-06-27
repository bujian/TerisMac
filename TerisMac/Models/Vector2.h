//
//  Vector2.h
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Vector2 : NSObject
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, copy) NSString* imagePath;

-(Vector2*)add:(Vector2*) vec;
- (instancetype)initWith:(NSInteger)x and: (NSInteger)y;
@end

NS_ASSUME_NONNULL_END
