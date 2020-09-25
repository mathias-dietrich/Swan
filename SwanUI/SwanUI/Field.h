//
//  Field.h
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface Field : NSView

@end

enum piece {
    EMPTY = 0, // 0
    W_PAWN = 1, // 0
    W_ROOK = 2, // 0
    W_KNIGHT = 3, // 0
    W_BISHOP = 4, // 0
    W_QUEEN = 5,
    W_KING = 6,
    B_PAWN = 7,
    B_ROOK = 8,
    B_KNIGHT = 9,
    B_BISHOP = 10,
    B_QUEEN = 11,
    B_KING = 12,
};

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

NS_ASSUME_NONNULL_END
