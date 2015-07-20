//
//  SETCard.m
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "SETCard.h"

@interface SETCard ()
@end

bool matchValue(char v1, char v2, char v3);

@implementation SETCard

- (instancetype)initWithSymbol:(SETSymbol)symbol
                         color:(SETColor)color
                        number:(SETNumber)number
                       shading:(SETShading)shading
{
    self = [super init];
    if (self) {
        _symbol = symbol;
        _color = color;
        _number = number;
        _shading = shading;
    }
    return self;
}

- (instancetype)initWithBlankCard
{
    return [self initWithSymbol:SETNoneValue color:SETNoneValue number:SETNoneValue shading:SETNoneValue];
}

/* override */
- (NSInteger)match:(NSArray *)cards
{
    return [self match:cards symbolMatch:NULL colorMatch:NULL numberMatch:NULL shadingMatch:NULL];
}

- (NSInteger)match:(NSArray *)cards
       symbolMatch:(BOOL *)symbolMatch
        colorMatch:(BOOL *)colorMatch
       numberMatch:(BOOL *)numberMatch
      shadingMatch:(BOOL *)shadingMatch
{
    if (cards.count == 2 && [cards[0] isKindOfClass: [self class]])
    {
        for (SETCard *c in cards) {
            if ([c isIncompleteCard]) {
                return 0;
            }
        }
        if ([self isIncompleteCard]) {
            return 0;
        }
        
        SETCard *c1 = [cards firstObject];
        SETCard *c2 = [cards lastObject];
        
        bool isSymbolMatched = matchValue(self.symbol, c1.symbol, c2.symbol);
        bool isColorMatched = matchValue(self.color, c1.color, c2.color);
        bool isNumberMatched = matchValue(self.number, c1.number, c2.number);
        bool isShadingMatched = matchValue(self.shading, c1.shading, c2.shading);
        
        if (symbolMatch) *symbolMatch = (BOOL)isSymbolMatched;
        if (colorMatch) *colorMatch = (BOOL)isColorMatched;
        if (numberMatch) *numberMatch = (BOOL)isNumberMatched;
        if (shadingMatch) *shadingMatch = (BOOL)isShadingMatched;
        
        if (isSymbolMatched && isColorMatched && isNumberMatched && isShadingMatched) {
            return 100;
        }
    }
    return 0;
}

/* override */
- (NSString *)description
{
    return [NSString stringWithFormat: @"SETCard: sym_%d_col_%d_num_%d_sha_%d", self.symbol, self.color, self.number, self.shading];
}

/* override */
- (BOOL)isEqual:(SETCard *)card
{
    return self.color == card.color && self.symbol == card.symbol && self.number == card.number && self.shading == card.shading;
}

- (BOOL)isIncompleteCard
{
    return self.color == SETNoneValue || self.symbol == SETNoneValue || self.number == SETNoneValue || self.shading == SETNoneValue;
}

// This debugDescription will print out the classic SET card description,
// which should be the subclass's responsibility. I just don't feel like to
// make a subclass again to handle this.
- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"SETCard(%@_%@_%@_%@)", [self defaultNumberDescription], [self defaultShadingDescription], [self defaultColorDescription], [self defaultSymbolDescription]];
}

#pragma mark - helper

- (NSString *)defaultSymbolDescription
{
    switch (self.symbol) {
        case SETFirstValue:
            return @"diamond";
        case SETSecondValue:
            return @"squiggle";
        case SETThirdValue:
            return @"oval";
        case SETNoneValue:
            return @"?";
    }
}

- (NSString *)defaultColorDescription
{
    switch (self.color) {
        case SETFirstValue:
            return @"red";
        case SETSecondValue:
            return @"green";
        case SETThirdValue:
            return @"purple";
        case SETNoneValue:
            return @"?";
    }
}

- (NSString *)defaultNumberDescription
{
    switch (self.number) {
        case SETFirstValue:
            return @"One";
        case SETSecondValue:
            return @"Two";
        case SETThirdValue:
            return @"Three";
        case SETNoneValue:
            return @"?";
    }
}

- (NSString *)defaultShadingDescription
{
    switch (self.shading) {
        case SETFirstValue:
            return @"outlined";
        case SETSecondValue:
            return @"solid";
        case SETThirdValue:
            return @"striped";
        case SETNoneValue:
            return @"?";
    }
}

@end

bool matchValue(char v1, char v2, char v3)
{
    if (v1 == v2 && v1 == v3 && v2 == v3) {
        return true;
    } else if (v1 != v2 && v2 != v3 && v1 != v3) {
        return true;
    } else {
        return false;
    }
}




