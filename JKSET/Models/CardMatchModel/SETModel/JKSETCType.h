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

struct TheSETCard {
    char symbol;
    char color;
    char number;
    char shading;
};
typedef struct TheSETCard TheSETCard;

struct Combination {
    TheSETCard firstCard;
    TheSETCard secondCard;
    TheSETCard thirdCard;
};
typedef struct Combination Combination;

#define POSSIBLE_SETS_MAX 1080

Combination combs[POSSIBLE_SETS_MAX];


TheSETCard TheSETCardMake(char symbol, char color, char number, char shading);
TheSETCard TheSETCardMakeZero();
TheSETCard suggestSETCard(TheSETCard card1, TheSETCard card2);
int TheSETCardIsEqualToTheSETCard(TheSETCard card1, TheSETCard card2);
int TheSETCardIsZero(TheSETCard card);
char suggestedRawValue(char v1, char v2);


Combination CombinationMake(TheSETCard card1, TheSETCard card2, TheSETCard card3);
Combination CombinationMakeZero();
int containsCombination(Combination comb, int toAmount);
void removeCombinationsAmountOf(int amount);

#endif /* defined(__JKSET__JKSETCType__) */
