//
//  JKSETTrainer.h
//  JKSET
//
//  Created by Jack Huang on 15/7/17.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SETCard;


@interface JKSETTrainer : NSObject

@property (nonatomic, readonly) SETCard *missingCard;

// Setup all option cards and candidate cards
// Call this method first
- (void)preSetupCards;

// Call these 2 methods after preSetupCards
- (NSArray *)candidateCards; // returns an array of 2 cards for an incomplete SET
- (NSArray *)optionalCardsWithCount:(NSUInteger)count; // returns an array of numbers of option cards, one of them is the answer.

// Passing 2 cards and get a suggested result
- (SETCard *)suggestedCardForCards:(NSArray *)cards;

@end
