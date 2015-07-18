//
//  JKClassicSetCardView.h
//  JKSET
//
//  Created by Jack Huang on 15/7/14.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "JKSetCardView.h"

/*
 * ------ the classic SET Game ------
 * color:   red, green, blue
 * symbol:  diamond, squiggle, oval
 * number:  one, two, three
 * shading: outlined, solid, striped
 * ----------------------------------
 */

/*
 * The JKSetCardView already know how to draw
 * different numbers and shadings of symbols
 * on screen.
 * For subclass of JKSetCardView, it only needs
 * to take care of the colors and shapes of 
 * symbols by overriding those methods
 */
@interface JKClassicSetCardView : JKSetCardView

@end
