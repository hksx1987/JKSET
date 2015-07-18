//
//  SETCard.h
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "Card.h"
#import "SETCardComponents.h"

@interface SETCard : Card

@property (nonatomic) SETSymbol symbol;
@property (nonatomic) SETColor color;
@property (nonatomic) SETNumber number;
@property (nonatomic) SETShading shading;

/* designated initializer */
- (instancetype)initWithSymbol:(SETSymbol)symbol
                         color:(SETColor)color
                        number:(SETNumber)number
                       shading:(SETShading)shading;

- (instancetype)initWithBlankCard;

// It is the match method specific for SET, which contains
// the match result for each component.
- (NSInteger)match:(NSArray *)cards
       symbolMatch:(BOOL *)symbolMatch
        colorMatch:(BOOL *)colorMatch
       numberMatch:(BOOL *)numberMatch
      shadingMatch:(BOOL *)shadingMatch;

@end
