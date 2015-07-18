//
//  JKSETJudge.h
//  JKSET
//
//  Created by Jack Huang on 15/7/17.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SETCard, JKSETJudge;


@protocol JKSETJudgeDelegate <NSObject>
- (void)judge:(JKSETJudge *)judge didReceiveMatchFailureDescription:(NSString *)failureDescription;
@end


@interface JKSETJudge : NSObject

@property (nonatomic, assign) id <JKSETJudgeDelegate> delegate;

/*! Select a card and wait for delegate callback about failure match description.
 * \param card The card you've chosen.
 * \returns The BOOL value indicates match success or failure.
 */
- (BOOL)chooseCard:(SETCard *)card;

@end
