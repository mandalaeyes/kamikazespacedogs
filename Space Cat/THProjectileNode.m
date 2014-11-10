//
//  THProjectileNode.m
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THProjectileNode.h"
#import "THUtil.h"

@implementation THProjectileNode

+ (instancetype) projectileAtPosition:(CGPoint)position {
    THProjectileNode *projectile = [self spriteNodeWithImageNamed:@"Projectile1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];
    [projectile setupPhysicsBody];
    
    return projectile;
}

- (void) setupAnimation {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"Projectile1"],
                          [SKTexture textureWithImageNamed:@"Projectile2"],
                          [SKTexture textureWithImageNamed:@"Projectile3"]];
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
}

- (void) moveTowardPosition:(CGPoint)position {
    // Slope = (Y3 -Y1) / (X3 - X1)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    // Slope = (Y2 - Y1) / (X2 - X1)
    // Y2 - Y1 = slope (X2 - X1)
    // Y2 = (slope * X2) - (slope * X1) + Y1
    float offscreenX;
    if (position.x <= self.position.x) {
        offscreenX = -10;
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
    
    // Distance = Speed * Time
    // Time = Distance / Speed
    float time = distanceC / THProjectileSpeed;
    float waitToFade = time * 0.75;
    float fadeTime = time - waitToFade;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    [self runAction:moveProjectile];
    
    NSArray *animationSequence = @[[SKAction waitForDuration:waitToFade],
                                   [SKAction fadeOutWithDuration:fadeTime],
                                   [SKAction removeFromParent]];
    [self runAction:[SKAction sequence:animationSequence]];
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = THCollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = THCollisionCategorySpaceDogA | THCollisionCategorySpaceDogB;
}

@end

























