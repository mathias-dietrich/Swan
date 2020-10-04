//
//  Wrapper.m
//  SwanUI
//
//  Created by Mathias Dietrich on 25.09.20.
//

#import "Wrapper.h"
#include "EngineWrapper.h"
#include "VEngine.h"

@interface Wrapper ()

@end

@implementation Wrapper

EngineWrapper engine0;
EngineWrapper engine1;
VEngine vEngine;

void listen(string msg){
    cout << msg << endl;
}

- (void)getLegalMoves :(string) fen{
    vEngine.getLegalMoves(fen);
}

- (void)findMove0:(string) fen{
    engine0.findMove(fen);
}
- (void)findMove1:(string) fen{
    engine1.findMove(fen);
}

- (void)initEngine0:(string) path{
    engine0.close();
    engine0.init(path);
}
- (void)initEngine1:(string) path{
    engine1.close();
    engine1.init(path);
}

- (void)initWrapper{
    listener = ( Listener*)CFBridgingRetain(self);
    vEngine.init("/Users/mdietric/Swan/engines/stockfish");
}

- (void)close{
    engine0.close();
    engine1.close();
    vEngine.close();
}

@end
