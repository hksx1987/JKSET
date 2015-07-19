//
//  CALayer+IndexPath.m
//  JKSET
//
//  Created by Jack Huang on 15/7/15.
//  Copyright (c) 2015年 Jack's app for practice. All rights reserved.
//

#import "CALayer+IndexPath.h"
#import <objc/runtime.h>

@implementation CALayer (IndexPath)
@dynamic associatedIndexPath;

const void * kCALayerLocationKey;

- (void)setAssociatedIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, &kCALayerLocationKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)associatedIndexPath
{
    return objc_getAssociatedObject(self, &kCALayerLocationKey);
}

@end
