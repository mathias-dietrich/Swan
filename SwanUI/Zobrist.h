//
//  Zobrist.h
//  SwanUI
//
//  Created by Mathias Dietrich on 04.10.20.
//

#ifndef Zobrist_h
#define Zobrist_h

//
//  Zobrist.hpp
//  Blackbird
//
//  Created by Mathias Dietrich on 6/24/18.
//  Copyright © 2018 Mathias Dietrich. All rights reserved.
// https://wikivisually.com/wiki/Zobrist_hashing
// https://github.com/lemire/zobristhashing


#pragma once

#include <string>
#include <vector>
#include <stdlib.h>

#include "Type.hpp"
#include "pg_key.h"
#include "Board.hpp"
#include "Fen.hpp"

using namespace std;

class Zobrist{
    
public:
    pg_key *key = new pg_key();
    Fen *fenParser  = new Fen();
    
     uint64_t  hash(string fen){
         return key->findHash(fen);
     }
    
    uint64_t  hash(Board * board){
        return key->findHash(fenParser->parse(board));
    }
};

#endif /* Zobrist_h */
