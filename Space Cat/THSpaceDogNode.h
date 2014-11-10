//
//  THSpaceDogNode.h
//  Space Cat
//
//  Created by Alex Alexander on 11/8/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, THSpaceDogType) {
    THSpaceDogTypeA = 0,
    THSpaceDogTypeB = 1
};

@interface THSpaceDogNode : SKSpriteNode

+ (instancetype) spaceDogOfType:(THSpaceDogType)type;

@end
