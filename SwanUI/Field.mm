//
//  Field.m
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import "Field.h"
#import "Board.h"

@implementation Field

enum EPiece pieces[64];
int activeFrom = -1;
int activeTo[64];
int BORDER =20;
int hit =-1;
bool isSelected = false;
Color nextToMove;
Wrapper * wrapper;
bool isFliped = false;
vector<Ply> plies;
bool wCastlingL = true;
bool wCastlingS = true;
bool bCastlingL = true;
bool bCastlingS = true;

- (void)close{
    [wrapper close];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup{
    nextToMove = WHITE;
    activeFrom = -1;
    [self setFen: @""];
    wrapper = [Wrapper alloc];
    [wrapper initWrapper];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(receivingMethodOnListener:)
        name:@"cmove"
        object:nil];
    
    [self setNeedsDisplay:YES];
}

- (void) receivingMethodOnListener:(NSNotification *) notification{
    NSDictionary *dict = [notification userInfo];
    NSString *move = dict[@"move"];
    
    int pos = [move rangeOfString:@"bestmove"].location;
    if(pos > -1){
        NSRange r = NSMakeRange(pos,14);
        NSString *m = [move substringWithRange:r];
        NSLog(m);
        r = NSMakeRange(9,2);
        NSString  *fr = [m substringWithRange:r];
        Square from = getPosFromStr(std::string([fr UTF8String]));
        
        r = NSMakeRange(11,2);
        NSString  *tr = [m substringWithRange:r];
        Square to = getPosFromStr(std::string([tr UTF8String]));
        Ply ply;
        ply.from = from;
        ply.to = to;
        ply.str = posFromInt(from) + posFromInt(to);
        plies.push_back(ply);
        [self makemove:ply];
    }
}

- (void)makemove:(Ply)ply{
    enum EPiece p = pieces[ply.from];
    pieces[ply.from] = EMPTY;
    pieces[ply.to] = p;
    

    if(nextToMove == WHITE){
        nextToMove = BLACK;
    }else{
        nextToMove = WHITE;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    
        
        NSString *png = [NSString stringWithCString: ply.str.c_str() encoding:[NSString defaultCStringEncoding]];
        png = [@" " stringByAppendingString: png];
        [mainView setGame:png];
        
        [self setNeedsDisplay:YES];
    });
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

    int *b = new int[64];
    for(int i=0;i<64;i++){
        b[i] = pieces[i];
    }
    
    movearray a = [wrapper getMoves:pos board:b];
    for(int i=0; i < 64; ++i){
        activeTo[i] = a.moves[i];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    int x = curPoint.x-BORDER;
    int y = curPoint.y-BORDER;
    int file = x/95;
    int rank =  y/95;
    if(isFliped){
        hit = 63 - (file + rank* 8) ;
    }else{
        hit = file + rank * 8 ;
    }
    [self setNeedsDisplay:YES];
}


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
                if(pieces[hit] == EMPTY){
                    activeFrom = -1;
                    isSelected = false;
                    [self findMoves:-1];
                    [self setNeedsDisplay:YES];
                    return;
                }
                
                // check Color
                if(nextToMove==WHITE && pieces[hit] > 6 ){
                    activeFrom = -1;
                    isSelected = false;
                    [self findMoves:-1];
                    [self setNeedsDisplay:YES];
                    return;
                }
                // check Color
                if(nextToMove==BLACK && pieces[hit] < 7 ){
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
                // Select to
                
                // handle  move
                // test
                // make
                // check move is valid
                bool found = false;
                for(int i=0;i<64;i++){
                    if(hit == activeTo[i]){
                        found = true;
                        break;
                    }
                }
                
                found = true; //TODO faking movegen - allow all Moves
                if(found){
                    enum EPiece p = pieces[activeFrom];
                    pieces[activeFrom] = EMPTY;
                    pieces[hit] = p;
                    
                    if(nextToMove == WHITE){
                        nextToMove = BLACK;
                    }else{
                        nextToMove = WHITE;
                    }
                    [self findMoves:-1];
                    Ply ply;
                    ply.from = activeFrom;
                    ply.to = hit;
                    ply.str = posFromInt(activeFrom) + posFromInt(hit);
                    
                    // discover castling
                    //WHITE short
                    if(ply.from == SQ_E1  && ply.to == SQ_G1 && pieces[ply.to] == W_KING){
                        ply.str = "o-o";
                        pieces[SQ_H1] = EMPTY;
                        pieces[SQ_F1] = W_ROOK;
                        wCastlingS = false;
                    } // long
                    if(ply.from == SQ_E1  && ply.to == SQ_C1 && pieces[ply.to] == W_KING){
                        ply.str = "o-o-o";
                        pieces[SQ_A1] = EMPTY;
                        pieces[SQ_D1] = W_ROOK;
                        wCastlingL = false;
                    }
                    // Black short
                    if(ply.from == SQ_E8  && ply.to == SQ_G8 && pieces[ply.to] == B_KING){
                        ply.str = "o-o";
                        pieces[SQ_H8] = EMPTY;
                        pieces[SQ_F8] = B_ROOK;
                        bCastlingS = false;
                    }// long
                    if(ply.from == SQ_E8  && ply.to == SQ_C8 && pieces[ply.to] == B_KING){
                        ply.str = "o-o-o";
                        pieces[SQ_A8] = EMPTY;
                        pieces[SQ_D8] = B_ROOK;
                        bCastlingL = false;
                    }
                    
                    NSString *png = [NSString stringWithCString: ply.str.c_str() encoding:[NSString defaultCStringEncoding]];
                    png = [@"\n1. " stringByAppendingString: png];
                    [mainView setGame:png];
                    
                    plies.push_back(ply);
                    TBoard board;
                   // board.bb.squares = pieces;
                    for(int i=0;i<64;i++){
                        board.squares[i] = pieces[i];
                    }
                    board.castelingRights = 0;
                    if(wCastlingS)board.castelingRights += 1;
                    if(wCastlingL)board.castelingRights += 2;
                    if(bCastlingS)board.castelingRights += 4;
                    if(bCastlingL)board.castelingRights += 8;
                    
                    string fen = board.getFen(&board);
            
                    NSString *fens = [NSString stringWithCString:fen.c_str() encoding:[NSString defaultCStringEncoding]];
                    [mainView setFen:fens];
                    [wrapper findMove :fen];
                    activeFrom =-1;
                }
            }
        }
    }else{
        activeFrom = -1;
    }
    [self setNeedsDisplay:YES];
}

- (void)setFen:(NSString*)fen{
    pieces[0] = W_ROOK;
    pieces[1] = W_KNIGHT;
    pieces[2] = W_BISHOP;
    pieces[3] = W_QUEEN;
    pieces[4] = W_KING;
    pieces[5] = W_BISHOP;
    pieces[6] = W_KNIGHT;
    
    pieces[7] = W_ROOK;
    pieces[8] = W_PAWN;
    pieces[9] = W_PAWN;
    pieces[10] = W_PAWN;
    pieces[11] = W_PAWN;
    pieces[12] = W_PAWN;
    pieces[13] = W_PAWN;
    pieces[14] = W_PAWN;
    pieces[15] = W_PAWN;
    
    pieces[48] = B_PAWN;
    pieces[49] = B_PAWN;
    pieces[50] = B_PAWN;
    pieces[51] = B_PAWN;
    pieces[52] = B_PAWN;
    pieces[53] = B_PAWN;
    pieces[54] = B_PAWN;
    pieces[55] = B_PAWN;
    
    pieces[56] = B_ROOK;
    pieces[57] = B_KNIGHT;
    pieces[58] = B_BISHOP;
    pieces[59] = B_QUEEN;
    pieces[60] = B_KING;
    pieces[61] = B_BISHOP;
    pieces[62] = B_KNIGHT;
    pieces[63] = B_ROOK;
    
    for(int i=0; i<64;++i){
        activeTo[i] = -1;
    }
    activeFrom = -1;
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
        
        switch(pieces[i]){
  
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

@end
