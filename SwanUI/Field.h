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


NS_ASSUME_NONNULL_BEGIN

@interface Field : NSView{
   
}

- (void)flip;
- (void)setup;
- (void)close;


extern enum EPiece pieces[64];
extern int activeFrom;
extern int activeTo[64];
extern int BORDER;
extern int hit;
extern bool needsInit;
extern bool isSelected;
extern enum Color nextToMove;
extern Wrapper * wrapper;

extern bool isFliped;

extern vector<Ply> plies;

NS_ASSUME_NONNULL_END
@end

#endif
