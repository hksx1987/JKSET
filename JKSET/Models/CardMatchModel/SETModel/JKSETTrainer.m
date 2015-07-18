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
@property (nonatomic, retain) NSMutableArray *selectedCards; // candidates
@property (nonatomic, retain) SETCard *missingCard;
@end

@implementation JKSETTrainer

char suggestedValue(char v1, char v2);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedCards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"JKSETTrainer deallocated");
    [_selectedCards release];
    [_missingCard release];
    [super dealloc];
}

#pragma mark -

- (void)preSetupCards
{
    [self.selectedCards removeAllObjects];
    self.missingCard = nil;
    
    while (self.selectedCards.count < 2) {
        SETCard *card = [self randomCard];
        if (![self.selectedCards containsObject:card]) {
            [self.selectedCards addObject:card];
        }
    }
    
    self.missingCard = [self suggestedCardForCards:self.selectedCards];
}

- (NSArray *)candidateCards
{
    return [[self.selectedCards copy] autorelease];
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
            ![self.selectedCards containsObject:card] &&
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
