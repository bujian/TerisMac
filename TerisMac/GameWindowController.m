//
//  GameWindowController.m
//  SecondPro
//
//  Created by shgbit on 2020/6/24.
//  Copyright © 2020年 shgbit. All rights reserved.
//

//#define BjImage(name)   [NSImage imageNamed:name];


#import "GameWindowController.h"
#import "Container.h"
#import "CubeSet.h"
#import "CubeSetFactory.h"
#import "GameConfig.h"

@interface GameWindowController ()
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) Container* container;
@property (nonatomic, strong) CubeSet* curCubeSet;
@property (nonatomic, strong) CubeSetFactory* cubeSetFactory;
@property (nonatomic, assign) GameState gameState;
@property (nonatomic, strong) GameConfig* gameConfig;

@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSImageView *next1Panel;
@property (weak) IBOutlet NSImageView *next2Panel;
@property (weak) IBOutlet NSImageView *next3Panel;
@property (strong) IBOutlet NSObjectController *objectController;

@end

@implementation GameWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
//    NSLog(@"game controller loaded");
    _container = [[Container alloc] initWithView:_containerView];
    _cubeSetFactory = [[CubeSetFactory alloc] init];
    self.gameState = GameState_Stop;
    [self loadConfig];
//    self.aa = @ "asdfasdf";
//    NSArray *array = @[@(1), @(5), @(3), @(7)];
//    NSLog(@"%d", [[array valueForKeyPath:@"@min.intValue"] intValue]);
//    [self addObserver:self forKeyPath:@"curScoreLabel.intValue" options:NSKeyValueObservingOptionNew context:nil];
//    self.curScoreLabel.intValue = 1000;
    }

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"key cahnged");
}

-(void)loadConfig{
    self.gameConfig = [[GameConfig alloc]init];
//    _highestScoreLabel.stringValue = _gameConfig.highestScore;
}

-(void)saveConfig{
//    _gameConfig.highestScore = _highestScoreLabel.stringValue;
    [self.gameConfig writeConfig];
}

-(void)startGame{
    [_container clearContainer];
    [self.gameConfig initConfig];
    [self createNewCube];
    self.gameState = GameState_Start;
    [self startTimer];
}

-(void)gameOver{
    NSLog(@"Game Over");
    [_container disableContainer];
    [_timer invalidate];
    self.gameState = GameState_Stop;
    [self.gameConfig updateScore];
}

-(void)startTimer{
    float time = self.gameConfig.speedTime;
    _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerEvent) userInfo:nil repeats:true];
}

-(void)restartTimer{
    [self stopTimer];
    [self startTimer];
}

-(void)stopTimer{
    [_timer invalidate];
}

-(void)timerEvent{
    [self cubeMoveDown];
}

-(void)createNewCube{
    _curCubeSet = [_cubeSetFactory getCubeSet];
    NSRect rect = [_container getStartRect];
    Vector2* size = _container.size;
    Vector2* originPos = [[Vector2 alloc] initWith:size.x / 2 and:size.y];
    NSView *view = [_curCubeSet createCubeSetViewWithCubeRect:rect OriginPos:originPos];
    
    [_containerView addSubview:view];
    [self updatePreDataPanel];
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
    bool cubeSpeedChanged = [self.gameConfig addCubesCubesScore:cubeSetView.subviews.count];
    NSArray* lines = [_container addCube: cubeSetView];
    [cubeSetView removeFromSuperview];
    NSInteger removeLinesCount = [_container checkLinesNeededToRemove:lines];
    bool linesSpeedChanged = [self.gameConfig addRemovedLines:removeLinesCount];
    bool overMap = [_container checkLinesOverContainer];
    if(overMap) [self gameOver];
    else {
        [self createNewCube];
        if(cubeSpeedChanged || linesSpeedChanged) [self restartTimer];
    }
    
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

- (IBAction)buttonAction:(NSButton *)sender {
    NSLog(@"点击按钮");
    switch (self.gameState) {
        case GameState_Start:
            self.gameState = GameState_Pause;
            [self stopTimer];
            break;
        case GameState_Pause:{
            self.gameState = GameState_Start;
            [self startTimer];
        }
            break;
        case GameState_Stop:{
            self.gameState = GameState_Start;
            [self startGame];
        }
            break;
        default:
            break;
    }

}

- (void)setGameState:(GameState)gameState{
    if(gameState == GameState_Start){
        _startButton.image = [NSImage imageNamed:@"pause"];
    }
    else{
        _startButton.image = [NSImage imageNamed:@"play"];
    }
    _gameState = gameState;
}

- (void)removeAllSubeViews:(NSView *)panel {
    for (NSView* view in panel.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"NSImageViewContainerView"]) continue;
        [view removeFromSuperview];
    }
}

-(void)updatePreDataPanel{
    NSArray* cubeSets = [_cubeSetFactory getPreData];
    NSArray* panels = [[NSArray alloc] initWithObjects:_next1Panel,_next2Panel,_next3Panel, nil];
    for (int i = 0; i < panels.count; i++) {
        NSImageView* panel = panels[i];
        [self removeAllSubeViews:panel];
        
        CubeSet* set = cubeSets[i];
        CGSize imageViewRect = panel.frame.size;
        CGSize cubeViewSize = NSMakeSize(imageViewRect.width / 2, imageViewRect.height / 2);
        CGPoint imageViewCenterPoint = NSMakePoint(cubeViewSize.width, cubeViewSize.height);
        CGPoint cubeViewPos = NSMakePoint(imageViewCenterPoint.x - cubeViewSize.width / 2,  imageViewCenterPoint.y - cubeViewSize.height / 2);
        NSView* setView = [set createCubeSetViewWithViewRect:NSMakeRect(cubeViewPos.x, cubeViewPos.y, cubeViewSize.width, cubeViewSize.height)];
        [panel addSubview:setView];
    }
}


- (void)windowWillClose:(NSNotification *)notification{
    [self saveConfig];
    NSLog(@"窗口要关掉了");
}

@end
