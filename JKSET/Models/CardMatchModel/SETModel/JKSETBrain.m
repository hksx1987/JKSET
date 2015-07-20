//
//  JKSETBrain.m
//  JKSET
//
//  Created by Jack Huang on 15/7/20.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETBrain.h"
#import "SETCard.h"
#import "JKSETTrainer.h"

@interface JKSETBrain()
@property (nonatomic, copy) NSArray *possibleSETs;
@end

@implementation JKSETBrain
{
    JKSETTrainer *_trainer;
}

- (instancetype)initWithDeck:(Deck *)deck displayCount:(NSUInteger)count requiredMatchCount:(NSUInteger)matchCount
{
    self = [super initWithDeck:deck displayCount:count requiredMatchCount:matchCount];
    if (self) {
        _trainer = [[JKSETTrainer alloc] init];
        _possibleSETs = [[NSArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_trainer release];
    [_possibleSETs release];
    [super dealloc];
}

- (void)findAllPossibleSETsWithCompletion:(void(^)(NSArray *allPossibleSETs))completion
{
    dispatch_queue_t calculationQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(calculationQueue, ^{
        
        NSArray *cards = self.displayedCards;
        NSUInteger count = cards.count;
        
        NSMutableSet *sets = [NSMutableSet set];
        NSUInteger i = 0, j = 0, m = 0;
        
        for (i = 0; i < count; ++i) {
            SETCard *c1 = cards[i];
            
            for (j = 0; j < count; ++j) {
                SETCard *c2 = cards[j];
                
                if (c1 != c2) {
                    
                    SETCard *sc = [_trainer suggestedCardForCards:@[c1, c2]];
                    
                    for (m = j; m < count; ++m) {
                        SETCard *c3 = cards[m];
                        
                        if (c3 != c1 && c3 != c2) {
                            if ([sc isEqual:c3]) {
                                NSSet *set = [NSSet setWithObjects:c1, c2, c3, nil];
                                [sets addObject:set];
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!sets.count) {
                [self.delegate cardMatchingGameBrainDidEndGame:self];
            }
            
            NSArray *possibleSETs = sets.allObjects;
            
            if (completion) {
                completion(possibleSETs);
            }
            
            self.possibleSETs = possibleSETs;
        });
    });
}

@end
