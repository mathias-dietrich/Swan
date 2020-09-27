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
}

- (void)setFen:(NSString*)fen;
- (void)setGame:(NSString*)png;

NS_ASSUME_NONNULL_END
@end


#endif /* MainView_h */
