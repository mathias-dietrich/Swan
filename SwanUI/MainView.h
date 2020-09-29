//
//  MainView.h
//  SwanUI
//
//  Created by Mathias Dietrich on 27.09.20.
//

#ifndef MainView_h
#define MainView_h

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@interface MainView : NSView{
    IBOutlet NSTextField * fenField;
    IBOutlet NSTextField * gameField;
    
    IBOutlet NSTextField * timeW;
    IBOutlet NSTextField * timeB;
    IBOutlet NSTextField * engineInfo;
    
    IBOutlet NSComboBox * playerW;
    IBOutlet NSComboBox * playerB;
    IBOutlet NSComboBox * gameType;
    
    IBOutlet NSButton * btnTop;
    IBOutlet NSButton * btnBack;
    IBOutlet NSButton * btnStop;
    IBOutlet NSButton * btnForw;
    IBOutlet NSButton * btnEnd;
    IBOutlet NSButton * btnAnanlyse;
    IBOutlet NSButton * btnHint;
    IBOutlet NSButton * btnSavePGN;
    IBOutlet NSButton * btnLoadPGN;
    IBOutlet NSButton * btnClearBoard;
    IBOutlet NSButton * btnSetBoard;
    IBOutlet NSButton * btnSettings;
    IBOutlet NSButton * btnSetFen;
    IBOutlet NSButton * btnPGN;
    IBOutlet NSButton * btnDb;
    IBOutlet NSButton * btnAnalysis;
    IBOutlet NSButton * btnDebug;
    IBOutlet NSButton * btnClear;
    IBOutlet NSButton * btnResign;
    IBOutlet NSButton * btnResetBoard;
    IBOutlet NSButton * btnKingW;
    IBOutlet NSButton * btnQueenW;
    IBOutlet NSButton * btnRookW;
    IBOutlet NSButton * btnBishopW;
    IBOutlet NSButton * btnKnightW;
    IBOutlet NSButton * btnPawnW;
    
    IBOutlet NSButton * btnKingB;
    IBOutlet NSButton * btnQueenB;
    IBOutlet NSButton * btnRookB;
    IBOutlet NSButton * btnBishopB;
    IBOutlet NSButton * btnKnightB;
    IBOutlet NSButton * btnPawnB;
}


- (void)call:(NSString*)b;
- (void)setGame:(NSString*)png;

- (IBAction)top:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)foward:(id)sender;
- (IBAction)end:(id)sender;
- (IBAction)analys:(id)sender;
- (IBAction)hint:(id)sender;
- (IBAction)savePGN:(id)sender;
- (IBAction)loadPGN:(id)sender;
- (IBAction)setBoard:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)setFen:(id)sender;
- (IBAction)showPGN:(id)sender;
- (IBAction)showDb:(id)sender;
- (IBAction)showAnalytics:(id)sender;
- (IBAction)showDebug:(id)sender;
- (IBAction)clearDebug:(id)sender;
- (IBAction)clearBoard:(id)sender;
- (IBAction)setKingW:(id)sender;
- (IBAction)setKingB:(id)sender;
- (IBAction)setQueenW:(id)sender;
- (IBAction)setQueenB:(id)sender;
- (IBAction)setRookpW:(id)sender;
- (IBAction)setRookpB:(id)sender;
- (IBAction)setKnightW:(id)sender;
- (IBAction)setKnightB:(id)sender;
- (IBAction)setBishopW:(id)sender;
- (IBAction)setBishopB:(id)sender;
- (IBAction)setPawnW:(id)sender;
- (IBAction)setPawnB:(id)sender;
- (IBAction)reign:(id)sender;
- (IBAction)resetBoard:(id)sender;
- (void)disablePieceSelection;
- (void)enablePieceSelection;
- (void)enableWhitePromotion;
- (void)enableBlackPromotion;

NS_ASSUME_NONNULL_END
@end


#endif /* MainView_h */
