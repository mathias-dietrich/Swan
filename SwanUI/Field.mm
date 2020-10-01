//
//  Field.m
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import "Field.h"
#import "Board.h"

@implementation Field

enum EPiece lastSelectedPiece;
Wrapper * wrapper;
pg_key pgkey;
pg_show pgshow;

int activeFrom = -1;
int activeTo[64];
int activePos;
int BORDER =20;
Square hit = SQ_NONE;

bool isSelected = false;
bool isFliped = false;

bool isWhitePromotion;
bool isBlackPromotion;
Ply ply;

bool isClockRunning = false;
bool isSetMode;

int timeWhite = 3000; // 
int timeBlack = 3000;

bool gettingLegalMoves;
bool checkKingInChess;

-(void) start{
    [self stopTimer];
    [self newBoard];
    timeWhite = 3000; //
    timeBlack = 3000;
    [timeW setStringValue: [self getTimeString:timeWhite]];
    [timeB setStringValue: [self getTimeString:timeBlack]];
    [self setNeedsDisplay:YES];
}
    
-(void) startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(_timerFired:) userInfo:nil repeats:YES];
    isClockRunning = true;
}

-(void) stopTimer{
    isClockRunning = false;
    if ([_timer isValid]) {
          [_timer invalidate];
      }
      _timer = nil;
}
- (NSString*) getTimeString:(int)seconds{ // these are 1/10 second
    seconds /= 10;
    int minutes = seconds/60;
    int sec = seconds - (minutes*60);
    NSString *s = [NSString stringWithFormat:@"%d",minutes];
    s = [s stringByAppendingString:@":"];
    s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",sec]];
    return s;
}

- (void)_timerFired:(NSTimer *)timer {
    if(board.sideToMove == WHITE){
        timeWhite--;
        if(timeWhite==0){
            // TODO
        }
    }else{
        timeBlack--;
        if(timeBlack==0){
            // TODO
        }
    }
    [timeW setStringValue: [self getTimeString:timeWhite]];
    [timeB setStringValue: [self getTimeString:timeBlack]];
}

- (void)SetWhiteToMove{
    [cToMove setColor:[NSColor whiteColor]];
}

- (void)SetBlackToMove{
    [cToMove setColor:[NSColor blackColor]];
}

/*
 ====================================================================================
 Make Engine Move
 ====================================================================================
 */
- (void) receivingMethodOnListener:(NSNotification *) notification{
    NSDictionary *dict = [notification userInfo];
    NSString *move = dict[@"move"];
    NSLog(@"Incoming from Engine");
    NSLog(move);
    if([move length] == 0 ){
        return;
    }
    
    // Legal Moves
    if(gettingLegalMoves){
        NSArray *moves = [move componentsSeparatedByString:@","];
        NSEnumerator *e = [moves objectEnumerator];
        NSString * object;
        int movesCountSpecific=0;
        int movesCountAll=0;
        Square kingSq = board.findKingSquare(board.sideToMove);
        bool foundAttacker = false;
        
        while (object = [e nextObject]) {
            if(object.length == 0){
                continue;
            }
            if(object == @"\n"){
                continue;
            }
            NSRange r = NSMakeRange(0,2);
            NSString  *tr = [object substringWithRange:r];
            Square from = getPosFromStr(std::string([tr UTF8String]));
            if(checkKingInChess){
                r = NSMakeRange(2,2);
                NSString  *tr = [object substringWithRange:r];
                Square to = getPosFromStr(std::string([tr UTF8String]));
                if(to == kingSq){
                    foundAttacker = true;
                    break;
                }
                continue;
            }
            if(hit == from){
                r = NSMakeRange(2,2);
                NSString  *tr = [object substringWithRange:r];
                Square to = getPosFromStr(std::string([tr UTF8String]));
                activeTo[activePos] = to;
                activePos++;
                movesCountSpecific++;
            }
            movesCountAll++;
        }
        
     
        if(movesCountSpecific==0){
            isSelected = false;
            activeFrom = -1;
        }
        if(movesCountAll==0){
            // stop clocks
            isClockRunning = false;
            [self stopTimer];
            
            if(checkKingInChess){
                checkKingInChess = false;
                if(foundAttacker){
                    // mate
                    if(board.sideToMove==BLACK){
                        game.result = "1-0";
                    }else{
                        game.result = "0-1";
                    }
                    [self->mainView setGame:@"#"];
                    
                }else{
                    // pat
                    game.result = "1/2-1/2";
                    [self->mainView setGame:@" 1/2-1/2"];
                }
                return;
            }
            
            // Check if mate
            checkKingInChess =true;
            string fen = board.getFen(&board);
            [wrapper getLegalMoves:fen];
        }
    }
    
    // standard Move
    int pos = (int)[move rangeOfString:@"bestmove"].location;
    if(pos > -1){
        NSRange r = NSMakeRange(pos+9,4);
        NSString *m = [move substringWithRange:r];
        r = NSMakeRange(0,2);
        NSString  *fr = [m substringWithRange:r];
        Square from = getPosFromStr(std::string([fr UTF8String]));
        r = NSMakeRange(2,2);
        NSString  *tr = [m substringWithRange:r];
        Square to = getPosFromStr(std::string([tr UTF8String]));
        Ply ply;
        ply.from = from;
        ply.to = to;
        string l = board.getPGNCode(board.squares[from]);
        NSString *letter = [NSString stringWithCString: l.c_str() encoding:[NSString defaultCStringEncoding]];
        NSString * t = [letter stringByAppendingString:m];
        ply.str = [m UTF8String];
        ply.strDisplay = [t UTF8String];
        
        // check for castling
        bool wCastlingS = board.castelingRights & 1;
        bool wCastlingL = board.castelingRights & 2;
        bool bCastlingS = board.castelingRights & 4;
        bool bCastlingL = board.castelingRights & 8;
       
        //WHITE short
        if(ply.from == SQ_E1  && ply.to == SQ_G1 && board.squares[ply.from] == W_KING){
            ply.strDisplay = "o-o";
            board.squares[SQ_H1] = EMPTY;
            board.squares[SQ_F1] = W_ROOK;
            wCastlingS = false;
            wCastlingL = false;
        } // long
        if(ply.from == SQ_E1  && ply.to == SQ_C1 && board.squares[ply.from] == W_KING){
            ply.strDisplay = "o-o-o";
            board.squares[SQ_A1] = EMPTY;
            board.squares[SQ_D1] = W_ROOK;
            wCastlingL = false;
            wCastlingS = false;
        }
        // Black short
        if(ply.from == SQ_E8  && ply.to == SQ_G8 && board.squares[ply.from] == B_KING){
            ply.strDisplay = "o-o";
            board.squares[SQ_H8] = EMPTY;
            board.squares[SQ_F8] = B_ROOK;
            bCastlingS = false;
            bCastlingL = false;
        }// long
        if(ply.from == SQ_E8  && ply.to == SQ_C8 && board.squares[ply.from] == B_KING){
            ply.strDisplay = "o-o-o";
            board.squares[SQ_A8] = EMPTY;
            board.squares[SQ_D8] = B_ROOK;
            bCastlingL = false;
            bCastlingS = false;
        }

        board.castelingRights = 0;
        if(wCastlingS)board.castelingRights += 1;
        if(wCastlingL)board.castelingRights += 2;
        if(bCastlingS)board.castelingRights += 4;
        if(bCastlingL)board.castelingRights += 8;
        
        // check for promotion
        // check for promotion
        if(board.sideToMove == WHITE){
            if(board.squares[activeFrom] == W_PAWN && ply.to > 55){
                // White Promotion
                r = NSMakeRange(12,1);
                NSString  *figure = [m substringWithRange:r];
                if(figure==@"q"){
                    board.squares[ply.from] = W_QUEEN;
                    ply.str += "q";
                    ply.strDisplay += "q";
                }
                if(figure==@"r"){
                    board.squares[ply.from] = W_ROOK;
                    ply.str += "r";
                    ply.strDisplay += "r";
                }
                if(figure==@"n"){
                    board.squares[ply.from] = W_KNIGHT;
                    ply.str += "n";
                    ply.strDisplay += "n";
                }
                if(figure==@"b"){
                    board.squares[ply.from] = W_BISHOP;
                    ply.str += "b";
                    ply.strDisplay += "b";
                }
            }
        }else{
            if(board.squares[activeFrom] == B_PAWN && ply.to > 8){
                // Black Promotion
                r = NSMakeRange(12,1);
                NSString  *figure = [m substringWithRange:r];
                if(figure==@"q"){
                    board.squares[ply.from] = B_QUEEN;
                    ply.str += "q";
                    ply.strDisplay += "q";
                }
                if(figure==@"r"){
                    board.squares[ply.from] = B_ROOK;
                    ply.str += "r";
                    ply.strDisplay += "r";
                }
                if(figure==@"n"){
                    board.squares[ply.from] = B_KNIGHT;
                    ply.str += "n";
                    ply.strDisplay += "n";
                }
                if(figure==@"b"){
                    board.squares[ply.from] = B_BISHOP;
                    ply.str += "b";
                    ply.strDisplay += "b";
                }
            }
        }
        
        game.plies.push_back(ply);
        [self makemove:ply];
    }
}

- (void) receivingBtn:(NSNotification *) notification{
    NSDictionary *dict = [notification userInfo];
    NSString *btnPressed = dict[@"btn"];
    if([btnPressed  isEqual: @"top"]){
        return;
    }
    if([btnPressed  isEqual: @"back"]){
        return;
    }
    if([btnPressed  isEqual: @"forw"]){
        return;
    }
    if([btnPressed  isEqual: @"end"]){
        return;
    }
    if([btnPressed  isEqual: @"analyse"]){
        return;
    }
    if([btnPressed  isEqual: @"hint"]){
        return;
    }
    if([btnPressed  isEqual: @"savePGN"]){
        return;
    }
    if([btnPressed  isEqual: @"loadPGN"]){
        return;
    }
    if([btnPressed  isEqual: @"resetBoard"]){
        [self newBoard];
        [self setNeedsDisplay:YES];
        return;
    }
    
    if([btnPressed  isEqual: @"clearBoard"]){
        isSetMode = true;
        for(int i=0; i < 64;i++){
            board.squares[i] = EMPTY;
        }
        [mainView enablePieceSelection];
        [self setNeedsDisplay:YES];
        return;
    }
    if([btnPressed  isEqual: @"setBoard"]){
        isSetMode = !isSetMode;
        if(isSetMode){
            [mainView enablePieceSelection];
        }else{
            [mainView disablePieceSelection];
        }
        return;
    }
    if([btnPressed  isEqual: @"settings"]){
        return;
    }
    if([btnPressed  isEqual: @"setFen"]){
        return;
    }
    if([btnPressed  isEqual: @"showPGN"]){
        return;
    }
    if([btnPressed  isEqual: @"showDb"]){
        return;
    }
    if([btnPressed  isEqual: @"showAnalytics"]){
        return;
    }
    if([btnPressed  isEqual: @"showDebug"]){
        return;
    }
    if([btnPressed  isEqual: @"showClear"]){
        return;
    }
    if([btnPressed  isEqual: @"reign"]){
        return;
    }
    
    if([btnPressed  isEqual: @"setQueenW"]){
        if(isWhitePromotion){
            ply.str += "q";
            ply.strDisplay += "q";
            board.squares[ply.from] = W_QUEEN;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = W_QUEEN;
        return;
    }
    if([btnPressed  isEqual: @"setRookW"]){
        if(isWhitePromotion){
            ply.str += "r";
            ply.strDisplay += "r";
            board.squares[ply.from] = W_ROOK;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = W_ROOK;
        return;
    }
    if([btnPressed  isEqual: @"setKnightW"]){
        if(isWhitePromotion){
            ply.str += "n";
            ply.strDisplay += "n";
            board.squares[ply.from] = W_KNIGHT;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = W_KNIGHT;
        return;
    }
    if([btnPressed  isEqual: @"setBishopW"]){
        if(isWhitePromotion){
            ply.str += "b";
            ply.strDisplay += "b";
            board.squares[ply.from] = W_BISHOP;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = W_BISHOP;
        return;
    }
    if([btnPressed  isEqual: @"setQueenB"]){
        if(isBlackPromotion){
            ply.str += "q";
            ply.strDisplay += "q";
            board.squares[ply.from] = B_QUEEN;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        return;
    }
    if([btnPressed  isEqual: @"setRookB"]){
        if(isBlackPromotion){
            ply.str += "r";
            ply.strDisplay += "r";
            board.squares[ply.from] = B_ROOK;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = B_ROOK;
        return;
    }
    if([btnPressed  isEqual: @"setKnightB"]){
        if(isBlackPromotion){
            ply.str += "n";
            ply.strDisplay += "n";
            board.squares[ply.from] = B_KNIGHT;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = B_KNIGHT;
        return;
    }
    if([btnPressed  isEqual: @"setBishopB"]){
        if(isBlackPromotion){
            ply.str += "b";
            ply.strDisplay += "b";
            board.squares[ply.from] = B_BISHOP;
            game.plies.push_back(ply);
            [self makemove:ply];
        }
        lastSelectedPiece = B_BISHOP;
        return;
    }
}

- (void)makemove:(Ply)ply{
    enum EPiece p = board.squares[ply.from];
    board.squares[ply.from] = EMPTY;
    board.squares[ply.to] = p;
    activeTo[0] = ply.to;
    isSelected = false;
    // Color swap
    if(board.sideToMove == WHITE){
        board.sideToMove = BLACK;
    }else{
        board.sideToMove = WHITE;
        board.halfmove++;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *png = [NSString stringWithCString: ply.strDisplay.c_str() encoding:[NSString defaultCStringEncoding]];
        
        if(self->board.sideToMove == WHITE){
            png = [@" " stringByAppendingString: png];
        }else{
            NSString *strFromInt = [NSString stringWithFormat:@"\n%d", board.halfmove];
            strFromInt = [strFromInt stringByAppendingString: @ ". "];
            png = [strFromInt stringByAppendingString: png];
        }
        if(self->board.sideToMove == WHITE){
            [self SetWhiteToMove];
        }else{
            [self SetBlackToMove];
        }
        [self->mainView setGame:png];
        [self setNeedsDisplay:YES];
    });
}

/*
 ==================================================================================
 Handle the Mouse Event
 Here we get the user input on the field
 ==================================================================================
 */
- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    int x = curPoint.x-BORDER;
    int y = curPoint.y-BORDER;
    int file = x/95;
    int rank =  y/95;
    int fieldId;
    if(isFliped){
        fieldId = 63 - (file + rank * 8) ;
    }else{
        fieldId = file + rank* 8 ;
    }
    if(fieldId == hit){
        if(activeFrom == hit){
            activeFrom = -1;
            isSelected = false;
            [self findMoves:-1];
        }else{
            // select From
            if(activeFrom == -1){
                if(board.squares[hit] == EMPTY){
                    activeFrom = -1;
                    isSelected = false;
                    [self findMoves:-1];
                    [self setNeedsDisplay:YES];
                    return;
                }
                
                // check Color
                if(board.sideToMove==WHITE && board.squares[hit] > 6 ){
                    activeFrom = -1;
                    isSelected = false;
                    [self findMoves:-1];
                    [self setNeedsDisplay:YES];
                    return;
                }
                // check Color
                if(board.sideToMove==BLACK && board.squares[hit] < 7 ){
                    activeFrom = -1;
                    isSelected = false;
                    [self findMoves:-1];
                    [self setNeedsDisplay:YES];
                    return;
                }
                
                activeFrom = hit;
                isSelected = true;
                [self findMoves:hit];
            }else{
                bool found = false;
                for(int i=0;i<64;i++){
                    if(hit == activeTo[i]){
                        found = true;
                        break;
                    }
                }
                
                //found = true; //TODO faking movegen - allow all Moves
                if(found){
                    enum EPiece p = board.squares[activeFrom];
                    board.squares[activeFrom] = EMPTY;
                    board.squares[hit] = p;
                    
                    ply.from = activeFrom;
                    ply.to = hit;
                    ply.str = posFromInt(activeFrom) + posFromInt(hit);
                    string l = board.getPGNCode(p);
                    ply.strDisplay = l+ply.str ;
                    
                    // discover castling
                    bool wCastlingS = board.castelingRights & 1;
                    bool wCastlingL = board.castelingRights & 2;
                    bool bCastlingS = board.castelingRights & 4;
                    bool bCastlingL = board.castelingRights & 8;
                   
                    //WHITE short
                    if(ply.from == SQ_E1  && ply.to == SQ_G1 && board.squares[ply.to] == W_KING){
                        ply.strDisplay = "o-o";
                        board.squares[SQ_H1] = EMPTY;
                        board.squares[SQ_F1] = W_ROOK;
                        wCastlingS = false;
                        wCastlingL = false;
                    } // long
                    if(ply.from == SQ_E1  && ply.to == SQ_C1 && board.squares[ply.to] == W_KING){
                        ply.strDisplay = "o-o-o";
                        board.squares[SQ_A1] = EMPTY;
                        board.squares[SQ_D1] = W_ROOK;
                        wCastlingL = false;
                        wCastlingS = false;
                    }
                    // Black short
                    if(ply.from == SQ_E8  && ply.to == SQ_G8 && board.squares[ply.to] == B_KING){
                        ply.strDisplay = "o-o";
                        board.squares[SQ_H8] = EMPTY;
                        board.squares[SQ_F8] = B_ROOK;
                        bCastlingS = false;
                        bCastlingL = false;
                    }// long
                    if(ply.from == SQ_E8  && ply.to == SQ_C8 && board.squares[ply.to] == B_KING){
                        ply.strDisplay = "o-o-o";
                        board.squares[SQ_A8] = EMPTY;
                        board.squares[SQ_D8] = B_ROOK;
                        bCastlingL = false;
                        bCastlingS = false;
                    }
    
                    board.castelingRights = 0;
                    if(wCastlingS)board.castelingRights += 1;
                    if(wCastlingL)board.castelingRights += 2;
                    if(bCastlingS)board.castelingRights += 4;
                    if(bCastlingL)board.castelingRights += 8;
                    
                    // check for promotion
                    if(board.sideToMove == WHITE){
                        if(board.squares[activeFrom] == W_PAWN && ply.to > 55){
                            // White Promotion
                            isWhitePromotion = true;
                            [mainView enableWhitePromotion];
                        }
                    }else{
                        if(board.squares[activeFrom] == B_PAWN && ply.to > 8){
                            isBlackPromotion = true;
                            [mainView enableBlackPromotion ];
                        }
                    }
                    
                    if(board.sideToMove == WHITE){
                        board.sideToMove = BLACK;
                        [self SetBlackToMove];
                    }else{
                        board.halfmove++;
                        board.sideToMove = WHITE;
                        [self SetWhiteToMove];
                    }
                    [self findMoves:-1];
                    
                    game.plies.push_back(ply);
                    NSString *png = [NSString stringWithCString: ply.strDisplay.c_str() encoding:[NSString defaultCStringEncoding]];
                    if(self->board.sideToMove == WHITE){
                        png = [@" " stringByAppendingString: png];
                    }else{
                        NSString *strFromInt = [NSString stringWithFormat:@"\n%d", board.halfmove];
                        strFromInt = [strFromInt stringByAppendingString: @ ". "];
                        png = [strFromInt stringByAppendingString: png];
                    }
                    
                    [self->mainView setGame:png];
                    
                    string fen = board.getFen(&board);
                    NSString *fens = [NSString stringWithCString:fen.c_str() encoding:[NSString defaultCStringEncoding]];
                    [mainView setFen:fens];
                    
                    //  Check book
                    U64 hash =  pgkey.findHash(fen);
                    string mv = pgshow.readBook(hash, bookPath);
                    if("ERR" == mv){
                        [wrapper findMove :fen];
                    }else{
                        Ply ply;
                        ply.from =  getPosFromStr(mv.substr(0,2));
                        ply.to =  getPosFromStr(mv.substr(2,2));
                        ply.str = mv;
                        string l = board.getPGNCode(board.squares[ply.from]);
                        ply.strDisplay = l+mv;
                        game.plies.push_back(ply);
                        [self makemove:ply];
                    }
                    if(!isClockRunning){
                        [self startTimer];
                    }
                    activeFrom =-1;
                }
            }
        }
    }else{
        activeFrom = -1;
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    int x = curPoint.x-BORDER;
    int y = curPoint.y-BORDER;
    int file = x/95;
    int rank =  y/95;
    if(isFliped){
        hit = (Square) (63 - (file + rank* 8)) ;
    }else{
        hit = (Square) (file + rank * 8) ;
    }
    [self setNeedsDisplay:YES];
}

- (void)flip{
    isFliped = !isFliped;
    [self setNeedsDisplay:YES];
}

- (void)findMoves:(int)pos  {
    if(pos<0){
        for(int i=0; i < 64; ++i){
            activeTo[i] = -1;
        }
        return;
    }
    
    for(int i=0; i < 64; ++i){
        activeTo[i] = -1;
    }
    gettingLegalMoves = true;
    activePos = 0;
    string fen = board.getFen(&board);
    [wrapper getLegalMoves:fen];
}

- (void)clearBoard{
    for(int i=0; i<64;++i){
        board.squares[i] = EMPTY;
        activeTo[i] = -1;
    }
    activeFrom = -1;
    board.sideToMove = WHITE;
}

- (void)newBoard{
    for(int i=0; i<64;++i){
        activeTo[i] = -1;
        board.squares[i] = EMPTY;
    }

    activeFrom = -1;
    board.rule50 = 0;
    board.halfmove = 1;
    board.squares[0] = W_ROOK;
    board.squares[1] = W_KNIGHT;
    board.squares[2] = W_BISHOP;
    board.squares[3] = W_QUEEN;
    board.squares[4] = W_KING;
    board.squares[5] = W_BISHOP;
    board.squares[6] = W_KNIGHT;
    
    board.squares[7] = W_ROOK;
    board.squares[8] = W_PAWN;
    board.squares[9] = W_PAWN;
    board.squares[10] = W_PAWN;
    board.squares[11] = W_PAWN;
    board.squares[12] = W_PAWN;
    board.squares[13] = W_PAWN;
    board.squares[14] = W_PAWN;
    board.squares[15] = W_PAWN;
    
    board.squares[48] = B_PAWN;
    board.squares[49] = B_PAWN;
    board.squares[50] = B_PAWN;
    board.squares[51] = B_PAWN;
    board.squares[52] = B_PAWN;
    board.squares[53] = B_PAWN;
    board.squares[54] = B_PAWN;
    board.squares[55] = B_PAWN;
    
    board.squares[56] = B_ROOK;
    board.squares[57] = B_KNIGHT;
    board.squares[58] = B_BISHOP;
    board.squares[59] = B_QUEEN;
    board.squares[60] = B_KING;
    board.squares[61] = B_BISHOP;
    board.squares[62] = B_KNIGHT;
    board.squares[63] = B_ROOK;
    board.sideToMove = WHITE;
}

- (void)close{
    [wrapper close];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSApp terminate:self];
}

- (void)setup{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.window];
    activeFrom = -1;
    [self newBoard];
    wrapper = [Wrapper alloc];
    [wrapper initWrapper];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(receivingMethodOnListener:)
        name:@"cmove"
        object:nil];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(receivingBtn:)
        name:@"btn"
        object:nil];
    
    [self setNeedsDisplay:YES];
}

- (void)windowWillClose:(NSNotification *)notification
    {
        NSWindow *win = [notification object];
        [self close];
    }

/*
 =================================================================================================
 Drawing UI
 =================================================================================================
 */
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    NSSize size = NSMakeSize(77,77);
    NSImage *wBishop = [self imageResize:[NSImage imageNamed:@"Chess_blt60"] newSize:size];
    NSImage *wRook = [self imageResize:[NSImage imageNamed:@"Chess_rlt60"] newSize:size];
    NSImage *WKnight = [self imageResize:[NSImage imageNamed:@"Chess_nlt60"] newSize:size];
    NSImage *wKing = [self imageResize:[NSImage imageNamed:@"Chess_klt60"] newSize:size];
    NSImage *wQueen = [self imageResize:[NSImage imageNamed:@"Chess_qlt60"] newSize:size];
    NSImage *wPawn = [self imageResize:[NSImage imageNamed:@"Chess_plt60"] newSize:size];
    
    NSImage *bBishop = [self imageResize:[NSImage imageNamed:@"Chess_bdt60"] newSize:size];
    NSImage *bRook = [self imageResize:[NSImage imageNamed:@"Chess_rdt60"] newSize:size];
    NSImage *bKnight = [self imageResize:[NSImage imageNamed:@"Chess_ndt60"] newSize:size];
    NSImage *bKing = [self imageResize:[NSImage imageNamed:@"Chess_kdt60"] newSize:size];
    NSImage *bQueen = [self imageResize:[NSImage imageNamed:@"Chess_qdt60"] newSize:size];
    NSImage *bPawn = [self imageResize:[NSImage imageNamed:@"Chess_pdt60"] newSize:size];
    
    [[NSColor grayColor] set];
     NSRectFill([self bounds]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:17], NSFontAttributeName,[NSColor whiteColor], NSForegroundColorAttributeName, nil];
    
    NSDictionary *attributesSmall = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:13], NSFontAttributeName,[NSColor grayColor], NSForegroundColorAttributeName, nil];
    
    NSColor *myColor = [NSColor colorWithCalibratedRed:0.4 green:0.4 blue:0.9 alpha:0.7f];
    bool flip = true;
    for(int x=0; x < 8; ++x){
        for(int y=0; y < 8; ++y){
            if(flip){
                [myColor set];
            }else{
                [[NSColor whiteColor] set];
            }
            flip = !flip;
            CGRect rectangle = CGRectMake(BORDER + x * 95, BORDER + y * 95, 95, 95);
            NSRectFill( rectangle);
            
            int no = y*8+x;
            if(isFliped){
                no = 63-no;
            }
            NSString *ss = [NSString stringWithFormat:@"%i",no];
            NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:ss attributes: attributesSmall];
            [currentText drawAtPoint:NSMakePoint(23 + x * 95, 20 + y * 95)];
        }
        flip = !flip;
    }

    for(int i =0; i < 8;i++){
        int file = i;
        if(isFliped){
            file = 7-file;
        }
        char c = (char) file + 65;
        NSString *s = [NSString stringWithFormat:@"%c", c];
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:s attributes: attributes];
        [currentText drawAtPoint:NSMakePoint(59+i*95  , 0)];
        [currentText drawAtPoint:NSMakePoint(59+i*95  , 780)];
    }
    for(int i =0; i < 8;i++){
        int rank = i;
        if(isFliped){
            rank = 7-rank;
        }
        char c = (char) rank + 49;
        NSString *s = [NSString stringWithFormat:@"%c", c];
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:s attributes: attributes];
        [currentText drawAtPoint:NSMakePoint(5, 59+i*95)];
        [currentText drawAtPoint:NSMakePoint(785,59+i*95 )];
    }
    
    // Active Fields
    if(activeFrom > -1){
        int aField = activeFrom;
        if(isFliped){
            aField = 63-aField;
        }
        int x = aField % 8;
        int y = aField / 8;
        int xPos = 27 + x * 95;
        int yPos = 27 + y * 95;
        NSRect rect = NSMakeRect(xPos, yPos, 80, 80);
        NSBezierPath* circlePath = [NSBezierPath bezierPath];
        [circlePath appendBezierPathWithOvalInRect: rect];
        [[NSColor yellowColor] setStroke];
        [[NSColor yellowColor] setFill];
        [circlePath stroke];
        [circlePath fill];
    }
    
    for(int i=0;i<64;i++){
        if(activeTo[i]>-1){
            int aField = activeTo[i];
            if(isFliped){
                aField = 63-aField;
            }
            int x = aField % 8;
            int y = aField / 8;
            int xPos = 27 + x * 95;
            int yPos = 27 + y * 95;
            NSRect rect = NSMakeRect(xPos, yPos, 80, 80);
            NSBezierPath* circlePath = [NSBezierPath bezierPath];
            [circlePath appendBezierPathWithOvalInRect: rect];
            [[NSColor orangeColor] setStroke];
            [[NSColor orangeColor] setFill];
            [circlePath stroke];
            [circlePath fill];
        }
    }
    
    for(int i =0;i<64;++i){
        
        int p = i;
        if(isFliped){
            p = 63-p;
        }
        
        int x = p % 8;
        int y = p / 8;
        int xPos = 27 + x * 95;
        int yPos = 29 + y * 95;
        
        switch(board.squares[i]){
  
            case EMPTY:
                continue;
                
            case W_KING:
                [wKing drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case W_QUEEN:
                [wQueen drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case W_ROOK:
                [wRook drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case W_KNIGHT:
                [WKnight drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case W_BISHOP:
                [wBishop drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case W_PAWN:
                [wPawn drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case B_KING:
                [bKing drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case B_QUEEN:
                [bQueen drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case B_ROOK:
                [bRook drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case B_KNIGHT:
                [bKnight drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case B_BISHOP:
                [bBishop drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;
            case B_PAWN:
                [bPawn drawAtPoint:NSMakePoint(xPos,yPos) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
                break;

            default:
                break;
        }
    }
}

- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;

    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}
@end
