//
//  AppDelegate.m
//  SecondPro
//
//  Created by shgbit on 2020/6/19.
//  Copyright © 2020年 shgbit. All rights reserved.
//

#import "AppDelegate.h"
#import "GameWindowController.h"



@interface AppDelegate ()
@property (nonatomic, strong) NSWindow *window;

@property (nonatomic, strong) GameWindowController *gameWc;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    GameWindowController *gameWc = [[GameWindowController alloc] initWithWindowNibName:@"GameWindowController"];
    [gameWc.window center];
    [gameWc.window makeKeyAndOrderFront:nil];
    self.gameWc = gameWc;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}





@end
