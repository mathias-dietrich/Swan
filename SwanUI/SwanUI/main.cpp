//
//  main.cpp
//  Swan
//
//  Created by Mathias Dietrich on 20.09.20.
// http://wbec-ridderkerk.nl/html/UCIProtocol.html
//
//

#include <iostream>
#include <fstream>

#include "Types.h"
#include "Board.h"
#include "Engine.h"
#include "Global.h"

using namespace std;

enum InputState{
    BTIME,
    WTIME,
    GO,
    STOP,
    NEWGAME,
    POSITION,
    MOVES,
    READY,
    MOVESTOGO,
    NONE
};


InputState state = NONE;

void reply(string cmd){
    myfile << "OUT: " << cmd << endl;
    std::cout  << cmd << "\n" << std::endl;
}

int main(int argc, char* argv[])
{
    string startfen ="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
    myfile.open ("Swan.log");
    myfile << "Starting Swan log\n";
    reply("Swan 1 by the Swan developers (see AUTHOR file)");

    // TODO Command line parser
    if (argc >1) {
 
    }

    // UCI Parser
    Engine *engine = new Engine();
    bool isRunning = true;
    string line = "ok";
    TBoard *board = new TBoard();
    while(isRunning){
        cin >> line;
        myfile << "IN: ";
        myfile << line << endl;
        if(state == MOVES){
            if(line == "go"){
                engine->go(board);
                state = READY;
                continue;
            }
            
            // TODO move the board
            myfile << "making move: " << line << endl;
            board->move(line);
            Log::of().logBoard(board);
            continue;
        }
        
        if(state == MOVESTOGO){
            int count = std::stoi(line);
            engine->setMovesToGo(count);
            continue;
        }
        if(state == POSITION){
            if(line == "fen"){
                board->setFEN(startfen);
                board->print();
                state = READY;
                continue;
            }
            if(line == "startpos"){
                board->setFEN(startfen);
                board->print();
                continue;
            }
            if(line == "moves"){
                state = MOVES;
                continue;
            }
        }
        
        if(line == "uci"){
            reply("id name Swan 1.0");
            reply("id author Mathias Dietrich");
            reply("uciok");
            continue;
        }
        if(line == "isready"){
            reply("readyok");
            state = READY;
            continue;
        }
        if(line == "quit"){
            engine->quit();
            isRunning = false;
        }
        if(line == "stop"){
            state = STOP;
            engine->stop();
            continue;
        }
        if(line == "ucinewgame"){
            state = NEWGAME;
            engine->newGame();
            
            board->setFEN(startfen);
            board->print();
            state = READY;
            continue;
        }
        
        if(line == "position"){
            state = POSITION;
            continue;
        }
        
        if(line == "moves"){
            state = MOVES;
            continue;
        }
        
        if(line == "wtime"){
            cin >> line;
            myfile << "IN: " + line;
            int time = std::stoi(line);
            engine->setTimeWhite(time);
            continue;
        }
        
        if(line == "btime"){
            cin >> line;
            myfile << "IN: " + line;
            int time = std::stoi(line);
            engine->setTimeBlack(time);
            continue;
        }

        if(line == "go"){
            state = GO;
            engine->go(board);
            continue;
        }
        
        if(line == "movestogo"){
            cin >> line;
            myfile << "IN: " + line;
            int count = std::stoi(line);
            engine->setMovesToGo(count);
            continue;
        }
        
        if(line == "test"){
            engine->test();
            continue;
        }
        reply("info unknown command " + line);
    }
    
    myfile.close();
    delete board;
   // delete engine;
    return 0;
}


