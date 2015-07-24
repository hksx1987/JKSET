//
//  JKSetCardView.h
//  JKSET
//
//  Created by Jack Huang on 15/7/13.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SETCardComponents.h"
@class SETCard;

/* Abstract class */
@interface JKSetCardView : UIView

/*!
 * Designated Initializer
 * \param frame The frame rectangle for the view, measured in points.
 * \param cornerColor Set whatever game table background color to compensate the empty corner.
 * \returns An initialized JKSetCardView object or nil if the object couldn't be created.
 */
- (instancetype)initWithFrame:(CGRect)frame cornerColor:(UIColor *)cornerColor;

@property (nonatomic) SETSymbol symbol;
@property (nonatomic) SETColor color;
@property (nonatomic) SETNumber number;
@property (nonatomic) SETShading shading;

/*! Convenient method to set all values for JKSetCardView and redraw the view, call this after the view is initialized.
 *  \param color       three different color for displayed symbols (determined by subclass)
 *  \param symbol      three kind of different shapes for displayed symbols (determined by subclass)
 *  \param number      the number of symbols: one symbol, two symbols, three symbols (fixed)
 *  \param shading     this is how symbol looks - 1: outlined, 2: solid, 3: striped (fixed)
 */
- (void)setSymbol:(SETSymbol)symbol color:(SETColor)color number:(SETNumber)number shading:(SETShading)shading;


// subclass MUST override these
- (UIColor *)firstSymbolColor;
- (UIColor *)secondSymbolColor;
- (UIColor *)thirdSymbolColor;

// and these
- (UIBezierPath *)firstSymbolPathInRect:(CGRect)rect;
- (UIBezierPath *)secondSymbolPathInRect:(CGRect)rect;
- (UIBezierPath *)thirdSymbolPathInRect:(CGRect)rect;


@end
