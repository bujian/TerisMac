//
//  GameWindowController.m
//  SecondPro
//
//  Created by shgbit on 2020/6/24.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "GameWindowController.h"
#import "Container.h"
#import "CubeSet.h"
#import "CubeSetFactory.h"

@interface GameWindowController ()
@property (weak) IBOutlet NSView *containerView;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) Container* container;
@property (nonatomic, strong) CubeSet* curCubeSet;
@property (nonatomic, strong) CubeSetFactory* cubeSetFactory;
@end

@implementation GameWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
//    NSLog(@"game controller loaded");
    _container = [[Container alloc] initWithView:_containerView];
    _cubeSetFactory = [[CubeSetFactory alloc] init];
    [self createNewCube];
    [self startGame];
}


-(void)startGame{
    [self startTimer];
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerEvent) userInfo:nil repeats:true];
}



-(void)timerEvent{
    
    [self cubeMoveDown];
}

-(void)createNewCube{
    Vec2MutArrays shapes = [_cubeSetFactory getCubeShapes];
    _curCubeSet = [[CubeSet alloc]initWithShapes:shapes Side:4];
    NSRect rect = [_container getStartRect];
    Vector2* size = _container.size;
    Vector2* originPos = [[Vector2 alloc] initWith:size.x / 2 and:size.y];
    NSView *view = [_curCubeSet createCubeView:rect OriginPos:originPos];
    
    view.layer.backgroundColor = [NSColor redColor].CGColor;
    [_containerView addSubview:view];
}

- (void)cubeMoveRight {
    Vector2* offset = [[Vector2 alloc]initWith:1 and:0];
    Vec2Array points = [_curCubeSet getPointsAfterMove:offset];
    bool ret = [_container canMove:points];
    if (ret) {
        [_curCubeSet moveRight];
    }
}

- (void)cubeMoveLeft {
    Vector2* offset = [[Vector2 alloc]initWith:-1 and:0];
    Vec2Array points = [_curCubeSet getPointsAfterMove:offset];
    bool ret = [_container canMove:points];
    if (ret) {
        [_curCubeSet moveLeft];
    }
}


- (void)cubeMoveDown {
    Vector2* offset = [[Vector2 alloc]initWith:0 and:-1];
    Vec2Array points = [_curCubeSet getPointsAfterMove:offset];
    bool ret = [_container canMove:points];
    if (ret) {
        [_curCubeSet moveDown];
    }
    else
    {
        [self cubeReachedBottom];
    }
}

- (void)cubeSwitchShape {
    Vec2Array points = [_curCubeSet nextShape];
    bool ret = [_container canRotate:points];
    if (ret) {
        [_curCubeSet shapeChange];
    }
}

- (void)cubeReachedBottom {
    NSView* cubeSetView = [_curCubeSet releaseCubes];
    NSArray* lines = [_container addCube: cubeSetView];
    [cubeSetView removeFromSuperview];
    if(lines.count > 0)
    {
        [_container CheckLines:lines];
    }
    [self createNewCube];
}

-(void)keyDown:(NSEvent *)event{
    NSLog(@"key : %@", event.characters);
    unichar key = [event.characters characterAtIndex:0];
    
    if(!_curCubeSet) return;
    switch (key) {
        case NSRightArrowFunctionKey:{
            [self cubeMoveRight];
        }
            break;
        case NSLeftArrowFunctionKey:{
            [self cubeMoveLeft];
        }
            break;
        case NSDownArrowFunctionKey:{
            [self cubeMoveDown];
        }
            break;
        case NSUpArrowFunctionKey:{
            [self cubeSwitchShape];
        }
            break;
        case '\r':{
            NSLog(@"回车");
        }
        default:
            break;
    }
}

- (void)mouseDown:(NSEvent *)event{
    NSLog(@"鼠标点击");
}

- (IBAction)buttonAction:(id)sender {
    NSLog(@"点击按钮");
}

@end
