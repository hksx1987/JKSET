//
//  Card.m
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSInteger)match:(NSArray *)cards
{
    [NSException raise: NSGenericException format: @"Must override this by subclass!"];
    return 0;
}

- (void)dealloc
{
    NSLog(@"%@ deallocated", [self description]);
    [super dealloc];
}

@end
