//
//  JKCardGameViewController.h
//  JKSET
//
//  Created by Jack Huang on 15/7/15.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Card, Deck, JKCardMatchingGameBrain;

/* Abstract Class */
@interface JKCardGameViewController : UICollectionViewController

@property (nonatomic, retain) JKCardMatchingGameBrain *gameBrain;

// subclass MUST override these!
- (Deck *)deckForGame;
- (UIView *)cardViewForCard:(Card *)card atIndexPath:(NSIndexPath *)indexPath;

// this is optional for overriding
// the same API deals with both choose and unchoose card
- (void)didChooseCard:(Card *)card;
- (void)didFindAMatch;
- (void)didFailAMatch;

// subclass can override this to provide a subclass of JKCardMatchingGameBrain
- (JKCardMatchingGameBrain *)brainForGame;

@end
