//
//  Deck.h
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

/* Abstract class */
@interface Deck : NSObject

- (NSUInteger)count; // number of cards in the deck
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;

- (void)debugPrint;

@end
