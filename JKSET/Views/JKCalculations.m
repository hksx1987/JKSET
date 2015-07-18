//
//  JKRectCornerCalculation.m
//  JKSET
//
//  Created by Jack Huang on 15/7/15.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKCalculations.h"

CGFloat cornerRadiusForRect(CGRect rect)
{
    return CGRectGetHeight(rect) / 180.0 * 18.0;
}


CGFloat cellWidthInRect(CGRect containerBounds, NSUInteger numberOfCellsInLine, CGFloat padding)
{
    CGFloat n = (CGFloat)numberOfCellsInLine;
    return CGRectGetWidth(containerBounds) / n - padding * (n + 1) / n;
}


CGSize defaultCellSizeInRect(CGRect containerBounds)
{
    CGFloat numberOfCellsInLine = 3.0;
    CGFloat padding = 10.0;
    CGFloat cellWidth = cellWidthInRect(containerBounds, numberOfCellsInLine, padding);
    CGFloat cellHeight = cellWidth * 0.7;
    return CGSizeMake(cellWidth-0.5, cellHeight);
}