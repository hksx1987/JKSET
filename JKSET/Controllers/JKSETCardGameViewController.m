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
    
}

#pragma mark - helper

- (void)displayRemainsSETs
{
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    [brain findAllPossibleSETsWithCompletion:^(NSArray *allPossibleSETs) {
        NSUInteger count = allPossibleSETs.count;
        self.title = [NSString stringWithFormat:@"Remains:%lu", (unsigned long)count];
    }];
}

@end
