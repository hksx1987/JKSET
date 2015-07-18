//
//  SETDeck.m
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "SETDeck.h"
#import "SETCard.h"

#define LoopCondition(c) (c) = SETFirstValue; (c) <= SETThirdValue; (c)++

@implementation SETDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        char c1, c2, c3, c4;
        for (LoopCondition(c1)) {
            for (LoopCondition(c2)) {
                for (LoopCondition(c3)) {
                    for (LoopCondition(c4)) {
                        SETCard *card = [[SETCard alloc] initWithSymbol:c1 color:c2 number:c3 shading:c4];
                        [self addCard: card];
                        [card release];
                    }
                }
            }
        }
    }
    return self;
}

@end
