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
    [self startGame];
}


-(void)startGame{
    [_container clearContainer];
    [self createNewCube];
    [self startTimer];
}

-(void)gameOver{
    NSLog(@"Game Over");
    [_container disableContainer];
    [_timer invalidate];
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerEvent) userInfo:nil repeats:true];
}

-(void)timerEvent{
    [self cubeMoveDown];
}

-(void)createNewCube{
    _curCubeSet = [_cubeSetFactory getCubeSet];
    NSRect rect = [_container getStartRect];
    Vector2* size = _container.size;
    Vector2* originPos = [[Vector2 alloc] initWith:size.x / 2 and:size.y];
    NSView *view = [_curCubeSet createCubeView:rect OriginPos:originPos];
    
    [_containerView addSubview:view];
}

- (void)cubeMoveRight {
    Vector2* offset = [[Vector2 alloc]initWith:1 and:0];
    [self cubeDoMove:offset];
}

- (void)cubeMoveLeft {
    Vector2* offset = [[Vector2 alloc]initWith:-1 and:0];
    [self cubeDoMove:offset];
}

-(bool)cubeDoMove:(Vector2*)offset{
    bool ret = false;
    NSArray* points = [_curCubeSet getPointsAfterMove:offset];
    if([_container canMove:points]){
           [_curCubeSet doMove:offset];
        ret = true;
    }
    return ret;
}


- (void)cubeMoveDown {
    Vector2* offset = [[Vector2 alloc]initWith:0 and:-1];
    if(![self cubeDoMove:offset])
    {
        [self cubeReachedBottom];
    }
}

- (void)cubeSwitchShape {
    NSArray* points = [_curCubeSet getPointsAfterRotate];
    bool ret = [_container canRotate:points];
    if (ret) {
        [_curCubeSet shapeChange];
    }
}

- (void)cubeReachedBottom {
    NSView* cubeSetView = [_curCubeSet releaseCubes];
    NSArray* lines = [_container addCube: cubeSetView];
    [cubeSetView removeFromSuperview];
    [_container checkLinesNeededToRemove:lines];
    bool overMap = [_container checkLinesOverContainer];
    if(overMap) [self gameOver];
    else [self createNewCube];
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
    [self startGame];
}

@end
