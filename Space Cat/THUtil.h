//
//  THUtil.h
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int THProjectileSpeed = 400;
static const int THSpaceDogMinSpeed = -100;
static const int THSpaceDogMaxSpeed = -50;
static const int THMaxLives = 4;
static const int THPointsPerHit = 100;

typedef NS_OPTIONS(uint32_t, THCollisionCategory) {
    THCollisionCategorySpaceDogA    = 1 << 0,
    THCollisionCategorySpaceDogB    = 1 << 1,
    THCollisionCategoryProjectile   = 1 << 2,
    THCollisionCategoryDebris       = 1 << 3,
    THCollisionCategoryGround       = 1 << 4
};

@interface THUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
