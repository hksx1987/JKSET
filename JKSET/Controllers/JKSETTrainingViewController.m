//
//  JKSETTrainingViewController.m
//  JKSET
//
//  Created by Jack Huang on 15/7/13.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSETTrainingViewController.h"
#import "JKClassicSetCardView.h"
#import "JKCalculations.h"
#import "JKSETBrain.h"
#import "JKSETTrainer.h"
#import "SETCard.h"
#import "JKSetCardView+equatableCard.h"
#import "JKSETDescriptor.h"

@interface JKSETTrainingViewController ()
@property (retain, nonatomic) IBOutlet UILabel *guideLabel;
@property (nonatomic, retain) JKSETBrain *brain;
@property (nonatomic, retain) JKSETTrainer *trainer;
@end

@implementation JKSETTrainingViewController
{
    CGSize _cellSize;
    UIView *_selectedView;
}

- (void)dealloc
{
    NSLog(@"test view controller deallocated");
    [_guideLabel release];
    [_brain release];
    [_trainer release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _trainer = [[JKSETTrainer alloc] init];
    _brain = [[JKSETBrain alloc] initWithDeck:nil displayCount:0 requiredMatchCount:3];
    
    _cellSize = defaultCellSizeInRect(self.view.bounds);
    
    [self setupCardViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCardViewWithGesture:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Here we need 5 cards and a blank card to be displayed in
// JKSETTrainingViewController, so I decided using index to
// place them. 3 cards (includes the blank card) above the
// center of screen are waited to be a SET. Another 3 cards
// which below the center of screen are options. One of them
// is the correct answer to choose.
// The most upper left card of 6 has the index 0, and index 1
// for next, ..., the most bottom right card has index 5.
- (void)setupCardViews
{
    // setup cards
    [self.trainer preSetupCards];
    NSArray *candidates = [self.trainer candidateCards];
    NSArray *options = [self.trainer optionalCardsWithCount:3];
    
    // setup card views
    for (NSUInteger i = 0; i <= 5; i++) {
        JKClassicSetCardView *cardView = [self cardViewAtIndex:i];
        
        if (i == 0 || i == 1) {
            SETCard *card = candidates[i];
            [cardView setSymbol:card.symbol color:card.color number:card.number shading:card.shading];
            [self.brain chooseCard: card];
        } else if (i == 2) {
            SETCard *card = [[SETCard alloc] initWithBlankCard];
            [cardView setSymbol:card.symbol color:card.color number:card.number shading:card.shading];
            [card release];
        } else {
            SETCard *card = options[i-3];
            [cardView setSymbol:card.symbol color:card.color number:card.number shading:card.shading];
        }

        [self.view addSubview:cardView];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)selectCardViewWithGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    UIView *containerView = gestureRecognizer.view;
    CGPoint location = [gestureRecognizer locationInView:containerView];
    
    if (location.y > CGRectGetHeight(containerView.bounds) / 2.0) {
        UIView *testView = [containerView hitTest:location withEvent:nil];
        _selectedView = testView;
        if ([testView isKindOfClass:[JKClassicSetCardView class]]) {
            JKClassicSetCardView *cardView = (JKClassicSetCardView *)testView;
            SETCard *card = [cardView equatableSETCard];
            [self.brain chooseCard:card];
        }
    }
}

- (void)resetTest
{
    NSUInteger count = self.view.subviews.count;
    NSRange rangeOfCardViews = NSMakeRange(count - 6, 6);
    NSArray *subviews = [self.view.subviews subarrayWithRange:rangeOfCardViews];
    
    for (NSUInteger i = 0; i < subviews.count; i++) {
        UIView *subview = subviews[i];
        if ([subview isKindOfClass:[JKClassicSetCardView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [self setupCardViews];
}

- (IBAction)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - notifications

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSETMatch:)
                                                 name:JKCardMatchingGameBrainDidFindMatchNotification
                                               object:self.brain];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSETMissMatch:)
                                                 name:JKCardMatchingGameBrainDidMissMatchNotification
                                               object:self.brain];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JKCardMatchingGameBrainDidFindMatchNotification object:self.brain];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JKCardMatchingGameBrainDidMissMatchNotification object:self.brain];
}

- (void)handleSETMatch:(NSNotification *)notification
{
    UIView *snapView = [_selectedView snapshotViewAfterScreenUpdates:NO];
    snapView.frame = _selectedView.frame;
    [self.view addSubview:snapView];
    [UIView animateWithDuration:0.5 animations:^{
        snapView.transform = CGAffineTransformMakeScale(1.8, 1.8);
        snapView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [snapView removeFromSuperview];
        [self resetTest];
    }];
}

- (void)handleSETMissMatch:(NSNotification *)notification
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Training Failed", @"Training match failed alert title")
                                                                   message:missMatchDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK Button", @"Traning match failed alert button") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *candidates = [self.trainer candidateCards];
        for (SETCard *card in candidates) {
            [self.brain chooseCard:card];
        }
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - helper

- (JKClassicSetCardView *)cardViewAtIndex:(NSUInteger)index
{
    CGRect card_frame = [self cardRectAtIndex:index];
    JKClassicSetCardView *cardView = [[JKClassicSetCardView alloc] initWithFrame:card_frame cornerColor:self.view.backgroundColor];
    return [cardView autorelease];
}

- (CGRect)cardRectAtIndex:(NSUInteger)index
{
    CGPoint card_center = [self cardCenterForIndex:index];
    CGSize card_size = _cellSize;
    CGPoint card_origin = CGPointMake(card_center.x - card_size.width / 2.0,
                                      card_center.y - card_size.height / 2.0);
    return CGRectMake(card_origin.x, card_origin.y, card_size.width, card_size.height);
}

- (CGPoint)cardCenterForIndex:(NSUInteger)index
{
    CGFloat h = CGRectGetHeight(self.view.bounds);
    CGFloat w = CGRectGetWidth(self.view.bounds);
    CGFloat s = _cellSize.width / 2.0;
    CGFloat p = 10.0;
    
    switch (index) {
        case 0:
            return CGPointMake(p + s, h / 3.0);
        case 1:
            return CGPointMake(w / 2.0, h / 3.0);
        case 2:
            return CGPointMake(w - p - s, h / 3.0);
        case 3:
            return CGPointMake(p + s, h * 2.0 / 3.0);
        case 4:
            return CGPointMake(w / 2.0, h * 2.0 / 3.0);
        case 5:
            return CGPointMake(w - p - s, h * 2.0 / 3.0);
        default:
            return CGPointZero;
    }
}

@end
