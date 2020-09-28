//
//  MainView.m
//  SwanUI
//
//  Created by Mathias Dietrich on 27.09.20.
//

#import "MainView.h"

@implementation MainView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setFen:(NSString*)fen {
    [fenField setStringValue: fen];
}

- (void)setGame:(NSString*)png{
    NSString    *text        = [gameField stringValue];
    NSString *joinedString = [text stringByAppendingString:png];
    [gameField setStringValue:joinedString];
}

- (IBAction)top:(id)sender{
    
}
- (IBAction)back:(id)sender{
    
}
- (IBAction)stop:(id)sender{
    
}
- (IBAction)foward:(id)sender{
    
}
- (IBAction)end:(id)sender{
    
}
- (IBAction)analys:(id)sender{
    
}
- (IBAction)hint:(id)sender{
    
}
- (IBAction)savePGN:(id)sender{
    
}
- (IBAction)loadPGN:(id)sender{
    
}
- (IBAction)clearBoard:(id)sender{
    
}
- (IBAction)setBoard:(id)sender{
    
}
- (IBAction)settings:(id)sender{
    
}

- (IBAction)showPGN:(id)sender{
    
}
- (IBAction)showDb:(id)sender{
    
}
- (IBAction)showAnalytics:(id)sender{
    
}
- (IBAction)showDebug:(id)sender{
    
}
- (IBAction)clearDebug:(id)sender{
    
}

- (IBAction)setKingW:(id)sender{
    
}
- (IBAction)setKingB:(id)sender{
    
}
- (IBAction)setQueenW:(id)sender{
    
}
- (IBAction)setQueenB:(id)sender{
    
}
- (IBAction)setRookpW:(id)sender{
    
}
- (IBAction)setRookpB:(id)sender{
    
}
- (IBAction)setKnightW:(id)sender{
    
}
- (IBAction)setKnightB:(id)sender{
    
}
- (IBAction)setBishopW:(id)sender{
    
}
- (IBAction)setBishopB:(id)sender{
    
}
- (IBAction)setPawnW:(id)sender{
    
}
- (IBAction)setPawnB:(id)sender{
    
}



@end
