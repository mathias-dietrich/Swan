//
//  Log.h
//  Swan
//
//  Created by Mathias Dietrich on 20.09.20.
//

#ifndef Log_h
#define Log_h

#include <iostream>
#include <fstream>

#include<math.h>

#include "Types.h"
#include "Board.h"

using namespace std;

class Log{
public:
    
    const string pretty(TBitBoard b) {
      std::string s = "+---+---+---+---+---+---+---+---+\n";
      for (Rank r = RANK_8; r >= RANK_1; --r)
      {
          for (File f = FILE_A; f <= FILE_H; ++f){
              int64 sq = make_square(f, r);
              sq = (1L << sq);
              s += b & sq ? "| X " : "|   ";
          }
          s += "|\n+---+---+---+---+---+---+---+---+\n";
      }
      return s;
    }
    
    void logBitBoard(TBitBoard  board){
        myfile << pretty(board);
    }
    
    void showBitBoard(TBitBoard  board){
        cout << pretty(board);
    }

    void logBoard(TBoard * board){
        myfile << "  A B C D E F G H" << endl;
        for(int i=8; i>0; --i){
            myfile  << i;
            myfile  << " ";
            for(int x=0; x<8; ++x){
                Square sq = (Square) (((i-1) * 8) + x);
                switch(board->squares[sq]){
                    case B_PAWN:
                        myfile  << "p ";
                        break;
                        
                    case W_PAWN:
                        myfile  << "P ";
                        break;
                        
                    case B_ROOK:
                        myfile  << "r ";
                        break;
                        
                    case W_ROOK:
                        myfile  << "R ";
                        break;
                        
                    case B_KNIGHT:
                        myfile  << "n ";
                        break;
                        
                    case W_KNIGHT:
                        myfile  << "N ";
                        break;
                        
                    case B_BISHOP:
                        myfile  << "b ";
                        break;
                        
                    case W_BISHOP:
                        myfile  << "B ";
                        break;
                        
                    case B_QUEEN:
                        myfile  << "q ";
                        break;
                        
                    case W_QUEEN:
                        myfile  << "Q ";
                        break;
                        
                    case B_KING:
                        myfile  << "K ";
                        break;
                        
                    case W_KING:
                        myfile  << "K ";
                        break;
                        
                    default:
                        myfile  << "  ";
                        break;
                }
            }
            myfile  << i << endl;
        }
        myfile << "  A B C D E F G H" << endl;
    }
    
    void log(string txt){
        myfile << "OUT: " << txt << endl;
    }
    
   static Log& of()
   {
       static Log   instance; // Guaranteed to be destroyed.
       return instance;
   }
    
private:
    Log() {}                    // Constructor? (the {} brackets) are needed here.
    Log(Log const&);              // Don't Implement
    void operator=(Log const&); // Don't implement
};
#endif /* Log_h */
