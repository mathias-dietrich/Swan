//
//  Field.m
//  SwanUI
//
//  Created by Mathias Dietrich on 24.09.20.
//

#import "Field.h"

@implementation Field

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
    
    [[NSColor grayColor] set];
     NSRectFill([self bounds]);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:17], NSFontAttributeName,[NSColor whiteColor], NSForegroundColorAttributeName, nil];

    
    
    
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
            CGRect rectangle = CGRectMake(20 + x * 95, 20 + y * 95, 95, 95);
            NSRectFill( rectangle);
        }
        flip = !flip;
    }

    for(int i =0; i < 8;i++){
        char c = (char) i + 65;
        NSString *s = [NSString stringWithFormat:@"%c", c];
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:s attributes: attributes];
        NSSize attrSize = [currentText size];
        [currentText drawAtPoint:NSMakePoint(59+i*95  , 0)];
        [currentText drawAtPoint:NSMakePoint(59+i*95  , 780)];
    }
    for(int i =0; i < 8;i++){
        char c = (char) i + 49;
        NSString *s = [NSString stringWithFormat:@"%c", c];
        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:s attributes: attributes];
        NSSize attrSize = [currentText size];
        [currentText drawAtPoint:NSMakePoint(5, 59+i*95)];
        [currentText drawAtPoint:NSMakePoint(785,59+i*95 )];
    }

    
    NSImage *bSpringer = [NSImage imageNamed:@"Chess_blt60"];
    bSpringer = [self imageResize:bSpringer newSize:NSMakeSize(90,90)];
    [bSpringer drawAtPoint:NSMakePoint(115,20) fromRect:CGRectMake(0, 0, 90, 90) operation:NSCompositeSourceOver fraction:1.0];
    
    

    // Drawing code here.
}

@end
