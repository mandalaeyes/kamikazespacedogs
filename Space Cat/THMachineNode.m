//
//  THMachineNode.m
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THMachineNode.h"

@implementation THMachineNode

+ (instancetype) machineAtPosition:(CGPoint)position {
    THMachineNode *machine = [self spriteNodeWithImageNamed:@"Machine1"];
    machine.anchorPoint = CGPointMake(0.5, 0);
    machine.position = position;
    machine.zPosition = 8;
    machine.name = @"Machine";
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"Machine1"],
                          [SKTexture textureWithImageNamed:@"Machine2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
