//
//  THProjectileNode.h
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THProjectileNode : SKSpriteNode

+ (instancetype) projectileAtPosition:(CGPoint)position;
- (void) moveTowardPosition:(CGPoint)position;

@end
