//
//  Thread.hpp
//  Swan
//
//  Created by Mathias Dietrich on 24.09.20.
// https://stackoverflow.com/questions/15752659/thread-pooling-in-c11

#ifndef Thread_hpp
#define Thread_hpp

#include <stdio.h>
#include <iostream>
#include <cstdlib>

#include<thread>
#include <ctype.h>

#include "Types.h"
#include "Board.h"
#include "Global.h"

using namespace std;

struct Job{
    
};

extern bool isPoolRunning;

inline void run(int pos){
    while(isPoolRunning){
        std::cout << "Thread ID : " << pos << endl;
    }
}

class Worker{
public:
    int pos;
    std::thread *th = nullptr;

    void init(){
        if(th == nullptr)
            {
                th = new thread(run, pos); //Create the thread and store its reference
            }
    }
    
    void close(){
        th->join();
    }
};

class ThreadPool{
public:
    void run(int pos);
    
    void init(){
        isPoolRunning = true;
        threadCount =  thread::hardware_concurrency();
        cout << "Threads Available: " << threadCount << endl;
        
        for(int ii = 0; ii < threadCount; ii++){
            Worker * w = new Worker();
            w->pos = ii;
            w->init();
            Pool.push_back(w);
        }
    }

    
    void close(){
        isPoolRunning = false;
        for(int ii = 0; ii < threadCount; ii++){
            Pool[ii]->close();
        }
         Pool.clear();
    }
    
private:
    
    vector<Worker*> Pool;
    int threadCount;

};
#endif /* Thread_hpp */
