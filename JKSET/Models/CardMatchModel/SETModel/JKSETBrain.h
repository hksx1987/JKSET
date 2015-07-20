//
//  JKSETBrain.h
//  JKSET
//
//  Created by Jack Huang on 15/7/20.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKCardMatchingGameBrain.h"

@interface JKSETBrain : JKCardMatchingGameBrain

// An array of NSSET objects which contains 3 indexes of matched cards.
@property (nonatomic, readonly) NSArray *possibleSETs;

// Every time call this method, the brain will make a big calculation.
- (void)findAllPossibleSETsWithCompletion:(void(^)(NSArray *allPossibleSETs))completion;

@end
