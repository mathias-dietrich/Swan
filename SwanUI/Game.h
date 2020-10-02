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
    string event = "[Event New Match]";
    string site = "[Site Mat’s home]";
    string date = "[Date " + CurrentDate() + " ]";
    string round = "[Round 1]";
    string whitePlayer = "[White Mathias Dietrich]";
    string blackPlayer = "[Black Swan]";
    string result = "";
    
    vector<Ply> plies;
    
    string getDesccription(){
        string sum = event + "\n";
        sum += site + "\n";
        sum += date + "\n";
        sum += round + "\n";
        sum += whitePlayer + "\n";
        sum += blackPlayer + "\n";
        sum += result + "\n";
        int pos = 1;
        bool flip = true;
        for (unsigned int i=0; i<plies.size(); i++) {
            if(flip){
                sum += to_string(pos) + ".";
                ++pos;
            }
            flip = !flip;
            sum += plies[i].strDisplay + " ";
        }
        return sum;
    }
    
    string CurrentDate()
    {
        std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        char buf[100] = {0};
        std::strftime(buf, sizeof(buf), "%Y-%m-%d", std::localtime(&now));
        return buf;
    }
};

#endif /* Game_h */
