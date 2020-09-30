//
//  AppDelegate.m
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (IBAction)start:(id)sender{
    NSLog(@"start in!");
}

- (IBAction)flip:(id)sender{
    NSLog(@"flip in!");
    [field flip];
}

- (BOOL)windowWillClose:(id)sender{
    return YES;
}

- (BOOL)windowShouldClose:(id)sender {
    [NSApp hide:nil];
    return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [field setup];
    NSLog(@">applicationDidFinishLaunching");
}


- (void)applicationWillTerminate:(NSNotification *)notification{
    NSLog(@"applicationWillTerminate");
}

@end
