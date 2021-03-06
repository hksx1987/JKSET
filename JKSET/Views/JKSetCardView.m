//
//  JKSetCardView.m
//  JKSET
//
//  Created by Jack Huang on 15/7/13.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSetCardView.h"
#import "JKCalculations.h"
#import "SETCard.h"

@interface JKSetCardView()
@end

@implementation JKSetCardView

static CGRect the_mid_rect; // the center rect for only one symbol
static CGRect two_left_rect; // the left rect for one of two symbols
static CGRect two_right_rect; // the right rect for another of two symbols
static CGRect three_left_rect; // ...
static CGRect three_right_rect; // ...

- (instancetype)initWithFrame:(CGRect)frame cornerColor:(UIColor *)cornerColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = cornerColor;
        [self initializeView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    [NSException raise:NSGenericException format:@"MUST use designated initializer!"];
    return nil;
}

- (instancetype)init
{
    [NSException raise:NSGenericException format:@"MUST use designated initializer!"];
    return nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeView];
}

- (void)initializeView
{
    self.contentMode = UIViewContentModeRedraw;
    
    // These transparent background effect can fix the card's corner color,
    // but transparency will always cause the performance hit, which can be
    // detected by using Core Animation Instrument.
    
    // either do this
//    self.opaque = NO;
//    self.backgroundColor = nil;
    // or this
//    self.backgroundColor = [UIColor clearColor];
    
    // The alternative solution is setting backgroundColor to match the
    // game table color directly from designated initializer. It is faster.
    
    // The only problem now is the outter dark line near the card's corner
    // if you look closely. I believe this is happened by not covering the
    // background completely. Any other elegant solution for this? One of
    // my solution is to draw an extra line of the card rect with background
    // color to cover this, but I didn't show it here.
}

- (void)setSymbol:(SETSymbol)symbol color:(SETColor)color number:(SETNumber)number shading:(SETShading)shading
{
    self.symbol = symbol;
    self.color = color;
    self.number = number;
    self.shading = shading;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat card_width = CGRectGetWidth(self.bounds);
    CGFloat card_height = CGRectGetHeight(self.bounds);
    CGPoint card_center = CGPointMake(card_width/2.0, card_height/2.0); // it is not equal to self.center!
    
    // Time saving by not computing the same value repeatly.
    if (CGRectIsEmpty(the_mid_rect))
        the_mid_rect = [self symbolRactAtCenter:card_center];
    if (CGRectIsEmpty(two_left_rect))
        two_left_rect = [self symbolRactAtCenter:CGPointMake(card_width/3.0, card_center.y)];
    if (CGRectIsEmpty(two_right_rect))
        two_right_rect = [self symbolRactAtCenter:CGPointMake(card_width*2.0/3.0, card_center.y)];
    if (CGRectIsEmpty(three_left_rect))
        three_left_rect = [self symbolRactAtCenter:CGPointMake(card_width/4.0, card_center.y)];
    if (CGRectIsEmpty(three_right_rect))
        three_right_rect = [self symbolRactAtCenter:CGPointMake(card_width*3.0/4.0, card_center.y)];
}

- (void)drawRect:(CGRect)rect
{
    // card background
    [[UIColor whiteColor] setFill];
    
    // card rounded corner
    CGFloat cornerRadius = cornerRadiusForRect(rect);
    UIBezierPath *cardPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [cardPath addClip];
    [cardPath fill];
    
    // check if it has a zero value, if has,
    // then draw a blank card with "?" mark
    if ([self isIncompleteComponents]) {
        [self drawBlankCardInRect:rect];
        return;
    }
    
    // set symbol color for both -stroke and -fill
    UIColor *symbolColor = [self symbolColor];
    [symbolColor set];
    
    // set all small rects to draw symbol
    NSArray *symbolRects = [self symbolRects];
    if (!symbolRects) {
        return;
    }
    
    // draw symbol in each small rect
    for (NSValue *rectObj in symbolRects) {
        CGRect rectValue = [rectObj CGRectValue];
        UIBezierPath *symbolPath = [self symbolPathInRect:rectValue];
        symbolPath.lineWidth = 1.5;
        [self drawSymbolPath:symbolPath inRect:rectValue];
    }
}

#pragma mark - helper

// return a rect which contains a single symbol pattern
// to draw inside of card. For this demo, there can be
// 5 rects depends on the center parameter
- (CGRect)symbolRactAtCenter:(CGPoint)center
{
    CGFloat card_width = CGRectGetWidth(self.bounds);
    CGFloat card_height = CGRectGetHeight(self.bounds);
    
    CGFloat symbol_width = card_width / 4.5;
    CGFloat symbol_height = card_height * 0.8;
    
    return CGRectMake(center.x - symbol_width/2.0, center.y - symbol_height/2.0, symbol_width, symbol_height);
}

- (UIColor *)symbolColor
{
    UIColor *symbolColor = nil;
    
    if (self.color == SETFirstValue) {
        symbolColor = [self firstSymbolColor];
    } else if (self.color == SETSecondValue) {
        symbolColor = [self secondSymbolColor];
    } else if (self.color == SETThirdValue) {
        symbolColor = [self thirdSymbolColor];
    }
    
    return symbolColor;
}

- (UIBezierPath *)symbolPathInRect:(CGRect)rect
{
    UIBezierPath *symbolPath = nil;
    
    if (self.symbol == SETFirstValue) {
        symbolPath = [self firstSymbolPathInRect:rect];
    } else if (self.symbol == SETSecondValue) {
        symbolPath = [self secondSymbolPathInRect:rect];
    } else if (self.symbol == SETThirdValue) {
        symbolPath = [self thirdSymbolPathInRect:rect];
    }
    
    return symbolPath;
}

// create several rects for drawing symbol
// it depends on the number value
- (NSArray *)symbolRects
{
    NSArray *symbolRects = nil;
    
    if (self.number == SETFirstValue) {
        symbolRects = @[[NSValue valueWithCGRect:the_mid_rect]];
    } else if (self.number == SETSecondValue) {
        symbolRects = @[[NSValue valueWithCGRect:two_left_rect],
                        [NSValue valueWithCGRect:two_right_rect]];
    } else if (self.number == SETThirdValue) {
        symbolRects = @[[NSValue valueWithCGRect:three_left_rect],
                        [NSValue valueWithCGRect:the_mid_rect],
                        [NSValue valueWithCGRect:three_right_rect]];
    }
    
    return symbolRects;
}

// draw symbol with different effects which depended on the shading value
// there are 3 effects: outlined(stroke), solid(filled), striped
- (void)drawSymbolPath:(UIBezierPath *)symbolPath inRect:(CGRect)rect
{
    if (self.shading == SETFirstValue) {
        [symbolPath stroke];
    } else if (self.shading == SETSecondValue) {
        [symbolPath fill];
    } else if (self.shading == SETThirdValue) {
        // make stripe effect
        CGContextRef context = UIGraphicsGetCurrentContext();
        [symbolPath stroke];
        CGContextSaveGState(context);
        [symbolPath addClip];
        
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        CGFloat space = 5.5;
        CGFloat increment = space;
        while (increment < CGRectGetHeight(rect)) {
            CGPoint leftEdge = CGPointMake(rect.origin.x, rect.origin.y + increment);
            CGPoint rightEdge = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + increment);
            [stripes moveToPoint:leftEdge];
            [stripes addLineToPoint:rightEdge];
            increment += space;
        }
        
        [stripes stroke];
        [symbolPath appendPath:stripes];
        CGContextRestoreGState(context);
    }
}

- (BOOL)isIncompleteComponents
{
    return self.color == SETNoneValue || self.symbol == SETNoneValue ||
    self.number == SETNoneValue || self.shading == SETNoneValue;
}

- (void)drawBlankCardInRect:(CGRect)rect
{
    CGFloat fontSize = CGRectGetWidth(rect) / 3.0;
    NSDictionary *dict = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:fontSize] };
    NSAttributedString *qMark = [[NSAttributedString alloc] initWithString:@"?" attributes:dict];
    CGSize qSize = [qMark size];
    CGRect qRect = CGRectMake((CGRectGetWidth(rect)-qSize.width)/2.0, (CGRectGetHeight(rect)-qSize.height)/2.0, qSize.width, qSize.height);
    [qMark drawInRect:qRect];
    [qMark release];
}

#pragma mark - abstract implementing

// subclass MUST override these
- (UIColor *)firstSymbolColor { [self warn]; return nil; }
- (UIColor *)secondSymbolColor { [self warn]; return nil; }
- (UIColor *)thirdSymbolColor { [self warn]; return nil; }

// and these
- (UIBezierPath *)firstSymbolPathInRect:(CGRect)rect { [self warn]; return nil; }
- (UIBezierPath *)secondSymbolPathInRect:(CGRect)rect { [self warn]; return nil; }
- (UIBezierPath *)thirdSymbolPathInRect:(CGRect)rect { [self warn]; return nil; }

- (void)warn
{
    [NSException raise:NSGenericException format:@"MUST override required method by subclass of JKSetCardView"];
}

@end


