//
//  JKSETCType.c
//  JKSET
//
//  Created by Jack Huang on 15/7/21.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#include "JKSETCType.h"

TheSETCard TheSETCardMake(char symbol, char color, char number, char shading) {
    TheSETCard theCard = { symbol, color, number, shading };
    return theCard;
}

TheSETCard TheSETCardMakeZero() {
    char zeroValue = '\x0';
    TheSETCard theCard = { zeroValue, zeroValue, zeroValue, zeroValue };
    return theCard;
}

TheSETCard suggestSETCard(TheSETCard card1, TheSETCard card2) {
    char symbol = suggestedRawValue(card1.symbol, card2.symbol);
    char color = suggestedRawValue(card1.color, card2.color);
    char number = suggestedRawValue(card1.number, card2.number);
    char shading = suggestedRawValue(card1.shading, card2.shading);
    
    return TheSETCardMake(symbol, color, number, shading);
}

int TheSETCardIsEqualToTheSETCard(TheSETCard card1, TheSETCard card2) {
    if (card1.symbol == card2.symbol &&
        card1.color == card2.color &&
        card1.number == card2.number &&
        card1.shading == card2.shading) {
        return 1;
    }
    return 0;
}

Combination CombinationMake(TheSETCard card1, TheSETCard card2, TheSETCard card3) {
    Combination comb = { card1, card2, card3 };
    return comb;
}

Combination CombinationMakeZero() {
    TheSETCard zeroCard = TheSETCardMakeZero();
    Combination zeroComb = CombinationMake(zeroCard, zeroCard, zeroCard);
    return zeroComb;
}

int containsCombination(Combination comb, int toAmount) {
    for (int i = 0; i < toAmount; ++i) {
        Combination theComb = combs[i];
        
//        if (TheSETCardIsZero(theComb.firstCard)) {
//            return 0;
//        }
        
        int condition1 = (TheSETCardIsEqualToTheSETCard(theComb.firstCard, comb.firstCard) ||
                           TheSETCardIsEqualToTheSETCard(theComb.firstCard, comb.secondCard) ||
                           TheSETCardIsEqualToTheSETCard(theComb.firstCard, comb.thirdCard));
        
        int condition2 = (TheSETCardIsEqualToTheSETCard(theComb.secondCard, comb.firstCard) ||
                           TheSETCardIsEqualToTheSETCard(theComb.secondCard, comb.secondCard) ||
                           TheSETCardIsEqualToTheSETCard(theComb.secondCard, comb.thirdCard));
        
        int condition3 = (TheSETCardIsEqualToTheSETCard(theComb.thirdCard, comb.firstCard) ||
                           TheSETCardIsEqualToTheSETCard(theComb.thirdCard, comb.secondCard) ||
                           TheSETCardIsEqualToTheSETCard(theComb.thirdCard, comb.thirdCard));
        
        if (condition1 && condition2 && condition3) {
            return 1;
        }
    }
    return 0;
}

void removeCombinationsAmountOf(int amount) {
    Combination zeroComb = CombinationMakeZero();
    for (int i = 0; i < amount; ++i) {
        combs[i] = zeroComb;
    }
}

int TheSETCardIsZero(TheSETCard card) {
    char zeroValue = '\x0';
    if (card.symbol == zeroValue && card.color == zeroValue &&
        card.number == zeroValue && card.shading == zeroValue) {
        return 1;
    }
    return 0;
}

char suggestedRawValue(char v1, char v2)
{
    if (v1 == v2) {
        return v1;
    } else {
        char values[3] = { '\x01', '\x02', '\x03' };
        for (int i = 0; i <= 2; i++) {
            char value = values[i];
            if (value != v1 && value != v2) {
                return value;
            }
        }
    }
    return '\x0';
}