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

NSString * const JKCardMatchingGameBrainMissMatchSymbolValueKey = @"JKCardMatchingGameBrainMissMatchSymbolValueKey";
NSString * const JKCardMatchingGameBrainMissMatchColorValueKey = @"JKCardMatchingGameBrainMissMatchColorValueKey";
NSString * const JKCardMatchingGameBrainMissMatchNumberValueKey = @"JKCardMatchingGameBrainMissMatchNumberValueKey";
NSString * const JKCardMatchingGameBrainMissMatchShadingValueKey = @"JKCardMatchingGameBrainMissMatchShadingValueKey";

@implementation JKSETBrain
{
    BOOL _isSETCTypeSetup;
    BOOL _gameShouldEnd;
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
            
            // handle results first
            if (completion) {
                completion(getPossibleSETsCount);
            }
            
            // then handle ending
            if (!getPossibleSETsCount) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JKCardMatchingGameBrainDidEndGameNotification
                                                                    object:self
                                                                  userInfo:nil];
            }
        });
    }
}

// The card object in rendomSET array does not have to be the identical card from gameBrain.cards' array
// because the logic is comparing the card's values rather than it's reference.
- (NSArray *)randomSET
{
    CTSETCombination comb = CTGetRandomCombination();
    
    NSMutableArray *randomSET = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3; ++i) {
        CTSETCard ct_card = comb.cards[i];
        SETCard *randomCard = [[SETCard alloc] initWithSymbol:ct_card.symbol color:ct_card.color number:ct_card.number shading:ct_card.shading];
        [randomSET addObject:randomCard];
        [randomCard release];
    }
    
    return [[randomSET copy] autorelease];
}

// override
- (void)chooseCard:(SETCard *)card
{
    if (!card.isMatched) {
        if (card.isChosen) {
            card.isChosen = NO;
            if ([self.chosenCards containsObject: card]) {
                [self.chosenCards removeObject: card];
            }
        } else {
            card.isChosen = YES;
            
            if (self.chosenCards.count < self.matchCount-1) {
                if (![self.chosenCards containsObject:card]) {
                    [self.chosenCards addObject: card];
                }
            } else {
                /* try a match */
                BOOL isSymbolMatched, isColorMatched, isNumberMatched, isShadingMatched;
                
                /* match failed */
                if (![card match:self.chosenCards
                     symbolMatch:&isSymbolMatched
                      colorMatch:&isColorMatched
                     numberMatch:&isNumberMatched
                    shadingMatch:&isShadingMatched]) {
                    
                    NSLog(@"match failed");
                    NSMutableArray *failedCards = [NSMutableArray arrayWithArray:self.chosenCards];
                    [failedCards addObject:card];
                    
                    for (Card *card in failedCards) {
                        card.isChosen = NO;
                    }
                    
                    // post notification
                    NSDictionary *userInfo = @{ JKCardMatchingGameBrainComparedCardsKey : [[failedCards copy] autorelease],
                                                JKCardMatchingGameBrainMissMatchSymbolValueKey : @(!isSymbolMatched),
                                                JKCardMatchingGameBrainMissMatchColorValueKey : @(!isColorMatched),
                                                JKCardMatchingGameBrainMissMatchNumberValueKey : @(!isNumberMatched),
                                                JKCardMatchingGameBrainMissMatchShadingValueKey : @(!isShadingMatched) };
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:JKCardMatchingGameBrainDidMissMatchNotification
                                                                        object:self userInfo:userInfo];
                    
                    [self.chosenCards removeAllObjects];
                }
                /* found a match */
                else {
                    NSLog(@"Find a match!");
                    
                    NSMutableArray *matchedCards = [NSMutableArray arrayWithArray:self.chosenCards];
                    [matchedCards addObject:card];
                    
                    for (Card *card in matchedCards) {
                        card.isMatched = YES;
                    }
                    
                    // post notification
                    NSDictionary *userInfo = @{ JKCardMatchingGameBrainComparedCardsKey : [[matchedCards copy] autorelease] };
                    [[NSNotificationCenter defaultCenter] postNotificationName:JKCardMatchingGameBrainDidFindMatchNotification
                                                                        object:self userInfo:userInfo];
                    
                    [self.chosenCards removeAllObjects];
                }
            }
        }
    }
}

- (void)didOutOfCards
{
    // make empty implementation, so super class will not post didEndGame notification.
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



