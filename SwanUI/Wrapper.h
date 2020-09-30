//
//  Wrapper.m
//  SwanUI
//
//  Created by Mathias Dietrich on 25.09.20.
//

#ifndef HEADERFILE_H
#define HEADERFILE_H

#import <Foundation/Foundation.h>
#import "Types.h"
#import "Global.h"

@protocol Listener <NSObject>

@end


typedef struct{
    int moves[64];
    int board[64];
} movearray;

@interface Wrapper : NSObject<Listener>


void listen(string msg);
- (void)findMove :(string) fen;
- (void)initWrapper;
- (void)close;
- (NSString *)getHelloString;
- (movearray)getMoves:(int) pos board: (int []) board;
- (void)getLegalMoves :(string) fen;

@end

#endif
