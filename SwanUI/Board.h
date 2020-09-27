//
//  Board.h
//  Swan
//
//  Created by Mathias Dietrich on 20.09.20.
//

#pragma once

#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

#include "Types.h"
#include "Global.h"

using namespace std;

/*******************************************************************
  Holds the piece location status of the board in BitBoards per Piece
 *******************************************************************/
struct TBoardBB
{
    // Holds the piece information per square
    EPiece squares[SQ_H8+2];
    
    // Bit Boards for Pieces
    TBitBoard pcs[B_KING+2];
    
    // Utility BitBoards
    TBitBoard emptySquares;
    TBitBoard occupiedSquares;
    TBitBoard pcsOfColor[BLACK+1];
};

struct TBoardState
{
    int64 hash;
    int lastTriggerEvent;// ply whith pawn move or capture
    int castelingRights;
    bool inCheck;
    int repetitions;
    Square enPassentSquare;
};

/*******************************************************************
 TBoard : a powerfull class that represents the actual board
 this class is responsible for legal move generation and move
 execution
 *******************************************************************/
class TBoard
{
public:
    TBoardBB bb;
    TBoardState state;
    
    Color sideToMove;
    int currentPly;
    
    int b_enPasse =-1;
    int w_enPasse=-1;
    
    bool w_casteS = true;
    bool w_casteL= true;
    bool b_casteS= true;
    bool b_casteL= true;
    
    int rule50 = 0;
    int halfmove =0;

    TBoard(){
        
    }
    
    ~TBoard(){
        
    }
    
    void move(string move){
        Square from = getPosFromStr(move.substr(0,2));
        Square to = getPosFromStr(move.substr(2,2));
        bb.squares[to] =  bb.squares[from];
        bb.squares[from] = EMPTY;
    }
    
    void print(){
        myfile << "  A B C D E F G H" << endl;
        for(int i=8; i>0; --i){
            myfile  << i;
            myfile  << " ";
            for(int x=0; x<8; ++x){
                Square sq = (Square) (((i-1) * 8) + x);
                switch(bb.squares[sq]){
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
    
    string getFen(TBoard * board){
           string fen = "";
           int count = 0;
           
           for(int y=7; y>-1; y--){
               for(int x=0; x < 8; x++){
                   
                   int field = board->bb.squares[x  + y * 8];
                   
                   if(field!=0 && count >0){
                       fen += std::to_string(count);
                       count = 0;
                   }
                   
                   switch(field){
                           
                       case W_PAWN:
                           fen += "P";
                           break;
                           
                       case W_ROOK:
                           fen += "R";
                           break;
                           
                       case W_KNIGHT:
                           fen += "N";
                           break;
                           
                       case W_BISHOP:
                           fen += "B";
                           break;
                           
                       case W_QUEEN:
                           fen += "Q";
                           break;
                           
                       case W_KING:
                           fen += "K";
                           break;
                           
                       case B_PAWN:
                           fen += "p";
                           break;
                           
                       case B_ROOK:
                           fen += "r";
                           break;
                           
                       case B_KNIGHT:
                           fen += "n";
                           break;
                           
                       case B_BISHOP:
                           fen += "b";
                           break;
                           
                       case B_QUEEN:
                           fen += "q";
                           break;
                           
                       case B_KING:
                           fen += "k";
                           break;
                           
                       case 0:
                           count++;
                           break;
                   }
               }
               if(y>-1 && count >0){
                   fen += std::to_string(count);
                   count = 0;
               }
               if(y>0){
                   fen += "/";
               }
           }
           fen += " ";
        if(board->sideToMove == WHITE){
               fen += "w";
           }else{
               fen += "b";
           }
           fen += " ";
        
           if(!board->w_casteS  && !board->w_casteS && !board->b_casteS && !board->b_casteL){
               fen += "-";
           }
           if(board->w_casteS){
               fen += "K";
           }
           if(board->w_casteL){
               fen += "Q";
           }
           if(board->b_casteS){
               fen += "k";
           }
           if(board->b_casteL){
               fen += "q";
           }
           
           fen += " ";
           string temp("abcdefgh");
           stringstream ss;
           
           if(board->w_enPasse > 0){
               int r = (board->w_enPasse - 8) % 8;
               ss << temp.at(r) << "3";
               fen += ss.str();
           }else if(board->b_enPasse > 0){
               int r = (board->b_enPasse + 8) % 8;
               ss << temp.at(r) << "6";
               fen += ss.str();
           }else{
               fen += "-";
           }
           fen += " ";
           fen += std::to_string(board->rule50);
           fen += " ";
           fen += std::to_string(board->halfmove);
           return fen;
       }
    
    int setFEN(string aFEN)
    {
        unsigned int i,j;
        int sq;
        char letter;
        int aRank,aFile;

        std::stringstream ss(aFEN);
        std::istream_iterator<std::string> begin(ss);
        std::istream_iterator<std::string> end;
        std::vector<std::string> strList(begin, end);
 
        // Empty the board quares
        for (sq=SQ_A1;sq <= SQ_H8;sq++) bb.squares[sq] = EMPTY;
        // read the board - translate each loop idx into a square
        j = 1; i = 0;
        while ((j<=64) && (i<=strList[0].length()))
        {
            letter = strList[0].at(i);
            i++;
            aFile = 1+((j-1) % 8);
            aRank = 8-((j-1) / 8);
            sq = (Square) (((aRank-1)*8) + (aFile - 1));
            switch (letter)
            {
                case 'p' : bb.squares[sq] = B_PAWN; break;
                case 'r' : bb.squares[sq] = B_ROOK; break;
                case 'n' : bb.squares[sq] = B_KNIGHT; break;
                case 'b' : bb.squares[sq] = B_BISHOP; break;
                case 'q' : bb.squares[sq] = B_QUEEN; break;
                case 'k' : bb.squares[sq] = B_KING; break;
                case 'P' : bb.squares[sq] = W_PAWN; break;
                case 'R' : bb.squares[sq] = W_ROOK; break;
                case 'N' : bb.squares[sq] = W_KNIGHT; break;
                case 'B' : bb.squares[sq] = W_BISHOP; break;
                case 'Q' : bb.squares[sq] = W_QUEEN; break;
                case 'K' : bb.squares[sq] = W_KING; break;
                case '/' : j--; break;
                case '1' : break;
                case '2' : j++; break;
                case '3' : j+=2; break;
                case '4' : j+=3; break;
                case '5' : j+=4; break;
                case '6' : j+=5; break;
                case '7' : j+=6; break;
                case '8' : j+=7; break;
                default: return -1;
            }
            j++;
        }
        string color = strList[1];
        if (color == "w"){
            sideToMove = WHITE;
        }else{
            sideToMove = BLACK;
        }
        
        // TODO
        string castling = strList[2];
        string enPasse = strList[3];
        if(enPasse != "-"){
            state.enPassentSquare = (Square)std::stoi(enPasse);
        }
       
        string halfMove = strList[4];
        string fullMove = strList[5];
        
        return 0;
    }
        
private:

};

