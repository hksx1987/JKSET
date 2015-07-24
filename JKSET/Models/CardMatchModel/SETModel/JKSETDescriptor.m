//
//  JKSETDescriptor.m
//  JKSET
//
//  Created by Jack Huang on 15/7/24.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETDescriptor.h"

@implementation JKSETDescriptor

+ (NSString *)missMatchDescriptionForSymbol:(BOOL)missMatchedSymbol
                                      color:(BOOL)missMatchedColor
                                     number:(BOOL)missMatchedNumber
                                    shading:(BOOL)missMatchedShading
{
    NSMutableString *result = [NSMutableString string];
    
    if (missMatchedSymbol) {
        [result appendString:NSLocalizedString(@"Localized_Symbol", @"Symbol Match failed prefix message.")];
    }
    if (missMatchedColor) {
        [result appendString:NSLocalizedString(@"Localized_Color", @"Color Match failed prefix message.")];
    }
    if (missMatchedNumber) {
        [result appendString:NSLocalizedString(@"Localized_Number", @"Number Match failed prefix message.")];
    }
    if (missMatchedShading) {
        [result appendString:NSLocalizedString(@"Localized_Shading", @"Shading Match failed prefix message.")];
    }
    [result appendString:NSLocalizedString(@"Localized_match_failed_msg", @"Match failed suffix message.")];
    
    return [[result copy] autorelease];
}

+ (NSString *)possibleSETsDescription:(NSUInteger)numberOfPossibleSETs
{
    return [NSString stringWithFormat:NSLocalizedString(@"Remains: %lu combinations", @"Showing { number } of possible SETs"), (unsigned long)numberOfPossibleSETs];
}

@end
