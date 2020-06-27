//
//  GameTimer.m
//  SecondPro
//
//  Created by shgbit on 2020/6/22.
//  Copyright © 2020年 shgbit. All rights reserved.
//
#import "GameTimer.h"
#import "ContainerView.h"

@interface GameTimer()
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation GameTimer
- (instancetype)initWithContainerView:(ContainerView*)view
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)stopTimer{
    [_timer invalidate];
}

-(void)timerEvent{
    
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:true];
}
@end
