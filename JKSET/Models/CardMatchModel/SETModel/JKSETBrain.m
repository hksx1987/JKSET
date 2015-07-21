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

#define SET_CARDS_MAX 81

@interface JKSETBrain()
@property (nonatomic, copy) NSArray *possibleSETs;
@end

@implementation JKSETBrain
{
    TheSETCard theCards[SET_CARDS_MAX];
    NSUInteger _numberOfAllPossibleSETs;
}

- (instancetype)initWithDeck:(Deck *)deck displayCount:(NSUInteger)count requiredMatchCount:(NSUInteger)matchCount
{
    self = [super initWithDeck:deck displayCount:count requiredMatchCount:matchCount];
    if (self) {
        _possibleSETs = [[NSArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_possibleSETs release];
    [super dealloc];
}

- (void)findAllPossibleSETsWithCompletion:(void(^)(NSUInteger numberOfAllPossibleSETs))completion
{
    dispatch_queue_t calculationQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(calculationQueue, ^{
        
        NSArray *cards = self.displayedCards;
        NSUInteger count = cards.count;
        NSUInteger i, j, m, n = 0, x;
        
        removeCombinationsAmountOf(_numberOfAllPossibleSETs);
        
        // convert NSArray to C array
        // convert SETCard class to TheSETCard struct
        // for performance, only reset first amount of C array, same work for combs
        for (x = 0; x < count; ++x) {
            SETCard *card = cards[x];
            TheSETCard theCard = TheSETCardMake(card.symbol, card.color, card.number, card.shading);
            theCards[x] = theCard;
        }
        
        for (i = 0; i < count; ++i) {
            TheSETCard c1 = theCards[i];
            
            for (j = 0; j < count; ++j) {
                if (j != i) {
                    TheSETCard c2 = theCards[j];
                    TheSETCard sc = suggestSETCard(c1, c2);
                    
                    for (m = j+1; m < count; ++m) {
                        TheSETCard c3 = theCards[m];
                        
                        if (TheSETCardIsEqualToTheSETCard(sc, c3)) {
                            Combination comb = CombinationMake(c1, c2, c3);
                            if (!containsCombination(comb, n)) {
                                combs[n] = comb;
                                ++n;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        _numberOfAllPossibleSETs = n;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!_numberOfAllPossibleSETs) {
                [self.delegate cardMatchingGameBrainDidEndGame:self];
            }
            
            if (completion) {
                completion(_numberOfAllPossibleSETs);
            }
        });
    });
}

- (NSArray *)randomSET
{
    NSUInteger randomIndex = arc4random_uniform(_numberOfAllPossibleSETs);
    Combination comb = combs[randomIndex];
    
    if (TheSETCardIsZero(comb.firstCard)) {
        return nil;
    }
    
    SETCard *firstCard = [[SETCard alloc] initWithSymbol:comb.firstCard.symbol
                                                   color:comb.firstCard.color
                                                  number:comb.firstCard.number
                                                 shading:comb.firstCard.shading];
    SETCard *secondCard = [[SETCard alloc] initWithSymbol:comb.secondCard.symbol
                                                   color:comb.secondCard.color
                                                  number:comb.secondCard.number
                                                 shading:comb.secondCard.shading];
    SETCard *thirdCard = [[SETCard alloc] initWithSymbol:comb.thirdCard.symbol
                                                   color:comb.thirdCard.color
                                                  number:comb.thirdCard.number
                                                 shading:comb.thirdCard.shading];
    
    NSArray *newRandomSET = @[firstCard, secondCard, thirdCard];
    
    [firstCard release];
    [secondCard release];
    [thirdCard release];
    
    // Here I switch back to get original SET cards instead of new cards,
    // because they have exact same value, so it is easy to track.
    // This step is important because a lot of other changes are related to
    // the original cards.
    NSMutableArray *originalRandomSET = [NSMutableArray arrayWithCapacity:3];
    for (SETCard *newCard in newRandomSET) {
        NSUInteger i = [self indexOfCard:newCard];
        Card *originalCard = [self cardAtIndex:i];
        [originalRandomSET addObject:originalCard];
    }
    
    return [[originalRandomSET copy] autorelease];
}

@end

// Using NSSet approach

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



