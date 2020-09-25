//
//  Field.m
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import "Field.h"

@implementation Field

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    int x = curPoint.x-BORDER;
    int y = curPoint.y-BORDER;
    int file = x/95;
    int rank =  y/95;
    hit = file + rank* 8 ;
    [self setNeedsDisplay:YES];
}
 
- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    int x = curPoint.x-BORDER;
    int y = curPoint.y-BORDER;
    int file = x/95;
    int rank =  y/95;
    int fieldId = file + rank* 8 ;
    if(fieldId == hit){
        
        if(activeFrom == hit){
            activeFrom = -1;
            isSelected = false;
        }else{
            // select From
            if(activeFrom == -1){
                if(pieces[hit] == EMPTY){
                    activeFrom = -1;
                    isSelected = false;
                    [self setNeedsDisplay:YES];
                    return;
                }
                
                // check Color
                if(nextToMove==WHITE && pieces[hit] > 6 ){
                    activeFrom = -1;
                    isSelected = false;
                    [self setNeedsDisplay:YES];
                    return;
                }
                // check Color
                if(nextToMove==BLACK && pieces[hit] < 7 ){
                    activeFrom = -1;
                    isSelected = false;
                    [self setNeedsDisplay:YES];
                    return;
                }
                
                activeFrom = hit;
                isSelected = true;
            }else{
                // Select to
                
                
                // handle  move
                // test
                // make
                enum piece p = pieces[activeFrom];
                pieces[activeFrom] = EMPTY;
                pieces[hit] = p;
                activeFrom =-1;
                if(nextToMove == WHITE){
                    nextToMove = BLACK;
                }else{
                    nextToMove = WHITE;
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
    [sourceImage setScalesWhenResized:YES];

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
    if(needsInit){
        [self setFen: @""];
        needsInit = false;
    }
   
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
            
            NSString *ss = [NSString stringWithFormat:@"%i", y*8+x];
            NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:ss attributes: attributesSmall];
            [currentText drawAtPoint:NSMakePoint(23 + x * 95, 20 + y * 95)];
        }
        flip = !flip;
    }

    for(int i =0; i < 8;i++){
        char c = (char) i + 65;
        NSString *s = [NSString stringWithFormat:@"%c", c];
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:s attributes: attributes];
        [currentText drawAtPoint:NSMakePoint(59+i*95  , 0)];
        [currentText drawAtPoint:NSMakePoint(59+i*95  , 780)];
    }
    for(int i =0; i < 8;i++){
        char c = (char) i + 49;
        NSString *s = [NSString stringWithFormat:@"%c", c];
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:s attributes: attributes];
        [currentText drawAtPoint:NSMakePoint(5, 59+i*95)];
        [currentText drawAtPoint:NSMakePoint(785,59+i*95 )];
    }
    
    // Active Fields
    if(activeFrom > -1){
        int x = activeFrom % 8;
        int y = activeFrom / 8;
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
            int x = activeTo[i] % 8;
            int y = activeTo[i] / 8;
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
        int x = i % 8;
        int y = i / 8;
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

    // Drawing code here.
}

@end
