//
//  THTitleScene.m
//  Space Cat
//
//  Created by Alex Alexander on 11/7/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THTitleScene.h"
#import "THGameplayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface THTitleScene ()
@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@end

@implementation THTitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"title"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.wav"
                                        waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"TitleScreen" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1;
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.backgroundMusic stop];
    [self runAction:self.pressStartSFX];
    
    THGameplayScene *gameplayScene = [THGameplayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    [self.view presentScene:gameplayScene transition:transition];
}


@end
