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
@property (nonatomic) NSUInteger displayCount;
@property (nonatomic) NSUInteger matchCount;
@property (nonatomic) NSInteger score;
@end

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
        
        if (!_deck) {
            [NSException raise: NSGenericException
                        format: @"Deck Must be not nil for the game!"];
        }
        
        if (matchCount < 2 || matchCount > displayCount) {
            [NSException raise: NSInvalidArgumentException
                        format: @"Need at least 2 cards and not too much cards for matching!"];
        } else {
            _matchCount = matchCount;
        }
        
        if (displayCount <= [deck count]) {
            _displayCount = displayCount;
            [self displayCards];
        } else {
            [NSException raise: NSInvalidArgumentException
                        format: @"Can not display cards more than the deck!"];
        }
    }
    return self;
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
                [self.chosenCards removeObjectIdenticalTo: card];
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
                    [self.delegate cardMatchingGameBrain:self didFindAMatchWithCards:matchedCards];
                }
                /* match failed */
                else {
                    NSLog(@"match failed");
                    NSMutableArray *failedCards = [NSMutableArray arrayWithArray:self.chosenCards];
                    [failedCards addObject:card];
                    
                    [self.delegate cardMatchingGameBrain:self didFailAMatchWithCards:failedCards];
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
    [self.cards removeObjectsInArray:cards];
    if (!self.cards.count) {
        [self.delegate cardMatchingGameBrainDidEndGame:self];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return self.cards[index];
}

- (void)cleanAllSelections
{
    for (Card *card in self.cards) {
        card.isChosen = NO;
    }
    [self.chosenCards removeAllObjects];
}

#pragma mark - helper

- (void)startNewGameWithNewDeck:(Deck *)deck
{
    self.deck = deck;
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
