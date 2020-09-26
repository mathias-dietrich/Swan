//
//  Engine.h
//  Swan
//
//  Created by Mathias Dietrich on 20.09.20.
//
#pragma once

#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif
#include <iostream>
#include <cstdlib>

#include<thread>
#include <ctype.h>

#include "Types.h"
#include "Board.h"
#include "Global.h"
#include "Log.h"
#include "Thread.h"

//main.cpp

extern "C" {
    #include "magicmoves.h"
}


using namespace std;

class Engine{
public:
    
    Engine(){
        instance = this;
        initmagicmoves();
    }
    
    ~Engine(){
        
    }
    
    vector<int> getMoves(int pos, int b[]){
        TBoard board;
        for(int i=0;i<64;i++){
            board.bb.squares[i] = (EPiece)b[i];
        }
        vector<int> moves;
        moves.push_back(20);
        moves.push_back(28);
        return moves;
    }
    
    string getTestString(){
        return "Hello from c+++";
    }
    
    void test(){
        
        ThreadPool t;
        t.init();
        sleep(3);
        t.close();
        
        /*
        TBoard *b = new TBoard();
        b->setFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
        b->bb.occupiedSquares = 3;
        TBitBoard s = b->bb.occupiedSquares;
        cout << getRank('1') << endl;
        cout << getFile('a') << endl;
        cout <<  getPosFromStr("h8") << endl;
        //Log::of().showBitBoard(s);
         */
    }
    
    void go( TBoard *board){
        this->board = board;
        isFindMove = true;
        if(!isRunning ){
            isRunning = true;
            currentThread = std::thread(std::bind(&Engine::run, this));
        }
    }
    
    void newGame(){
       
    }
    
    void quit(){
        isRunning = false;
        sleep(1.1);
    }
    
    void stop(){
        isRunning = false;
        sleep(0.1);
    }
    
    void setTimeWhite(int time){
        timeWhite = time;
    }
    
    void setTimeBlack(int time){
        timeBlack = time;
    }
    
    void setMovesToGo(int count){
        movesToGo = count;
    }

    void run(){
        while(isRunning){
            while(!isFindMove){
                sleep(0.01);
            }
            string move = "";
            switch(counter){
                case 0:
                    move = "e7e5";
                    break;
                    
                case 1:
                    move = "b8c6";
                    break;

                case 2:
                    move = "g7g5";
                    break;

            }
            counter++;
            board->move(move);
            Log::of().logBoard(board);
            reply("bestmove " + move);
            isFindMove = false;
        }
    }
    
private:
    std::thread currentThread;
    static Engine * instance;
    int timeWhite;
    int timeBlack;
    int movesToGo;
    bool isRunning = false;
    bool isFindMove = false;
    TBoard *board;
    
    void reply(string cmd){
        myfile << "OUT: " << cmd << endl;
        std::cout  << cmd << "\n" << std::endl;
    }
    
    int counter = 0;
};

