//
//  JKSETCType.h
//  JKSET
//
//  Created by Jack Huang on 15/7/21.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#ifndef __JKSET__JKSETCType__
#define __JKSET__JKSETCType__

#include <stdio.h>
#include <stdbool.h>

#define CT_POSSIBLE_SETS_MAX 1080
#define CT_SET_CARD_COUNT_MAX 81

struct CTSETCard {
    char symbol;
    char color;
    char number;
    char shading;
};
typedef struct CTSETCard CTSETCard;

struct CTSETCombination {
    CTSETCard cards[3];
};
typedef struct CTSETCombination CTSETCombination;

typedef void(^ct_completion_block)(int numberOfAllPossibleSETs);

// ct_combs contains all possible arrays of CTSETCards, each array is a 3-cards combination.
CTSETCard ct_combs[CT_POSSIBLE_SETS_MAX][3];
// ct_cards contains all CTSETCards
CTSETCard ct_cards[CT_SET_CARD_COUNT_MAX];


// functions

CTSETCard CTSETCardMake(char symbol, char color, char number, char shading);
CTSETCard CTSETCardMakeBlankCard();

CTSETCombination CTSETCombinationMake(CTSETCard c1, CTSETCard c2, CTSETCard c3);
CTSETCombination CTSETCombinationMakeZero();

void CTSetupWithCompletion(ct_completion_block completion);

void CTRemoveCombinationCards(CTSETCard c1, CTSETCard c2, CTSETCard c3, ct_completion_block completion);
void CTRemoveCombination(CTSETCombination combination, ct_completion_block completion);

void CTGetRandomCombinationCards(CTSETCard *c1, CTSETCard *c2, CTSETCard *c3);
CTSETCombination CTGetRandomCombination();

bool CTSETCombinationStatusIsInitialStatus();

#endif /* defined(__JKSET__JKSETCType__) */
