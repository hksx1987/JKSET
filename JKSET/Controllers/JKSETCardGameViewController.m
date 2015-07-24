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
#import "JKSETBrain.h"
#import "JKSETDescriptor.h"

#include "JKSETCType.h"

@interface JKSETCardGameViewController ()
@end

@implementation JKSETCardGameViewController
{
    BOOL _showHintIntroduction;
}

#pragma mark - overriding

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    [brain findAllPossibleSETsWithCompletion:^(NSUInteger numberOfAllPossibleSETs) {
        self.title = [JKSETDescriptor possibleSETsDescription:numberOfAllPossibleSETs];
    }];
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
    [cardView setSymbol:setCard.symbol color:setCard.color number:setCard.number shading:setCard.shading];
    return [cardView autorelease];
}

- (JKCardMatchingGameBrain *)brainForGame
{
    Deck *deck = [self deckForGame];
    JKSETBrain *brain = [[JKSETBrain alloc] initWithDeck:deck displayCount:[deck count] requiredMatchCount:3];
    return [brain autorelease];
}

- (void)updateUIAfterGameRestarted
{
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    self.title = [JKSETDescriptor possibleSETsDescription:[brain maxNumberOfAllPossibleSETs]];
}

#pragma mark - notifications

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // make sure the game brain is initialized before using it.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSETMatches:)
                                                 name:JKCardMatchingGameBrainDidFindMatchNotification
                                               object:self.gameBrain];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSETMissMatches:)
                                                 name:JKCardMatchingGameBrainDidMissMatchNotification
                                               object:self.gameBrain];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSETGameEnded:)
                                                 name:JKCardMatchingGameBrainDidEndGameNotification
                                               object:self.gameBrain];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JKCardMatchingGameBrainDidFindMatchNotification object:self.gameBrain];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JKCardMatchingGameBrainDidMissMatchNotification object:self.gameBrain];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JKCardMatchingGameBrainDidEndGameNotification object:self.gameBrain];
}

- (void)handleSETMatches:(NSNotification *)notification
{
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    [brain findAllPossibleSETsWithCompletion:^(NSUInteger numberOfAllPossibleSETs) {
        self.title = [JKSETDescriptor possibleSETsDescription:numberOfAllPossibleSETs];
    }];
}

- (void)handleSETMissMatches:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    BOOL missMatchedSymbol = [userInfo[JKCardMatchingGameBrainMissMatchSymbolValueKey] boolValue];
    BOOL missMatchedColor = [userInfo[JKCardMatchingGameBrainMissMatchColorValueKey] boolValue];
    BOOL missMatchedNumber = [userInfo[JKCardMatchingGameBrainMissMatchNumberValueKey] boolValue];
    BOOL missMatchedShading = [userInfo[JKCardMatchingGameBrainMissMatchShadingValueKey] boolValue];
    
    NSString *missMatchDescription = [JKSETDescriptor missMatchDescriptionForSymbol:missMatchedSymbol
                                                                              color:missMatchedColor
                                                                             number:missMatchedNumber
                                                                            shading:missMatchedShading];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Match Failed", @"Card game match failed alert title")
                                                                   message:missMatchDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Card game match failed alert button")
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleSETGameEnded:(NSNotification *)notification
{
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    [brain setupNewCalculationStatus];
}

#pragma mark - actions

- (IBAction)pressHintButton:(UIBarButtonItem *)sender
{
    JKSETBrain *brain = (JKSETBrain *)self.gameBrain;
    
    // clean all selections
    [self removeAllSelectionLayer];
    [brain cleanAllSelections];
    
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    
    // choose suggested cards
    NSArray *possibleSET = [brain randomSET];
    
    if (!possibleSET) {
        return;
    }
    
    for (NSUInteger i = 0; i < possibleSET.count-1; ++i) {
        SETCard *card = possibleSET[i];
        NSUInteger index = [brain indexOfCard:card];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(NSInteger)index inSection:0];
        
        // use this method to jump to the selection
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        
        [self drawSelectionLayerAtIndexPath:indexPath];
        [brain chooseCard:card];
        NSLog(@"%@", [card debugDescription]);
    }
    NSLog(@" ");
    
    if (!_showHintIntroduction) {
        _showHintIntroduction = YES;
        [self popHintIntroduction];
    }
    
}

#pragma mark - helper

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
