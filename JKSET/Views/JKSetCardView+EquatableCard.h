//
//  JKSetCardView+EquatableCard.h
//  JKSET
//
//  Created by Jack Huang on 15/7/24.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSetCardView.h"
@class SETCard;

@interface JKSetCardView (EquatableCard)

// return a new SETCard object which has same values from the card view.
- (SETCard *)equatableSETCard;

@end
