//
//  JKSetCardView+EquatableCard.m
//  JKSET
//
//  Created by Jack Huang on 15/7/24.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSetCardView+EquatableCard.h"
#import "SETCard.h"

@implementation JKSetCardView (EquatableCard)

- (SETCard *)equatableSETCard
{
    return [[[SETCard alloc] initWithSymbol:self.symbol
                                     color:self.color
                                    number:self.number
                                   shading:self.shading]
            autorelease];
}

@end
