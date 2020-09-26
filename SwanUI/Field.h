//
//  Field.h
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import <Cocoa/Cocoa.h>
#import "Wrapper.h"

#ifndef Field_H
#define Field_H

NS_ASSUME_NONNULL_BEGIN

@interface Field : NSView{
   
}

- (void)flip;
- (void)setup;

enum piece {EMPTY,W_PAWN,W_KNIGHT,W_BISHOP,W_ROOK,W_QUEEN,W_KING,B_PAWN,B_KNIGHT,B_BISHOP,B_ROOK,B_QUEEN,B_KING,INVALID};

enum moveStatus {
    NONE,
    WHITE,
    BLACK
};
extern enum piece pieces[64];
extern int activeFrom;
extern int activeTo[64];
extern int BORDER;
extern int hit;
extern bool needsInit;
extern bool isSelected;
extern enum moveStatus nextToMove;
extern Wrapper * wrapper;

extern bool isFliped;

NS_ASSUME_NONNULL_END
@end

#endif
