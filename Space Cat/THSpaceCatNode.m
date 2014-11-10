//
//  THSpaceCatNode.m
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THSpaceCatNode.h"

@interface THSpaceCatNode ()
@property (nonatomic) SKAction *tapAction;
@end

@implementation THSpaceCatNode

+ (instancetype) spaceCatAtPosition:(CGPoint)position {
    THSpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"SpaceCat1"];
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.position = position;
    spaceCat.zPosition = 9;
    spaceCat.name = @"SpaceCat";
    
    return spaceCat;
}

- (void) performTap {
    [self runAction:self.tapAction];
}

- (SKAction *) tapAction {
    if (_tapAction != nil) {
        return _tapAction;
    }
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"SpaceCat2"],
                         [SKTexture textureWithImageNamed:@"SpaceCat1"]];
    
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
    
    return _tapAction;
}

@end
