//
//  Wrapper.m
//  SwanUI
//
//  Created by Mathias Dietrich on 25.09.20.
//

#import "Wrapper.h"
#include "Engine.h"
@interface Wrapper ()

@end

@implementation Wrapper
Engine engine;

- (NSString *)getHelloString {
    NSString *msg = [NSString stringWithCString:engine.getTestString().c_str() encoding:[NSString defaultCStringEncoding]];
    return msg;
}

- (movearray)getMoves:(int) pos board: (int []) board{
    movearray moves ;
    for(int i =0;i<64;i++){
        moves.moves[i] = -1;
    }
    int i=0;
    vector<int> m = engine.getMoves(pos,board );
    for (int n : m)  {
        moves.moves[i] = n;
        ++i;
    }
    return moves;
}

@end
