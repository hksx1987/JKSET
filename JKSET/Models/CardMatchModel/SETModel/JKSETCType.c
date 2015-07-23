//
//  JKSETCType.c
//  JKSET
//
//  Created by Jack Huang on 15/7/21.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#include "JKSETCType.h"
#include <stdlib.h>
#include <dispatch/dispatch.h>

#define CTSETNoneValue '\x0'
#define CTSETFirstValue '\x01'
#define CTSETSecondValue '\x02'
#define CTSETThirdValue '\x03'

static int ct_numberOfAllPossibleSETs = CT_POSSIBLE_SETS_MAX;
static int ct_swap_index = CT_POSSIBLE_SETS_MAX - 1;

#pragma mark - CT Declairations

void CTSetupAllSETCards();
void CTSetupAllCombinations();
void CTResetStatus();

bool CTSETCardIsBlankCard(CTSETCard card);
bool CTSETCardIsEqualToCard(CTSETCard c1, CTSETCard c2);

CTSETCard CTGetSuggestedSETCardFromCards(CTSETCard card1, CTSETCard card2);
char suggestedRawValue(char v1, char v2);

bool CTSETCombinationsContainsCombinationCards(CTSETCard c1, CTSETCard c2, CTSETCard c3);

void CTSwapCombinationDownFromCurrentIndex(int index, CTSETCard c1, CTSETCard c2, CTSETCard c3);


#pragma mark - C Struct Create

CTSETCard CTSETCardMake(char symbol, char color, char number, char shading)
{
    CTSETCard theCard = { symbol, color, number, shading };
    return theCard;
}

CTSETCard CTSETCardMakeBlankCard()
{
    char zeroValue = CTSETNoneValue;
    CTSETCard theCard = { zeroValue, zeroValue, zeroValue, zeroValue };
    return theCard;
}

CTSETCombination CTSETCombinationMake(CTSETCard c1, CTSETCard c2, CTSETCard c3)
{
    CTSETCombination comb;
    comb.cards[0] = c1;
    comb.cards[1] = c2;
    comb.cards[2] = c3;
    return comb;
}

CTSETCombination CTSETCombinationMakeZero()
{
    CTSETCombination comb;
    comb.cards[0] = CTSETCardMakeBlankCard();
    comb.cards[1] = CTSETCardMakeBlankCard();
    comb.cards[2] = CTSETCardMakeBlankCard();
    return comb;
}

#pragma mark - CT Setup

void CTSetupWithCompletion(ct_completion_block completion)
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        CTSetupAllSETCards();
        CTSetupAllCombinations();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(ct_numberOfAllPossibleSETs);
            }
        });
    });
}

#define CT_SETUP_LOOP(x) x = CTSETFirstValue; x <= CTSETThirdValue; ++x

void CTSetupAllSETCards()
{
    int x = 0;
    char i, j, m, n;
    for (CT_SETUP_LOOP(i)) {
        for (CT_SETUP_LOOP(j)) {
            for (CT_SETUP_LOOP(m)) {
                for (CT_SETUP_LOOP(n)) {
                    CTSETCard card = CTSETCardMake(i, j, m, n);
                    ct_cards[x] = card;
                    ++x;
                }
            }
        }
    }
}

void CTSetupAllCombinations()
{
    int i, j, m, n = 0;
    int maxCount = CT_SET_CARD_COUNT_MAX;
    
    for (i = 0; i < maxCount; ++i) {
        if (n >= CT_POSSIBLE_SETS_MAX) { break; }
        CTSETCard c1 = ct_cards[i];
        
        for (j = 0; j < maxCount; ++j) {
            if (n >= CT_POSSIBLE_SETS_MAX) { break; }
            if (j != i) {
                CTSETCard c2 = ct_cards[j];
                CTSETCard sc = CTGetSuggestedSETCardFromCards(c1, c2);
                
                for (m = j+1; m < maxCount; ++m) {
                    CTSETCard c3 = ct_cards[m];
                    // if sc == c3, then find a combination
                    if (CTSETCardIsEqualToCard(sc, c3)) {
                        // filter the combination if it exists
                        if (!CTSETCombinationsContainsCombinationCards(c1, c2, c3)) {
                            ct_combs[n][0] = c1;
                            ct_combs[n][1] = c2;
                            ct_combs[n][2] = c3;
                            ++n;
                            break;
                        }
                    }
                }
            }
        }
    }
}

void CTSetupInitialCalculationStatus()
{
    ct_numberOfAllPossibleSETs = CT_POSSIBLE_SETS_MAX;
    ct_swap_index = CT_POSSIBLE_SETS_MAX - 1;
}

bool CTSETCombinationStatusIsInitialStatus()
{
    if (ct_numberOfAllPossibleSETs == CT_POSSIBLE_SETS_MAX &&
        ct_swap_index == CT_POSSIBLE_SETS_MAX - 1) {
        return true;
    }
    return false;
}

#pragma mark - calculate combinations

void CTRemoveCombination(CTSETCombination combination, ct_completion_block completion)
{
    CTRemoveCombinationCards(combination.cards[0], combination.cards[1], combination.cards[2], completion);
}

void CTRemoveCombinationCards(CTSETCard c1, CTSETCard c2, CTSETCard c3, ct_completion_block completion)
{
    if (CTSETCardIsBlankCard(c1) ||
        CTSETCardIsBlankCard(c2) ||
        CTSETCardIsBlankCard(c3)) {
        if (completion) {
            completion(ct_numberOfAllPossibleSETs);
        }
        return;
    }
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        int i, j;
        int allSETsCount = ct_numberOfAllPossibleSETs;
        for (i = 0; i < allSETsCount; ++i) {
            if (i > ct_swap_index) { break; } // pretend to over border and swap back! if i == swap_index, then switch itself and move index up!
            for (j = 0; j < 3; ++j) {
                CTSETCard card = ct_combs[i][j];
                if (CTSETCardIsEqualToCard(card, c1) ||
                    CTSETCardIsEqualToCard(card, c2) ||
                    CTSETCardIsEqualToCard(card, c3)) {
                    CTSwapCombinationDownFromCurrentIndex(i, ct_combs[i][0], ct_combs[i][1], ct_combs[i][2]);
                    --i;
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            ct_numberOfAllPossibleSETs = ct_swap_index + 1;
            if (completion) {
                completion(ct_numberOfAllPossibleSETs);
            }
        });
    });
}

void CTGetRandomCombinationCards(CTSETCard *c1, CTSETCard *c2, CTSETCard *c3)
{
    u_int32_t randomIndex = arc4random_uniform(ct_numberOfAllPossibleSETs);
    
    if (c1) *c1 = ct_combs[randomIndex][0];
    if (c2) *c2 = ct_combs[randomIndex][1];
    if (c3) *c3 = ct_combs[randomIndex][2];
    
    if (c1) {
        if (CTSETCardIsBlankCard(*c1)) {
            printf("Error: Return a invalid random combination!\n");
        }
    }
}

CTSETCombination CTGetRandomCombination()
{
    CTSETCard c1, c2, c3;
    CTSETCombination comb;
    
    CTGetRandomCombinationCards(&c1, &c2, &c3);
    comb.cards[0] = c1;
    comb.cards[1] = c2;
    comb.cards[2] = c3;
    
    return comb;
}

#pragma mark - helper

bool CTSETCardIsBlankCard(CTSETCard card) {
    char zeroValue = CTSETNoneValue;
    if (card.symbol == zeroValue && card.color == zeroValue &&
        card.number == zeroValue && card.shading == zeroValue) {
        return true;
    }
    return false;
}

bool CTSETCombinationsContainsCombinationCards(CTSETCard c1, CTSETCard c2, CTSETCard c3)
{
    int maxSETs = CT_POSSIBLE_SETS_MAX;
    for (int i = 0; i < maxSETs; ++i) {
        CTSETCard firstCard = ct_combs[i][0];
        CTSETCard secondCard = ct_combs[i][1];
        CTSETCard thirdCard = ct_combs[i][2];
        
        if (CTSETCardIsBlankCard(firstCard)) {
            return false;
        }
        
        CTSETCard comb[3] = { firstCard, secondCard, thirdCard };
        
        bool matchProgress1 = false;
        bool matchProgress2 = false;
        bool matchProgress3 = false;
        
        for (int j = 0; j < 3; ++j) {
            CTSETCard card = comb[j];
            if (CTSETCardIsEqualToCard(card, c1)) {
                matchProgress1 = true;
            }
            if (CTSETCardIsEqualToCard(card, c2)) {
                matchProgress2 = true;
            }
            if (CTSETCardIsEqualToCard(card, c3)) {
                matchProgress3 = true;
            }
        }
        
        if (matchProgress1 && matchProgress2 && matchProgress3) {
            return true;
        }
    }
    return false;
}

bool CTSETCardIsEqualToCard(CTSETCard c1, CTSETCard c2)
{
    if (c1.symbol == c2.symbol && c1.color == c2.color &&
        c1.number == c2.number && c1.shading == c2.shading) {
        return true;
    }
    return false;
}

CTSETCard CTGetSuggestedSETCardFromCards(CTSETCard card1, CTSETCard card2)
{
    char symbol = suggestedRawValue(card1.symbol, card2.symbol);
    char color = suggestedRawValue(card1.color, card2.color);
    char number = suggestedRawValue(card1.number, card2.number);
    char shading = suggestedRawValue(card1.shading, card2.shading);
    return CTSETCardMake(symbol, color, number, shading);
}

void CTSwapCombinationDownFromCurrentIndex(int index, CTSETCard c1, CTSETCard c2, CTSETCard c3)
{
    // first time will start from bottom
    CTSETCard tempCard1 = ct_combs[ct_swap_index][0];
    CTSETCard tempCard2 = ct_combs[ct_swap_index][1];
    CTSETCard tempCard3 = ct_combs[ct_swap_index][2];
    
    ct_combs[ct_swap_index][0] = c1;
    ct_combs[ct_swap_index][1] = c2;
    ct_combs[ct_swap_index][2] = c3;
    
    ct_combs[index][0] = tempCard1;
    ct_combs[index][1] = tempCard2;
    ct_combs[index][2] = tempCard3;
    
    ct_swap_index--;
    
    // finally swap_index = -1;
    // don't call CTResetStatus() here, because the comparison loop is not finished yet.
    // so better call CTResetStatus() after game finished.
}

char suggestedRawValue(char v1, char v2)
{
    if (v1 == v2) {
        return v1;
    } else {
        char values[3] = { CTSETFirstValue, CTSETSecondValue, CTSETThirdValue };
        for (int i = 0; i <= 2; i++) {
            char value = values[i];
            if (value != v1 && value != v2) {
                return value;
            }
        }
    }
    return CTSETNoneValue;
}