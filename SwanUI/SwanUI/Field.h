//
//  Field.h
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import <Cocoa/Cocoa.h>
#import "Wrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface Field : NSView

@end

enum piece {EMPTY,W_PAWN,W_KNIGHT,W_BISHOP,W_ROOK,W_QUEEN,W_KING,B_PAWN,B_KNIGHT,B_BISHOP,B_ROOK,B_QUEEN,B_KING,INVALID};


enum moveStatus {
    NONE,
    WHITE,
    BLACK
};
enum piece pieces[64];
int activeFrom;
int activeTo[64];
int BORDER=20;
int hit;
bool needsInit = true;
bool isSelected;
enum moveStatus nextToMove = WHITE;

Wrapper * wrapper;
NS_ASSUME_NONNULL_END
