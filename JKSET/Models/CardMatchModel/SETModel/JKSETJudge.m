//
//  JKSETJudge.m
//  JKSET
//
//  Created by Jack Huang on 15/7/17.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETJudge.h"
#import "SETCard.h"

@interface JKSETJudge()
@property (nonatomic, retain) NSMutableArray *chosenCards;
@end

@implementation JKSETJudge

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chosenCards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"JKSETJudge deallocated");
    [_chosenCards release];
    [super dealloc];
}

- (BOOL)chooseCard:(SETCard *)card
{
    // cancel selection
    if ([self.chosenCards containsObject:card]) {
        [self.chosenCards removeObject:card];
        return NO;
    } else {
        // select new card, and not enough for a match
        if (self.chosenCards.count < 2) {
            if (![self.chosenCards containsObject:card]) {
                [self.chosenCards addObject:card];
                return NO;
            }
        }
    }
    
    BOOL isSymbolMatched, isColorMatched, isNumberMatched, isShadingMatched;
    
    if (![card match:self.chosenCards
        symbolMatch:&isSymbolMatched
         colorMatch:&isColorMatched
        numberMatch:&isNumberMatched
       shadingMatch:&isShadingMatched]) {
        
        NSMutableString *result = [NSMutableString string];
        if (!isSymbolMatched) {
            [result appendString:NSLocalizedString(@"Localized_Symbol", @"Symbol Match failed prefix message.")];
        }
        if (!isColorMatched) {
            [result appendString:NSLocalizedString(@"Localized_Color", @"Color Match failed prefix message.")];
        }
        if (!isNumberMatched) {
            [result appendString:NSLocalizedString(@"Localized_Number", @"Number Match failed prefix message.")];
        }
        if (!isShadingMatched) {
            [result appendString:NSLocalizedString(@"Localized_Shading", @"Shading Match failed prefix message.")];
        }
        [result appendString:NSLocalizedString(@"Localized_match_failed_msg", @"Match failed suffix message.")];
        
        [self.chosenCards removeAllObjects];
        [self.delegate judge:self didReceiveMatchFailureDescription:[[result copy] autorelease]];
        return NO;
    } else {
        [self.chosenCards removeAllObjects];
        return YES;
    }
}

- (void)unchooseCard:(SETCard *)card
{
    [self chooseCard:card];
}

- (void)cleanAllSelections
{
    [self.chosenCards removeAllObjects];
}

@end
