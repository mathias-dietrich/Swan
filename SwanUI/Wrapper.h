//
//  Wrapper.m
//  SwanUI
//
//  Created by Mathias Dietrich on 25.09.20.
//

#ifndef HEADERFILE_H
#define HEADERFILE_H

#import <Foundation/Foundation.h>


@interface Wrapper : NSObject

@end

typedef struct
{
int moves[64];
int board[64];
} movearray;

@interface Wrapper ()
- (NSString *)getHelloString;
- (movearray)getMoves:(int) pos board: (int []) board;
@end

#endif
