//
//  JKSETBrain.h
//  JKSET
//
//  Created by Jack Huang on 15/7/20.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKCardMatchingGameBrain.h"

@interface JKSETBrain : JKCardMatchingGameBrain

- (NSUInteger)maxNumberOfAllPossibleSETs;

// Setup starting status after game ended and prepare for new game.
- (void)setupNewCalculationStatus;

// Every time call this method, the brain will make a big calculation.
- (void)findAllPossibleSETsWithCompletion:(void(^)(NSUInteger numberOfAllPossibleSETs))completion;

// Returns an random array of SETCard objects which contains 3 matched cards.
- (NSArray *)randomSET;

@end
