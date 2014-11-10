//
//  THGameOverNode.m
//  Space Cat
//
//  Created by Alex Alexander on 11/9/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THGameOverNode.h"

@implementation THGameOverNode

+ (instancetype) gameOverAtPosition:(CGPoint)position {
    THGameOverNode *gameOver = [self node];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    gameOverLabel.name = @"GameOverLabel";
    gameOverLabel.text = @"Game Over!";
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;
    [gameOver addChild:gameOverLabel];
    
    return gameOver;
}

- (void) performAnimation {
    SKLabelNode *label = (SKLabelNode*) [self childNodeWithName:@"GameOverLabel"];
    label.xScale = 0;
    label.yScale = 0;
    SKAction *scaleUp = [SKAction scaleTo:1.2f duration:0.75f];
    SKAction *scaleDown = [SKAction scaleTo:0.9f duration:0.25f];
    SKAction *run = [SKAction runBlock:^{
        SKLabelNode *touchToRestart = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        touchToRestart.text = @"touch to restart";
        touchToRestart.fontSize = 24;
        touchToRestart.position = CGPointMake(label.position.x, label.position.y-40);
        [self addChild:touchToRestart];
    }];
    
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown, run]];
    [label runAction:scaleSequence];
}

@end
