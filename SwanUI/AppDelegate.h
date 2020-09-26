//
//  AppDelegate.h
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import <Cocoa/Cocoa.h>

#import "Field.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet Field * field;
    IBOutlet NSButton * btnStart;
    IBOutlet NSButton * btnFlip;
}

- (IBAction)start:(id)sender;
- (IBAction)flip:(id)sender;
@end

