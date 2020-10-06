//
//  Field.h
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#ifndef Field_H
#define Field_H

#include <stdio.h>

#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

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

@interface Field : NSView <NSComboBoxDelegate>{
    
    // Main View
    IBOutlet MainView * mainView;
    IBOutlet NSColorWell * cToMove;
    IBOutlet NSTextField * timeW;
    IBOutlet NSTextField * timeB;
    
    IBOutlet NSComboBox * drpEngine0;
    IBOutlet NSComboBox * drpEngine1;
    
    NSTimer *_timer;
    // the board shown in the UI
    TBoard board;
    
    // the PGN notated game shown in the UI
    Game game;
    
    bool checkKingInChess;
}

-(void)comboBoxSelectionDidChange:(NSNotification *)notification;
-(void) startTimer;
-(void) stopTimer;
- (void)start;
- (void)flip;
- (void)setup;
- (void)close;
- (void)newBoard;
- (void)clearBoard;
- (void)SetWhiteToMove;
- (void)SetBlackToMove;
- (void) receivingVengine:(NSNotification *) notification;

- (void)go;
NS_ASSUME_NONNULL_END
@end

#endif
