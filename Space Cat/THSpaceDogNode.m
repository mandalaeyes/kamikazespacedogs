//
//  THSpaceDogNode.m
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THSpaceDogNode.h"
#import "THUtil.h"

@implementation THSpaceDogNode

+ (instancetype) spaceDogOfType:(THSpaceDogType)type {
    THSpaceDogNode *spaceDog;
    
    NSArray *textures;
    int goreType;
    
    if (type == THSpaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"NakedDog1"];
        textures = @[[SKTexture textureWithImageNamed:@"NakedDog1"],
                     [SKTexture textureWithImageNamed:@"NakedDog2"],
                     [SKTexture textureWithImageNamed:@"NakedDog3"]];
        goreType = 1;

    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"SaucerDog1"];
        textures = @[[SKTexture textureWithImageNamed:@"SaucerDog1"],
                     [SKTexture textureWithImageNamed:@"SaucerDog2"],
                     [SKTexture textureWithImageNamed:@"SaucerDog3"]];
        goreType = 2;
    }
    
    float scale = [THUtil randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    
    [spaceDog setupPhysicsBodyOfType:goreType];
    
    return spaceDog;
}

- (void) setupPhysicsBodyOfType:(int)type {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.collisionBitMask = 0;
    if (type == 1) {
        self.physicsBody.categoryBitMask = THCollisionCategorySpaceDogA;
    } else {
        self.physicsBody.categoryBitMask = THCollisionCategorySpaceDogB;
    }
    self.physicsBody.contactTestBitMask = THCollisionCategoryProjectile | THCollisionCategoryGround;
}

@end
