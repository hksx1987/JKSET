//
//  JKSETCardGameViewController.m
//  JKSET
//
//  Created by Jack Huang on 15/7/15.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETCardGameViewController.h"
#import "SETDeck.h"
#import "SETCard.h"
#import "JKClassicSetCardView.h"
#import "JKSETJudge.h"
#import "JKSETBrain.h"

@interface JKSETCardGameViewController () <JKSETJudgeDelegate>
@property (nonatomic, retain) JKSETJudge *judge;
@end

@implementation JKSETCardGameViewController
{
    BOOL _showHintIntroduction;
}

- (void)dealloc
{
    [_judge release];
    [super dealloc];
}

#pragma mark - overriding

- (void)viewDidLoad
{
    [super viewDidLoad];
    _judge = [[JKSETJudge alloc] init];
    _judge.delegate = self;
    
    [self displayRemainsSETs];
}

- (Deck *)deckForGame
{
    SETDeck *deck = [[SETDeck alloc] init];
    return [deck autorelease];
}

- (UIView *)cardViewForCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath
{
    SETCard *setCard = (SETCard *)card;
    JKClassicSetCardView *cardView = [[JKClassicSetCardView alloc] initWithFrame:CGRectZero cornerColor:self.collectionView.backgroundColor];
    UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    cardView.frame = layoutAttributes.bounds;
    cardView.card = setCard;
    return [cardView autorelease];
}

- (JKCardMatchingGameBrain *)brainForGame
{
    Deck *deck = [self deckForGame];
    JKSETBrain *brain = [[JKSETBrain alloc] initWithDeck:deck displayCount:[deck count] requiredMatchCount:3];
    return [brain autorelease];
}

- (void)didChooseCard:(Card *)card
{
    [self.judge chooseCard:(SETCard *)card];
}

- (void)didFindAMatch
{
    [self displayRemainsSETs];
}

- (void)didRestartGame
{
    [self displayRemainsSETs];
}

#pragma mark - <JKSETJudgeDelegate>

- (void)judge:(JKSETJudge *)judge didReceiveMatchFailureDescription:(NSString *)failureDescription
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Match Failed", @"Card game match failed alert title")
                                                                   message:failureDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Card game match failed alert button")
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - actions

- (IBAction)pressHintButton:(UIBarButtonItem *)sender
{
    if (!_showHintIntroduction) {
        _showHintIntroduction = YES;
        [self popHintIntroduction];
    }
    
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    
    // clean all selections
    [self removeAllSelectionLayer];
    [brain cleanAllSelections];
    [self.judge cleanAllSelections];
    
    // choose suggested cards
    NSArray *possibleSETs = brain.possibleSETs;
    NSUInteger randomIndex = arc4random_uniform(possibleSETs.count);
    NSArray *possibleSET = ((NSSet *)possibleSETs[randomIndex]).allObjects;
    
    for (NSInteger i = 0; i < 2; ++i) {
        NSInteger indexValue = [possibleSET[i] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexValue inSection:0];
        
        // use this method to jump to the selection
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        
        [self drawSelectionLayerAtIndexPath:indexPath];
        Card *card = [brain cardAtIndex:indexValue];
        [brain chooseCard:card];
        [self.judge chooseCard:(SETCard *)card];
        NSLog(@"%@", [card debugDescription]);
    }
    NSLog(@" ");
}

#pragma mark - helper

- (void)displayRemainsSETs
{
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    [brain findAllPossibleSETsWithCompletion:^(NSArray *allPossibleSETs) {
        NSUInteger count = allPossibleSETs.count;
        self.title = [NSString stringWithFormat:NSLocalizedString(@"Remains: %lu combinations", @"Showing { number } of possible SETs"), (unsigned long)count];
    }];
}

- (void)popHintIntroduction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hint 提示"
                                                                   message:@"You can get 2 cards for hint, and go find another! 您可以获得提示中的两张卡片，需要自己寻找另一张。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
