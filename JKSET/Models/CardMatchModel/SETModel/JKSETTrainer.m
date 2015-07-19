//
//  JKSETTrainer.m
//  JKSET
//
//  Created by Jack Huang on 15/7/17.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETTrainer.h"
#import "SETCard.h"

@interface JKSETTrainer()
@property (nonatomic, retain) NSMutableArray *candidates; // array of 2 cards for SET candidates
@property (nonatomic, retain) SETCard *missingCard; // One missing SET card
@end

@implementation JKSETTrainer

char suggestedValue(char v1, char v2);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _candidates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"JKSETTrainer deallocated");
    [_candidates release];
    [_missingCard release];
    [super dealloc];
}

#pragma mark -

- (void)preSetupCards
{
    [self.candidates removeAllObjects];
    self.missingCard = nil;
    
    while (self.candidates.count < 2) {
        SETCard *card = [self randomCard];
        if (![self.candidates containsObject:card]) {
            [self.candidates addObject:card];
        }
    }
    
    self.missingCard = [self suggestedCardForCards:self.candidates];
}

- (NSArray *)candidateCards
{
    return [[self.candidates copy] autorelease];
}

- (NSArray *)optionalCardsWithCount:(NSUInteger)count
{
    if (count <= 0) {
        return nil;
    }
    
    // create distractions
    NSMutableArray *options = [NSMutableArray arrayWithCapacity:count];
    while (options.count < count-1) {
        SETCard *card = [self randomCard];
        if (![options containsObject:card] &&
            ![self.candidates containsObject:card] &&
            ![self.missingCard isEqual:card]) {
            [options addObject:card];
        }
    }
    
    // add missing card
    u_int32_t i = arc4random() % count;
    [options insertObject:self.missingCard atIndex:i];
    
    return [[options copy] autorelease];
}

#pragma mark - helper

- (SETCard *)randomCard
{
    return [[[SETCard alloc] initWithSymbol:[self randomValue]
                                      color:[self randomValue]
                                     number:[self randomValue]
                                    shading:[self randomValue]
             ] autorelease];
}

- (SETCard *)suggestedCardForCards:(NSArray *)cards
{
    SETCard *c1 = [cards firstObject];
    SETCard *c2 = [cards lastObject];
    
    return [[[SETCard alloc] initWithSymbol:suggestedValue(c1.symbol, c2.symbol)
                                      color:suggestedValue(c1.color, c2.color)
                                     number:suggestedValue(c1.number, c2.number)
                                    shading:suggestedValue(c1.shading, c2.shading)
             ] autorelease];
}

- (u_int32_t)randomValue
{
    return arc4random() % 3 + 1;
}

@end


char suggestedValue(char v1, char v2)
{
    if (v1 == v2) {
        return v1;
    } else {
        char values[3] = { SETFirstValue, SETSecondValue, SETThirdValue };
        for (NSUInteger i = 0; i <= 2; i++) {
            char value = values[i];
            if (value != v1 && value != v2) {
                return value;
            }
        }
    }
    return SETNoneValue;
}
