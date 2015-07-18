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

- (void)preSetupCards;

// Call these 2 methods after preSetupCards
- (NSArray *)candidateCards; // contains 2 cards for an incomplete SET
- (NSArray *)optionalCardsWithCount:(NSUInteger)count; // contains number of cards, one of them is the answer.


@end
