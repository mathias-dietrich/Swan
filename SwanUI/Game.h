//
//  Game.h
//  SwanUI
//
//  Created by Mathias Dietrich on 28.09.20.
//

#ifndef Game_h
#define Game_h

#import <vector>
#import "Types.h"
#import "Global.h"
#import "Board.h"

class Game{
public:
    string event;
    string site;
    string date;
    string round;
    string whitePlayer;
    string blackPlayer;
    string result;
    
    vector<Ply> plies;
};
#endif /* Game_h */
