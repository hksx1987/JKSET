//
//  Deck.m
//  SETModel
//
//  Created by Jack Huang on 15/4/28.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (nonatomic, retain) NSMutableArray *cards;
@end

@implementation Deck

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addCard:(Card *)card
{
    [self.cards addObject: card];
}

- (Card *)drawRandomCard
{
    if (self.cards.count) {
        u_int32_t i = arc4random() % self.cards.count;
        Card *card = [self.cards[i] retain];
        [self.cards removeObjectIdenticalTo:card];
        return [card autorelease];
    }
    return nil;
}

- (NSUInteger)count
{
    return self.cards.count;
}

- (void)dealloc
{
    NSLog(@"Deck deallocated");
    [_cards release];
    [super dealloc];
}

- (void)debugPrint
{
    NSLog(@"========= Debug Print =========");
    for (Card *card in self.cards)
    {
        NSLog(@"%@", [card description]);
    }
    NSLog(@"total %lu cards", (unsigned long)self.cards.count);
}

@end
