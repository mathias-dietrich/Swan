//
//  Field.h
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#ifndef Field_H
#define Field_H

#import <Cocoa/Cocoa.h>
#import <vector>
#import "Wrapper.h"
#import "Types.h"
#import "Global.h"
#import "MainView.h"
#import "Board.h"
#import "Game.h"
#include "pg_key.h"
#include "pg_show.h"
#include "Config.h"

NS_ASSUME_NONNULL_BEGIN

@interface Field : NSView{
    
    // Main View
    IBOutlet MainView * mainView;
    IBOutlet NSColorWell * cToMove;
    IBOutlet NSTextField * timeW;
    IBOutlet NSTextField * timeB;
    NSTimer *_timer;
    // the board shown in the UI
    TBoard board;
    
    // the PGN notated game shown in the UI
    Game game;
}

-(void) startTimer;
- (void)flip;
- (void)setup;
- (void)close;
- (void)newBoard;
- (void)clearBoard;
- (void)SetWhiteToMove;
- (void)SetBlackToMove;

NS_ASSUME_NONNULL_END
@end

#endif
