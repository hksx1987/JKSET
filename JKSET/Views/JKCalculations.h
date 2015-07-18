//
//  JKCalculations.h
//  JKSET
//
//  Created by Jack Huang on 15/7/15.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <UIKit/UIGeometry.h>


CGFloat cornerRadiusForRect(CGRect rect);

CGFloat cellWidthInRect(CGRect containerBounds, NSUInteger numberOfCellsInLine, CGFloat padding);

CGSize defaultCellSizeInRect(CGRect containerBounds);