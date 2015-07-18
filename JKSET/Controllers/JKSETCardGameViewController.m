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

- (void)didChooseCard:(Card *)card
{
    [self.judge chooseCard:(SETCard *)card];
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

@end
