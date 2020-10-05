//
//  PythonWrapper.h
//  SwanUI
//
//  Created by Mathias Dietrich on 27.09.20.
// https://github.com/mathias-dietrich/blackbird/blob/master/Blackbird/Blackbird/engine/EngineWrapper.hpp

#ifndef PythonWrapper_h
#define PythonWrapper_h

#include <vector>
#include <string>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <fstream>
#include<unistd.h>

#include <boost/process.hpp>
#include <boost/filesystem.hpp>
#include <boost/asio.hpp>

#define PIPE_READ 0
#define PIPE_WRITE 1

namespace bp = ::boost::process;
using namespace std;

class EngineWrapper{
public:
    
    static void* staticFunction(void* p)
     {
         static_cast<EngineWrapper*>(p)->runListener();
         return NULL;
     }
    
    void findMove(string fen){
        toEngine("position fen " + fen + "\n");
        toEngine("go movetime 2000\n");
    }
    
    void runListener(){
        toEngine("uci\n");
        toEngine("isready\n");
        toEngine("ucinewgame\n");
       while(isPRunning){
          char buf[500];
          int n;
          while ( (n = read(aStdoutPipe[PIPE_READ], &buf, 500)) !=-1)  {
              std::string reply(buf, n);
              NSString *v = [NSString stringWithCString:reply.c_str() encoding:[NSString defaultCStringEncoding]];
              NSDictionary * userInfo = @{ @"move" : v};
              [[NSNotificationCenter defaultCenter] postNotificationName:@"cmove" object:nil  userInfo:userInfo];
          }
       }
   }
    
    int nChild;
    char nChar;
    int nResult;
    bp::opstream instream;
    bp::ipstream outstream;

    const int sizebuf = 1234;
    bool isOpen = false;

    int createChild(const char* szCommand) {
        if (pipe(aStdinPipe) < 0) {
            perror("allocating pipe for child input redirect");
            return -1;
        }
        if (pipe(aStdoutPipe) < 0) {
            perror("allocating pipe for child output redirect");
            return -1;
        }
        char env[] = "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES";
        putenv(env);
        nChild = fork();
        if (0 == nChild) {
            // child continues here
            
            cout << "PIPES ARE CREATED==============" << endl;
            
            // redirect stdin
            if (dup2(aStdinPipe[PIPE_READ], STDIN_FILENO) == -1) {
                perror("redirecting stdin");
                cout << "PIPES error 1"   << endl;
                return -1;
            }
            
            // redirect stdout
            if (dup2(aStdoutPipe[PIPE_WRITE], STDOUT_FILENO) == -1) {
                perror("redirecting stdout");
                cout << "PIPES error 2"   << endl;
                return -1;
            }
            
            // redirect stderr
            if (dup2(aStdoutPipe[PIPE_WRITE], STDERR_FILENO) == -1) {
                perror("redirecting stderr");
                cout << "PIPES error 3"   << endl;
                return -1;
            }

            char * const command[] = {"", NULL};
            char * const env[] = {"", NULL};
            
           // "OBJC_DISABLE_INITIALIZE_FORK_SAFETY"
           // environ
            nResult = execve(szCommand, command, env);
            
            cout << "PIPES error 4"   << endl;
            // if we get here at all, an error occurred, but we are in the child
            // process, so just exit
            perror("exec of the child process");
            exit(nResult);
            
        } else if (nChild > 0) {

        } else {
            cout << "PIPES error 5"   << endl;
        }
        return nChild;
    }
    
    void toEngine(string msg) {
        const char * c = msg.c_str();
        write(aStdinPipe[PIPE_WRITE],c , strlen(c));
    }

    void init(string enginepath){
        isPRunning = true;
        createChild(enginepath.c_str());
        pthread_create(&thread, NULL,  staticFunction, this);
    }
    
    void close(){
        if(isPRunning){
            toEngine("quit\n");
            isPRunning = false;
            pclose(fp);
        }
    }
    
private:
    FILE *  fp;
    bool isPRunning = true;
    int aStdinPipe[2];
    int aStdoutPipe[2];
    string legalMoves;
    pthread_t thread;
};

#endif /* PythonWrapper_h */
