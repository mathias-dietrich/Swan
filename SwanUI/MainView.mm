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


@end
