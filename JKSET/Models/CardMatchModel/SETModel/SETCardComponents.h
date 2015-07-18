//
//  SETCardComponents.h
//  SETModel
//
//  Created by Jack Huang on 15/7/14.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#ifndef SETModel_SETCardComponents_h
#define SETModel_SETCardComponents_h

typedef NS_ENUM(char, SETOption) {
    SETNoneValue = '\x0',
    SETFirstValue = '\x01',
    SETSecondValue = '\x02',
    SETThirdValue = '\x03',
};

typedef SETOption SETColor;
typedef SETOption SETSymbol;
typedef SETOption SETNumber;
typedef SETOption SETShading;

#endif
