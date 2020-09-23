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

#include "Types.h"
#include "Board.h"
#include "Global.h"
#include "Log.h"

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
    
    void test(){
        TBoard *b = new TBoard();
        b->setFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
        b->bb.occupiedSquares = 3;
        TBitBoard s = b->bb.occupiedSquares;
        Log::of().showBitBoard(s);
    }
    
    void go( TBoard *board){
        this->board = board;
        isRunning = true;
        currentThread = std::thread(std::bind(&Engine::run, this));
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
            if(isRunning){
                sleep(0.1);
            }
            string move = "e7e5";
            
            Bmagic(0, board->bb.occupiedSquares);
            TBitBoard s = board->bb.occupiedSquares;
            Log::of().logBitBoard(s);
            
            reply("bestmove " + move);
            isRunning = false;
        }
    }
    
private:
    std::thread currentThread;
    static Engine * instance;
    int timeWhite;
    int timeBlack;
    int movesToGo;
    bool isRunning;
    TBoard *board;
    
    void reply(string cmd){
        myfile << "OUT: " << cmd << endl;
        std::cout  << cmd << "\n" << std::endl;
    }
};

