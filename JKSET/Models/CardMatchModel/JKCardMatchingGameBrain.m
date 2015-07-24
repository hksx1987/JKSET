//
//  JKCardMatchingGameBrain.m
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKCardMatchingGameBrain.h"
#import "Deck.h"
#import "Card.h"

@interface JKCardMatchingGameBrain ()

@property (nonatomic, retain) Deck *deck;
@property (nonatomic, retain) NSMutableArray *cards;
@property (nonatomic, retain) NSMutableArray *chosenCards;
@property (nonatomic, copy) NSArray *lastRemovedCards;

@property (nonatomic) NSUInteger displayCount;
@property (nonatomic) NSUInteger matchCount;
@property (nonatomic) NSInteger score;

@end

NSString * const JKCardMatchingGameBrainDidFindMatchNotification = @"JKCardMatchingGameBrainDidFindMatchNotification";
NSString * const JKCardMatchingGameBrainDidMissMatchNotification = @"JKCardMatchingGameBrainDidMissMatchNotification";
NSString * const JKCardMatchingGameBrainDidEndGameNotification = @"JKCardMatchingGameBrainDidEndGameNotification";
NSString * const JKCardMatchingGameBrainComparedCardsKey = @"JKCardMatchingGameBrainComparedCardsKey";

@implementation JKCardMatchingGameBrain

- (instancetype)initWithDeck:(Deck *)deck
                displayCount:(NSUInteger)displayCount
          requiredMatchCount:(NSUInteger)matchCount
{
    self = [super init];
    if (self) {
        _deck = [deck retain];
        _cards = [[NSMutableArray alloc] init];
        _chosenCards = [[NSMutableArray alloc] init];
        _score = 0;
        
        if (matchCount < 2) {
            [NSException raise: NSInvalidArgumentException
                        format: @"Need at least 2 cards and not too much cards for matching!"];
        } else {
            _matchCount = matchCount;
        }
        
        _displayCount = displayCount;
        
        if (displayCount > 0) {
            [self displayCards];
        }
        
        if (_deck) {
            if (displayCount <= [_deck count]) {
                [NSException raise: NSInvalidArgumentException
                            format: @"Can not display cards more than the deck!"];
            }
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDeck:nil displayCount:0 requiredMatchCount:2];
}

- (void)dealloc
{
    NSLog(@"game deallocated");
    [_cards release];
    [_chosenCards release];
    [_deck release];
    [super dealloc];
}

#pragma mark -

- (NSUInteger)numberOfCards
{
    return self.cards.count;
}

- (NSArray *)displayedCards
{
    return [[self.cards copy] autorelease];
}

#pragma mark -

- (void)chooseCard:(Card *)card
{
    if (!card.isMatched) {
        if (card.isChosen) {
            card.isChosen = NO;
            if ([self.chosenCards containsObject: card]) {
                [self.chosenCards removeObject: card];
            }
        } else {
            card.isChosen = YES;
            
            if (self.chosenCards.count < self.matchCount-1) {
                if (![self.chosenCards containsObject:card]) {
                    [self.chosenCards addObject: card];
                }
            } else {
                /* try a match */
                NSInteger score = [card match: self.chosenCards];
                /* found a match */
                if (score > 0) {
                    self.score += score;
                    NSLog(@"Find a match!");
                    
                    NSMutableArray *matchedCards = [NSMutableArray arrayWithArray:self.chosenCards];
                    [matchedCards addObject:card];
                    
                    for (Card *card in matchedCards) {
                        card.isMatched = YES;
                    }
                    [self didFindAMatchWithCards:matchedCards];
                }
                /* match failed */
                else {
                    NSLog(@"match failed");
                    NSMutableArray *failedCards = [NSMutableArray arrayWithArray:self.chosenCards];
                    [failedCards addObject:card];
                    
                    [self didMissMatchWithCards:failedCards];
                }
                
                // clean chosenCards
                [self.chosenCards removeAllObjects];
                // unchoose all cards
                for (Card *card in self.cards) {
                    card.isChosen = NO;
                }
            }
        }
    }
}

- (void)unchooseCard:(Card *)card
{
    // Same API deals with both for choosing and unchoosing the card.
    // If you choose the chosen card, it will unchoose it.
    [self chooseCard:card];
}

- (void)removeCards:(NSArray *)cards
{
    // get a copy of removed cards
    self.lastRemovedCards = cards;
    
    [self.cards removeObjectsInArray:cards];
    if (!self.cards.count) {
        [self didOutOfCards];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return self.cards[index];
}

- (void)cleanAllSelections
{
    if (self.cards.count) {
        for (Card *card in self.cards) {
            card.isChosen = NO;
        }
    }
    
    [self.chosenCards removeAllObjects];
}

- (NSUInteger)indexOfCard:(Card *)card
{
    return [self.cards indexOfObject:card];
}

- (NSArray *)lastRemovedCards
{
    return _lastRemovedCards;
}

- (void)didOutOfCards
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:JKCardMatchingGameBrainDidEndGameNotification
                                 object:self
                               userInfo:nil];
}

#pragma mark - helper

- (void)didFindAMatchWithCards:(NSArray *)cards
{
    NSDictionary *userInfo = @{ JKCardMatchingGameBrainComparedCardsKey : cards };
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:JKCardMatchingGameBrainDidFindMatchNotification
                                 object:self
                               userInfo:userInfo];
}

- (void)didMissMatchWithCards:(NSArray *)cards
{
    NSDictionary *userInfo = @{ JKCardMatchingGameBrainComparedCardsKey : cards };
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:JKCardMatchingGameBrainDidMissMatchNotification
                                 object:self
                               userInfo:userInfo];
}

- (void)startNewGameWithNewDeck:(Deck *)deck
{
    self.deck = deck;
    [self.cards removeAllObjects];
    [self displayCards];
}

- (void)displayCards
{
    for (NSUInteger i = 0; i < _displayCount; i++) {
        Card *card = [_deck drawRandomCard];
        if (card) {
            [_cards addObject: card];
        }
    }
}

@end

