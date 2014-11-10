//
//  THGameOverNode.h
//  Space Cat
//
//  Created by Alex Alexander on 11/9/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THGameOverNode : SKNode

+ (instancetype) gameOverAtPosition:(CGPoint)position;
- (void) performAnimation;

@end
