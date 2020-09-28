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
}

- (void)setFen:(NSString*)fen {
    [fenField setStringValue: fen];
}

- (void)setGame:(NSString*)png{
    NSString    *text        = [gameField stringValue];
    NSString *joinedString = [text stringByAppendingString:png];
    [gameField setStringValue:joinedString];
}
- (void)call:(NSString*)b{
    NSDictionary * userInfo = @{ @"btn" :b};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"btn" object:nil  userInfo:userInfo];
}

- (IBAction)top:(id)sender{
    [self call:@"top"];
}
- (IBAction)back:(id)sender{
    [self call:@"back"];
}
- (IBAction)stop:(id)sender{
    [self call:@"stop"];
}
- (IBAction)foward:(id)sender{
    [self call:@"foward"];
}
- (IBAction)end:(id)sender{
    [self call:@"end"];
}
- (IBAction)analys:(id)sender{
    [self call:@"analyse"];
}
- (IBAction)hint:(id)sender{
    [self call:@"hint"];
}
- (IBAction)savePGN:(id)sender{
    [self call:@"savePGN"];
}
- (IBAction)loadPGN:(id)sender{
    [self call:@"loadPGN"];
}
- (IBAction)clearBoard:(id)sender{
    [self call:@"clearBoard"];
}
- (IBAction)setBoard:(id)sender{
    [self call:@"setBoard"];
}
- (IBAction)settings:(id)sender{
    [self call:@"settings"];
}
- (IBAction)showPGN:(id)sender{
    [self call:@"showPGN"];
}
- (IBAction)showDb:(id)sender{
    [self call:@"showDb"];
}
- (IBAction)showAnalytics:(id)sender{
    [self call:@"showAnalytics"];
}
- (IBAction)showDebug:(id)sender{
    [self call:@"showDebug"];
}
- (IBAction)clearDebug:(id)sender{
    [self call:@"clearDebug"];
}
- (IBAction)setKingW:(id)sender{
    [self call:@"setKingW"];
}
- (IBAction)setKingB:(id)sender{
    [self call:@"setKingB"];
}
- (IBAction)setQueenW:(id)sender{
    [self call:@"setQueenW"];
}
- (IBAction)setQueenB:(id)sender{
    [self call:@"setQueenB"];
}
- (IBAction)setRookpW:(id)sender{
    [self call:@"setRookpW"];
}
- (IBAction)setRookpB:(id)sender{
    [self call:@"setRookpB"];
}
- (IBAction)setKnightW:(id)sender{
    [self call:@"setKnightW"];
}
- (IBAction)setKnightB:(id)sender{
    [self call:@"setKnightB"];
}
- (IBAction)setBishopW:(id)sender{
    [self call:@"setBishopW"];
}
- (IBAction)setBishopB:(id)sender{
    [self call:@"setBishopB"];
}
- (IBAction)setPawnW:(id)sender{
    [self call:@"setPawnW"];
}
- (IBAction)setPawnB:(id)sender{
    [self call:@"setPawnB"];
}



@end
