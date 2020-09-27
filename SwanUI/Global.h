//
//  Global.hpp
//  Swan
//
//  Created by Mathias Dietrich on 21.09.20.
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
#include<fstream>


using namespace std;

extern ofstream myfile;

class Listener{
public:
    virtual void listen(string msg) = 0;
};

extern Listener * listener;



