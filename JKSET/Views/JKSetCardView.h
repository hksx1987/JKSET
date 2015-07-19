//
//  JKSetCardView.h
//  JKSET
//
//  Created by Jack Huang on 15/7/13.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SETCard;

/* Abstract class */
@interface JKSetCardView : UIView

/*! Set card for JKSetCardView after the view initialized.
 *  color       three different color for displayed symbols (determined by subclass)
 *  symbol      three kind of different shapes for displayed symbols (determined by subclass)
 *  number      the number of symbols: one symbol, two symbols, three symbols (fixed)
 *  shading     this is how symbol looks - 1: outlined, 2: solid, 3: striped (fixed)
 */
@property (nonatomic, retain) SETCard *card;

/*!
 * Designated Initializer
 * \param frame The frame rectangle for the view, measured in points.
 * \param cornerColor Set whatever game table background color to compensate the empty corner.
 * \returns An initialized JKSetCardView object or nil if the object couldn't be created.
 */
- (instancetype)initWithFrame:(CGRect)frame cornerColor:(UIColor *)cornerColor;


// subclass MUST override these
- (UIColor *)firstSymbolColor;
- (UIColor *)secondSymbolColor;
- (UIColor *)thirdSymbolColor;

// and these
- (UIBezierPath *)firstSymbolPathInRect:(CGRect)rect;
- (UIBezierPath *)secondSymbolPathInRect:(CGRect)rect;
- (UIBezierPath *)thirdSymbolPathInRect:(CGRect)rect;


@end
