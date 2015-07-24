//
//  JKCardMatchingGameBrain.h
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card, Deck, JKCardMatchingGameBrain;

/* Abstract class */
@interface JKCardMatchingGameBrain : NSObject

@property (nonatomic, readonly) Deck *deck;
@property (nonatomic, readonly) NSArray *displayedCards; // current cards for displaying
@property (nonatomic, readonly) NSUInteger numberOfCards; // for displaying / displayed
@property (nonatomic, readonly) NSMutableArray *chosenCards;

@property (nonatomic, readonly) NSUInteger displayCount;
@property (nonatomic, readonly) NSUInteger matchCount;
@property (nonatomic, readonly) NSInteger score;

/* designated initalizer */
- (instancetype)initWithDeck:(Deck *)deck
                displayCount:(NSUInteger)count // number of cards for displaying
          requiredMatchCount:(NSUInteger)matchCount; // number of cards for a match

- (void)chooseCard:(Card *)card;
- (void)unchooseCard:(Card *)card;
- (void)removeCards:(NSArray *)cards;
- (Card *)cardAtIndex:(NSUInteger)index; // get a card for displaying (or displayed) on screen

- (void)startNewGameWithNewDeck:(Deck *)deck;
- (void)cleanAllSelections; // clean all selected cards.

- (NSUInteger)indexOfCard:(Card *)card;
- (NSArray *)lastRemovedCards;

// override
// the default implementation will send JKCardMatchingGameBrainDidEndGameNotification
- (void)didOutOfCards;

@end

NSString * const JKCardMatchingGameBrainDidFindMatchNotification;
NSString * const JKCardMatchingGameBrainDidMissMatchNotification;
NSString * const JKCardMatchingGameBrainDidEndGameNotification;

// the key for userInfo of notification
// the value is NSArray of cards for game matching. (success or failure)
NSString * const JKCardMatchingGameBrainComparedCardsKey;
