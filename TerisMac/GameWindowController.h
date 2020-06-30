//
//  GameWindowController.h
//  SecondPro
//
//  Created by shgbit on 2020/6/24.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum : NSUInteger {
    GameState_Start,
    GameState_Pause,
    GameState_Stop,
} GameState;

@interface GameWindowController : NSWindowController

@end

