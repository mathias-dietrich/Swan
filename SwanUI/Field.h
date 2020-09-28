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
NS_ASSUME_NONNULL_BEGIN

@interface Field : NSView{
    IBOutlet MainView * mainView;
    string lastMove;
    
    // the board shown in the UI
    TBoard board;
    Game game;
}

- (void)flip;
- (void)setup;
- (void)close;
- (void)newBoard;
- (void)clearBoard;

//extern enum EPiece pieces[64];
extern int activeFrom;
extern int activeTo[64];
extern int BORDER;
extern int hit;
extern bool needsInit;
extern bool isSelected;
extern Wrapper * wrapper;
extern bool isFliped;


NS_ASSUME_NONNULL_END
@end

#endif
