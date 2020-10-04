//
//  VEngine.h
//  SwanUI
//
//  Created by Mathias Dietrich on 04.10.20.
//

#ifndef VEngine_h
#define VEngine_h

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

class VEngine{
public:

    static void* staticFunctionv(void* p)
     {
         static_cast<VEngine*>(p)->runListener();
         return NULL;
     }
    
    void getLegalMoves(string fen){
        legalMoves = "";
        toEngine("position fen " + fen + "\n");
        toEngine("go perft 1\n");
    }

    void runListener(){
        toEngine("uci\n");
        toEngine("isready\n");
        toEngine("ucinewgame\n");
        while(isPRunningv){
          char buf[500];
          int n;
          while ( (n = read(aStdoutPipev[PIPE_READ], &buf, 500)) !=-1)  {
              std::string reply(buf, n);
              std::stringstream ss(reply);
              std::string to;
              while(std::getline(ss,to,'\n')){
                  if (to.rfind("Nodes searched", 0) == 0){
                      NSString *v = [NSString stringWithCString:legalMoves.c_str() encoding:[NSString defaultCStringEncoding]];
                      NSDictionary * userInfo = @{ @"move" : v};
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"vengine" object:nil  userInfo:userInfo];
                      continue;
                  }
                  legalMoves+= to.substr(0,4) + ",";
                  continue;
              }
          }
       }
   }
    
    int nChildv;
    char nCharv;
    int nResultv;
    bp::opstream instreamv;
    bp::ipstream outstreamv;

    const int sizebuf = 1234;
    bool isOpenv = false;

    int createChild(const char* szCommand) {
        if (pipe(aStdinPipev) < 0) {
            perror("allocating pipe for child input redirect");
            return -1;
        }
        if (pipe(aStdoutPipev) < 0) {
            perror("allocating pipe for child output redirect");
            return -1;
        }
        char env[] = "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES";
        putenv(env);
        nChildv = fork();
        if (0 == nChildv) {
            // child continues here
            
            cout << "PIPES ARE CREATED==============" << endl;
            
            // redirect stdin
            if (dup2(aStdinPipev[PIPE_READ], STDIN_FILENO) == -1) {
                perror("redirecting stdin");
                cout << "PIPES error 1"   << endl;
                return -1;
            }
            
            // redirect stdout
            if (dup2(aStdoutPipev[PIPE_WRITE], STDOUT_FILENO) == -1) {
                perror("redirecting stdout");
                cout << "PIPES error 2"   << endl;
                return -1;
            }
            
            // redirect stderr
            if (dup2(aStdoutPipev[PIPE_WRITE], STDERR_FILENO) == -1) {
                perror("redirecting stderr");
                cout << "PIPES error 3"   << endl;
                return -1;
            }

            char * const command[] = {"", NULL};
            char * const env[] = {"", NULL};
            
           // "OBJC_DISABLE_INITIALIZE_FORK_SAFETY"
           // environ
            nResultv = execve(szCommand, command, env);
            
            cout << "PIPES error 4"   << endl;
            // if we get here at all, an error occurred, but we are in the child
            // process, so just exit
            perror("exec of the child process");
            exit(nResultv);
            
        } else if (nChildv > 0) {

        } else {
            cout << "PIPES error 5"   << endl;
        }
        return nChildv;
    }
    
    void toEngine(string msg) {
        const char * c = msg.c_str();
        write(aStdinPipev[PIPE_WRITE],c , strlen(c));
    }

    void init(string enginePath){
        isPRunningv = true;
        createChild(enginePath.c_str());
        pthread_create(&thread, NULL,  staticFunctionv, this);
    }
    
    void close(){
        if(isPRunningv){
            toEngine("quit\n");
            isPRunningv = false;
            pclose(fpv);
        }
    }
    
private:
    pthread_t thread;
    FILE *  fpv;
    bool isPRunningv = true;
    int aStdinPipev[2];
    int aStdoutPipev[2];
    string legalMoves;
};

#endif /* VEngine_h */
