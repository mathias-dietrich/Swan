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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@">applicationDidFinishLaunching");

    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    NSLog(@">applicationWillTerminate");
}


@end
