//
//  Const.h
//  Swan
//
//  Created by Mathias Dietrich on 20.09.20.
//

#pragma once

#include <ctype.h>

#include "Global.h"

// BitBoard = Int64 (long long)
typedef long long TBitBoard;
typedef long long int64;

enum Color {
    WHITE = 0,
    BLACK = 1,
    NO_COLOR,
    COLOR_NB = 2
};

enum Stage {
    OPENING = 0,
    ENDGAME = 1
};

enum Square {
  SQ_A1, SQ_B1, SQ_C1, SQ_D1, SQ_E1, SQ_F1, SQ_G1, SQ_H1,
  SQ_A2, SQ_B2, SQ_C2, SQ_D2, SQ_E2, SQ_F2, SQ_G2, SQ_H2,
  SQ_A3, SQ_B3, SQ_C3, SQ_D3, SQ_E3, SQ_F3, SQ_G3, SQ_H3,
  SQ_A4, SQ_B4, SQ_C4, SQ_D4, SQ_E4, SQ_F4, SQ_G4, SQ_H4,
  SQ_A5, SQ_B5, SQ_C5, SQ_D5, SQ_E5, SQ_F5, SQ_G5, SQ_H5,
  SQ_A6, SQ_B6, SQ_C6, SQ_D6, SQ_E6, SQ_F6, SQ_G6, SQ_H6,
  SQ_A7, SQ_B7, SQ_C7, SQ_D7, SQ_E7, SQ_F7, SQ_G7, SQ_H7,
  SQ_A8, SQ_B8, SQ_C8, SQ_D8, SQ_E8, SQ_F8, SQ_G8, SQ_H8,
  SQ_NONE,
  SQUARE_NB = 64
};

enum Direction : int {
  NORTH =  8,
  EAST  =  1,
  SOUTH = -NORTH,
  WEST  = -EAST,

  NORTH_EAST = NORTH + EAST,
  SOUTH_EAST = SOUTH + EAST,
  SOUTH_WEST = SOUTH + WEST,
  NORTH_WEST = NORTH + WEST
};

enum Move : int {
  MOVE_NONE,
  MOVE_NULL = 65
};

enum MoveType {
  NORMAL,
  PROMOTION = 1 << 14,
  ENPASSANT = 2 << 14,
  CASTLING  = 3 << 14
};

enum File {
  FILE_A, FILE_B, FILE_C, FILE_D, FILE_E, FILE_F, FILE_G, FILE_H, FILE_NB
};

inline File getFile(char x){
    return (File)(int) (x - 97);
}

enum Rank {
  RANK_1, RANK_2, RANK_3, RANK_4, RANK_5, RANK_6, RANK_7, RANK_8, RANK_NB
};

inline string posFromInt(int pos){
    int rank = pos / 8 + 1;
    int file = pos % 8;
    char c = (char)file +97;
    return c +  to_string(rank);
}


struct Ply{
    int from;
    int to;
    string str;
    string strDisplay;
};

inline Rank getRank(char x){
    return (Rank)(int) (x - 49);
}

inline Square getPosFromStr(string pos){
    int p = (tolower(pos[0]) - 97) + 8 *  (pos[1]-49);
    return (Square)p;
}

inline Square make_square(File f, Rank r) {
  return Square(int(f) | (int(r) << 3));
}


inline Square& operator++(Square& d) { return d = Square(int(d) + 1); }
inline File& operator++(File& i) { return i = File(int(i) + 1); }
inline Rank& operator++(Rank& i) { return i = Rank(int(i) + 1); }
inline Color& operator++(Color& i) { return i = Color(int(i) + 1); }

inline Square& operator--(Square& d) { return d = Square(int(d) - 1); }
inline File& operator--(File& i) { return i = File(int(i) - 1); }
inline Rank& operator--(Rank& i) { return i = Rank(int(i) - 1); }
inline Color& operator--(Color& i) { return i = Color(int(i) - 1); }

inline Rank getRank(const Square s) { return Rank(s >> 3);}
inline File getFile(const Square s) { return File(s & 7);}

inline bool isOnBoard(const File f, const Rank r) { return f<FILE_NB && r<RANK_NB && f>=FILE_A && r>=RANK_1;}


// Piece Identifiers
enum EPiece {EMPTY,W_PAWN,W_KNIGHT,W_BISHOP,W_ROOK,W_QUEEN,W_KING,
B_PAWN,B_KNIGHT,B_BISHOP,B_ROOK,B_QUEEN,B_KING,INVALID};

inline EPiece operator++ (EPiece& piece) { return (EPiece)(piece+1); }
inline EPiece operator++ (EPiece& piece, int) { EPiece old = piece; piece = (EPiece) (piece + 1); return old; };


