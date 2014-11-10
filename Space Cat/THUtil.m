//
//  THUtil.m
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THUtil.h"

@implementation THUtil

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random()%(max-min) + min;
}

@end
