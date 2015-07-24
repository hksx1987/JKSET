//
//  JKCardGameViewController.m
//  JKSET
//
//  Created by Jack Huang on 15/7/15.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKCardGameViewController.h"
#import "JKCardMatchingGameBrain.h"
#import "Deck.h"
#import "Card.h"
#import "CALayer+IndexPath.h"
#import "JKCalculations.h"

@interface JKCardGameViewController ()
@end

@implementation JKCardGameViewController
{
    BOOL _presentIntroPage;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)setup
{
    // if subclasss provides brain, use it
    _gameBrain = [[self brainForGame] retain];
    
    // otherwise use the default brain
    if (!_gameBrain) {
        Deck *deck = [self deckForGame];
        _gameBrain = [[JKCardMatchingGameBrain alloc] initWithDeck:deck displayCount:[deck count] requiredMatchCount:3];
    }
}

- (void)dealloc
{
    [_gameBrain release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.allowsMultipleSelection = YES;

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.sectionInset = [self sectionInset];
    flowLayout.itemSize = [self cellSize];
    
    [self setup];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_presentIntroPage) {
        _presentIntroPage = YES;
        UIViewController *testVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JKSETTrainingViewController"];
        [self presentViewController:testVC animated:YES completion:nil];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameBrain.numberOfCards;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Very important to clean up the contents of cell before reuse it!!
    // Otherwise the memory usage will go up fast, because the cell stayed
    // in the reuse queue will not clean up it's contentView automatically.
    if (cell.contentView.subviews.count) {
        UIView *lastSubview = [cell.contentView.subviews lastObject];
        [lastSubview removeFromSuperview];
    }
    
    // Configure the cell
    Card *card = [self.gameBrain cardAtIndex:indexPath.row];
    UIView *cardView = [self cardViewForCard:card atIndexPath:indexPath];
    [cell.contentView addSubview:cardView];
    
    return cell;
}

#pragma mark - helper

#define kCollectionViewCellPadding 10.0

- (UIEdgeInsets)sectionInset
{
    CGFloat edgeSpace = kCollectionViewCellPadding;
    return UIEdgeInsetsMake(edgeSpace * 2, edgeSpace, edgeSpace, edgeSpace);
}

- (CGSize)cellSize
{
    return defaultCellSizeInRect(self.collectionView.bounds);
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeSelectionLayerAtIndexPath:indexPath];
    [self drawSelectionLayerAtIndexPath:indexPath];
    Card *card = [self.gameBrain cardAtIndex:indexPath.row];
    [self.gameBrain chooseCard:card];
    [self didChooseCard:card];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeSelectionLayerAtIndexPath:indexPath];
    Card *card = [self.gameBrain cardAtIndex:indexPath.row];
    [self.gameBrain unchooseCard:card];
    [self didChooseCard:card];
}

#pragma mark - notifications

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // make sure the game brain is initialized before using it.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMatches:)
                                                 name:JKCardMatchingGameBrainDidFindMatchNotification
                                               object:self.gameBrain];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMissMatches:)
                                                 name:JKCardMatchingGameBrainDidMissMatchNotification
                                               object:self.gameBrain];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleGameEnded:)
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

- (void)handleMatches:(NSNotification *)notification
{
    NSArray *cards = notification.userInfo[JKCardMatchingGameBrainComparedCardsKey];
    
    [self removeAllSelectionLayer];
    
    // use [self.collectionView indexPathsForSelectedItems] is not safe, because in some cases,
    // cards are selected programmatically. (Unless you call selectItemAtIndexPath: and
    // deleteItemsAtIndexPaths: manually to sync with it.)
    // ps: call selectItemAtIndexPath: manually will not trigger the didSelect... delegate method!
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (Card *card in cards) {
        NSUInteger i = [self.gameBrain indexOfCard:card];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    NSSet *calculationIndexPathsSet = [NSSet setWithArray:indexPaths];
    NSSet *selectionIndexPathsSet = [NSSet setWithArray:[self.collectionView indexPathsForSelectedItems]];
    if (![calculationIndexPathsSet isEqualToSet:selectionIndexPathsSet]) {
        [NSException raise:NSInternalInconsistencyException format:@"The calculated selected index paths should be same as selected from collectionView."];
    }
    
    [self.collectionView performBatchUpdates:^{
        [self.gameBrain removeCards:cards];
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

- (void)handleMissMatches:(NSNotification *)notification
{
    [self removeAllSelectionLayer];
    
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (void)handleGameEnded:(NSNotification *)notification
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Congratulation", @"Game finished title")
                                                                  message:NSLocalizedString(@"Try one more?", @"Game finished message")
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *go = [UIAlertAction actionWithTitle:NSLocalizedString(@"Go", @"Game finished button") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       Deck *deck = [self deckForGame];
       [self.gameBrain startNewGameWithNewDeck:deck];
       [self.collectionView reloadData];
       [self updateUIAfterGameRestarted];
    }];
    [alert addAction:go];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - visualize selection

- (void)drawSelectionLayerAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cardFrame = layoutAttributes.frame;
    CGFloat cornerRadius = cornerRadiusForRect(cardFrame);
    
    UIBezierPath *cardPath = [UIBezierPath bezierPathWithRoundedRect:cardFrame cornerRadius:cornerRadius];
    CAShapeLayer *frameLayer = [CAShapeLayer layer];
    frameLayer.path = cardPath.CGPath;
    frameLayer.lineWidth = 4.0; // set lineWidth directly to layer, because set path.lineWidth is useless
    frameLayer.fillColor = nil;
    frameLayer.strokeColor = [[UIColor orangeColor] CGColor];
    frameLayer.associatedIndexPath = indexPath; // connect layer with indexPath
    
    [self.collectionView.layer addSublayer:frameLayer];
}

- (void)removeSelectionLayerAtIndexPath:(NSIndexPath *)indexPath
{
    // the selection layer's position and bounds are still zero value, so cannot receive it by hitTest:
    __block CALayer *frameLayer = nil;
    NSArray *sublayers = self.collectionView.layer.sublayers;
    
    [sublayers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CALayer *sublayer, NSUInteger idx, BOOL *stop) {
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            if ([sublayer.associatedIndexPath isEqual:indexPath]) {
                sublayer.associatedIndexPath = nil;
                frameLayer = sublayer;
                *stop = YES;
            }
        }
    }];
    
    [frameLayer removeFromSuperlayer];
}

- (void)removeAllSelectionLayer
{
    NSUInteger count = self.collectionView.layer.sublayers.count;
    NSRange rangeOfLayers = NSMakeRange(count - 5, 5);
    NSArray *sublayers = [self.collectionView.layer.sublayers subarrayWithRange:rangeOfLayers];
    
    for (NSUInteger i = 0; i < sublayers.count; i++) {
        CALayer *sublayer = sublayers[i];
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            sublayer.associatedIndexPath = nil;
            [sublayer removeFromSuperlayer];
        }
    }
    
    // It is not encouraged to modity collection while enumerating it.
    // Although this approach works ^_^!
    
//    for (NSUInteger i = 0; i < self.collectionView.layer.sublayers.count; i++) {
//        NSLog(@"%d", self.collectionView.layer.sublayers.count);
//        CALayer *sublayer = self.collectionView.layer.sublayers[i];
//        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
//            // call this will change the mutable collection while in the loop,
//            // but will not change the immutable collection while in the loop
//            [sublayer removeFromSuperlayer];
//            // if enumerating the mutable collection,
//            // it must go back one, and start from same index
//            i--;
//        }
//    }
}

#pragma mark - actions

- (IBAction)pressPracticeButton:(id)sender {
    UIViewController *testVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JKSETTrainingViewController"];
    [self presentViewController:testVC animated:YES completion:nil];
}


#pragma mark -

- (Deck *)deckForGame { return nil; }
- (UIView *)cardViewForCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath { return nil; }

- (JKCardMatchingGameBrain *)brainForGame { return nil; }

- (void)didChooseCard:(Card *)card {}
- (void)updateUIAfterGameRestarted {}

@end
