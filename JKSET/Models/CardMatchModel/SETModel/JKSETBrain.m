//
//  JKSETBrain.m
//  JKSET
//
//  Created by Jack Huang on 15/7/20.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETBrain.h"
#import "SETCard.h"
#include "JKSETCType.h"

@interface JKSETBrain()
@end

@implementation JKSETBrain
{
    BOOL _isSETCTypeSetup;
}

- (void)setupNewCalculationStatus
{
    CTSetupInitialCalculationStatus();
}

- (NSUInteger)maxNumberOfAllPossibleSETs
{
    return CT_POSSIBLE_SETS_MAX;
}

- (void)findAllPossibleSETsWithCompletion:(void(^)(NSUInteger numberOfAllPossibleSETs))completion
{
    if (!_isSETCTypeSetup) {
        _isSETCTypeSetup = YES;
        
        CTSetupWithCompletion(NULL);
        
        if (completion) {
            completion(CT_POSSIBLE_SETS_MAX);
        }
        
    } else {
        
        NSArray *removedCards = [self lastRemovedCards];
        CTSETCombination comb;
        
        int i = 0;
        for (SETCard *card in removedCards) {
            CTSETCard ct_card = CTSETCardMake(card.symbol, card.color, card.number, card.shading);
            comb.cards[i] = ct_card;
            ++i;
        }
        
        CTRemoveCombination(comb, ^(int getPossibleSETsCount) {
            
            if (!getPossibleSETsCount) {
                [self.delegate cardMatchingGameBrainDidEndGame:self];
            }
            
            if (completion) {
                completion(getPossibleSETsCount);
            }
        });
    }
}

- (NSArray *)randomSET
{
    CTSETCombination comb = CTGetRandomCombination();
    
    // Here I switch back to get original SET cards instead of new cards,
    // because they have exact same value, so it is easy to track.
    // This step is important because a lot of other changes are related to
    // the original cards.
    NSMutableArray *originalRandomSET = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3; ++i) {
        CTSETCard ct_card = comb.cards[i];
        SETCard *newCard = [[SETCard alloc] initWithSymbol:ct_card.symbol color:ct_card.color number:ct_card.number shading:ct_card.shading];
        
        NSUInteger i = [self indexOfCard:newCard];
        Card *originalCard = [self cardAtIndex:i];
        [originalRandomSET addObject:originalCard];
        [newCard release];
    }
    
    return [[originalRandomSET copy] autorelease];
}

@end

// Using NSSet approach (simple to write, but slow and inefficient for large data here)

//        NSMutableSet sets = [NSMutableSet set];
//        for (i = 0; i < count; ++i) {
//            SETCard *c1 = cards[i];
//
//            for (j = 0; j < count; ++j) {
//                SETCard *c2 = cards[j];
//
//                if (c1 != c2) {
//
//                    SETCard *sc = [_trainer suggestedCardForCards:@[c1, c2]];
//
//                    for (m = j; m < count; ++m) {
//                        SETCard *c3 = cards[m];
//
//                        if (c3 != c1 && c3 != c2) {
//                            if ([sc isEqual:c3]) {
//                                NSSet *set = [NSSet setWithObjects:@(i), @(j), @(m), nil];
//                                [sets addObject:set];
//                                break;
//                            }
//                        }
//                    }
//                }
//            }
//        }



