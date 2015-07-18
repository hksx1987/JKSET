//
//  Card.h
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <Foundation/Foundation.h>


/* Abstract class */
@interface Card : NSObject

@property (nonatomic) BOOL isMatched; // default is NO
@property (nonatomic) BOOL isChosen;

- (NSInteger)match:(NSArray *)cards;

@end
