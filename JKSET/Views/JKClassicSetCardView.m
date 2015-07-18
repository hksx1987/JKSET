//
//  JKClassicSetCardView.m
//  JKSET
//
//  Created by Jack Huang on 15/7/14.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKClassicSetCardView.h"
#import "JKCalculations.h"

@implementation JKClassicSetCardView

- (UIColor *)firstSymbolColor
{
    return [UIColor colorWithRed:215.0/255.0 green:0.0 blue:64.0/255.0 alpha:1.0]; // Carmine (red)
}

- (UIColor *)secondSymbolColor
{
    return [UIColor colorWithRed:50.0/255.0 green:205.0/255.0 blue:50.0/255.0 alpha:1.0]; // limeGreen
}

- (UIColor *)thirdSymbolColor
{
    return [UIColor colorWithRed:126.0/255.0 green:73.0/255.0 blue:133.0/255.0 alpha:1.0]; // Amethyst (purple)
}

// draw a diamond
- (UIBezierPath *)firstSymbolPathInRect:(CGRect)rect
{
    CGPoint origin = rect.origin;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGPoint top = CGPointMake(origin.x + width / 2.0, origin.y);
    CGPoint left = CGPointMake(origin.x, origin.y + height / 2.0);
    CGPoint buttom = CGPointMake(top.x, top.y + height);
    CGPoint right = CGPointMake(left.x + width, left.y);
    
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    [diamond moveToPoint:top];
    [diamond addLineToPoint:left];
    [diamond addLineToPoint:buttom];
    [diamond addLineToPoint:right];
    [diamond closePath];
    
    return diamond;
}

// draw a squiggle
- (UIBezierPath *)secondSymbolPathInRect:(CGRect)rect
{
    UIBezierPath *squiggle = [UIBezierPath bezierPath];
    
    CGPoint o = rect.origin; // origin
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat s = w / 10.0; // space
    
    CGPoint ul = o; // upper left point
    
    CGPoint start = CGPointMake(ul.x + s, ul.y + s * 2.0);
    CGPoint turn = CGPointMake(ul.x + s, ul.y);
    CGPoint cp1 = CGPointMake(ul.x + w * 1.6, ul.y); // control point
    CGPoint cp2 = CGPointMake(ul.x + w * 0.6, ul.y + h * 0.6);
    CGPoint end = CGPointMake(ul.x + w - s, ul.y + h - s * 2.0);
    
    [squiggle moveToPoint:start];
    [squiggle addQuadCurveToPoint:turn controlPoint:ul];
    [squiggle addCurveToPoint:end controlPoint1:cp1 controlPoint2:cp2];
    
    // reverse
    CGPoint br = CGPointMake(o.x + w, o.y + h); // buttom right point

    CGPoint rt = CGPointMake(br.x - turn.x + o.x, br.y - turn.y + o.y);
    CGPoint rcp1 = CGPointMake(br.x - cp1.x + o.x, br.y - cp1.y + o.y);
    CGPoint rcp2 = CGPointMake(br.x - cp2.x + o.x, br.y - cp2.y + o.y);
    
    [squiggle addQuadCurveToPoint:rt controlPoint:br];
    [squiggle addCurveToPoint:start controlPoint1:rcp1 controlPoint2:rcp2];
    
    return squiggle;
}

// draw an oval
- (UIBezierPath *)thirdSymbolPathInRect:(CGRect)rect
{
    CGFloat cornerRadius = cornerRadiusForRect(rect) * 40;
    return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
}

//- (void)dealloc
//{
//    NSLog(@"JKClassicSetCardView dealloc");
//    [super dealloc];
//}

@end

