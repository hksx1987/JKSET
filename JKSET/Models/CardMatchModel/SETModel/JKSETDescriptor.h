//
//  JKSETDescriptor.h
//  JKSET
//
//  Created by Jack Huang on 15/7/24.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSETDescriptor : NSObject

+ (NSString *)missMatchDescriptionForSymbol:(BOOL)missMatchedSymbol
                                      color:(BOOL)missMatchedColor
                                     number:(BOOL)missMatchedNumber
                                    shading:(BOOL)missMatchedShading;

+ (NSString *)possibleSETsDescription:(NSUInteger)numberOfPossibleSETs;

@end
