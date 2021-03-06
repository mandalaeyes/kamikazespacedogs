//
//  THGameplayScene.m
//  Space Cat
//
//  Created by Alex Alexander on 11/7/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "THGameplayScene.h"
#import "THMachineNode.h"
#import "THSpaceCatNode.h"
#import "THProjectileNode.h"
#import "THSpaceDogNode.h"
#import "THGroundNode.h"
#import "THUtil.h"
#import "THHudNode.h"
#import "THGameOverNode.h"


@interface THGameplayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *shootSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL gameOverDisplayed;
@property (nonatomic) BOOL restart;

@end

@implementation THGameplayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = THSpaceDogMinSpeed;
        self.gameOver = NO;
        self.gameOverDisplayed = NO;
        self.restart = NO;
        
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        THMachineNode *machine = [THMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        THSpaceCatNode *spaceCat = [THSpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y-2)];
        [self addChild:spaceCat];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        THGroundNode *ground = [THGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 30)];
        [self addChild:ground];
        
        [self setupSounds];
        
        THHudNode *hud = [THHudNode hudAtPosition:CGPointMake(0, self.frame.size.height-20) inFrame:self.frame];
        [self addChild:hud];
        
    }
    return self;
}

- (void) setupSounds {
    NSURL *gameplayURL = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameplayURL error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"Gameover" withExtension:@"mp3"];
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 0;
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Hurt.wav"
                                waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explosion.wav"
                                waitForCompletion:NO];
    self.shootSFX = [SKAction playSoundFileNamed:@"Shoot.wav"
                                waitForCompletion:NO];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver) {
        for (UITouch *touch in touches) {
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardPosition:position];
        }
    } else if (self.restart) {
        for (SKNode *node in self.children) {
            [node removeFromParent];
        }
        
        THGameplayScene *scene = [THGameplayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void) performGameOver {
    THGameOverNode *gameOver = [THGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    [gameOver performAnimation];
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
    
    THSpaceCatNode *spaceCat = (THSpaceCatNode*) [self childNodeWithName:@"SpaceCat"];
    THMachineNode *machine = (THMachineNode*) [self childNodeWithName:@"Machine"];
    [self runAction:self.explodeSFX];
    [self createGoreAtPosition:CGPointMake(spaceCat.position.x, spaceCat.position.y+10) type:3];
    [self createDebrisAtPosition:CGPointMake(machine.position.x, machine.position.y+10) type:3];
    [spaceCat removeFromParent];
    [machine removeFromParent];
    
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) shootProjectileTowardPosition:(CGPoint)position {
    
    THSpaceCatNode *spaceCat = (THSpaceCatNode*) [self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    THMachineNode *machine = (THMachineNode *) [self childNodeWithName:@"Machine"];
    
    THProjectileNode *projectile = [THProjectileNode projectileAtPosition:CGPointMake(machine.position.x,
                                                                                      machine.position.y+machine.frame.size.height-10)];
    [self addChild:projectile];
    [projectile moveTowardPosition:position];
    
    [self runAction:self.shootSFX];
}



- (void) addSpaceDog {
    NSUInteger randomSpaceDog = [THUtil randomWithMin:0 max:2];
    
    THSpaceDogNode *spaceDog = [THSpaceDogNode spaceDogOfType:randomSpaceDog];
    
    float dy = [THUtil randomWithMin:THSpaceDogMinSpeed max:THSpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [THUtil randomWithMin:10+spaceDog.size.width
                                max:self.frame.size.width-10-spaceDog.size.width];
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
}

- (void) update:(NSTimeInterval)currentTime {
    
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (self.totalGameTime > 480) {
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = -160;
    } else if (self.totalGameTime > 240) {
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if (self.totalGameTime > 120) {
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if (self.totalGameTime > 30) {
        self.addEnemyTimeInterval = 1.0;
        self.minSpeed = -100;
    }
    
    if (self.gameOver && !self.gameOverDisplayed) {
        [self performGameOver];
    }
}


- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    int debrisType;
    
    if (firstBody.categoryBitMask == THCollisionCategorySpaceDogA &&
        secondBody.categoryBitMask == THCollisionCategoryProjectile) {
        
        THSpaceDogNode *spaceDog = (THSpaceDogNode*) firstBody.node;
        THProjectileNode *projectile = (THProjectileNode*) secondBody.node;
        
        [self addPoints:THPointsPerHit];
        
        [self runAction:self.explodeSFX];
        
        debrisType = 1;
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        
    } else if (firstBody.categoryBitMask == THCollisionCategorySpaceDogB &&
               secondBody.categoryBitMask == THCollisionCategoryProjectile) {
        
        THSpaceDogNode *spaceDog = (THSpaceDogNode*) firstBody.node;
        THProjectileNode *projectile = (THProjectileNode*) secondBody.node;
        
        [self addPoints:THPointsPerHit];
        
        [self runAction:self.explodeSFX];
        
        debrisType = 2;
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        
    } else if (firstBody.categoryBitMask == THCollisionCategorySpaceDogA &&
               secondBody.categoryBitMask == THCollisionCategoryGround) {
        
        THSpaceDogNode *spaceDog = (THSpaceDogNode*) firstBody.node;

        [self runAction:self.damageSFX];
        
        debrisType = 1;
        
        [spaceDog removeFromParent];
        
        [self loseLife];
    } else if (firstBody.categoryBitMask == THCollisionCategorySpaceDogB &&
               secondBody.categoryBitMask == THCollisionCategoryGround) {
        
        THSpaceDogNode *spaceDog = (THSpaceDogNode*) firstBody.node;
        
        [self runAction:self.damageSFX];
        
        debrisType = 2;
        
        [spaceDog removeFromParent];
        
        [self loseLife];
    }
    [self createGoreAtPosition:contact.contactPoint type:debrisType];
    [self createDebrisAtPosition:contact.contactPoint type:debrisType];
}

- (void) addPoints:(NSInteger)points {
    THHudNode *hud = (THHudNode*) [self childNodeWithName:@"HUD"];
    [hud addPoints:THPointsPerHit];
}

- (void) loseLife {
    THHudNode *hud = (THHudNode*) [self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

- (void) createDebrisAtPosition:(CGPoint)position type:(int)type {
    NSInteger numberOfPieces;
    
    if (type == 1) {
        numberOfPieces = [THUtil randomWithMin:2 max:5];
    } else {
        numberOfPieces = [THUtil randomWithMin:5 max:10];
    }
    
    for (int i=0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [THUtil randomWithMin:1 max:4];
        NSString *imageName;
        
        if (type ==1) {
            imageName = @"debri_1";
        } else if (type == 2) {
            imageName = [NSString stringWithFormat:@"debri_%d", randomPiece];
        } else {
            imageName = [NSString stringWithFormat:@"MachineDebris%d", randomPiece];
        }
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        debris.name = @"Debris";
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        
        // Subtly randomize debris size
        float scale = [THUtil randomWithMin:85 max:100] / 100.0f;
        debris.xScale = scale;
        debris.yScale = scale;
        
        debris.physicsBody.categoryBitMask = THCollisionCategoryDebris;
        debris.physicsBody.collisionBitMask = THCollisionCategoryGround | THCollisionCategoryDebris;

        
        debris.physicsBody.velocity = CGVectorMake([THUtil randomWithMin:-150 max:150],
                                                   [THUtil randomWithMin:200 max:350]);
        if (type == 3) {
        } else {
            [debris runAction:[SKAction waitForDuration:2.0] completion:^{
                [debris runAction:[SKAction fadeAlphaTo:0 duration:0.1] completion:^{
                    [debris removeFromParent];
                }];
            }];
        }
    }
    
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
     }];
}

- (void) createGoreAtPosition:(CGPoint)position type:(int)type {
    NSInteger numberOfPieces = [THUtil randomWithMin:4 max:9];
    
    for (int i=0; i < numberOfPieces; i++) {
        
        NSInteger randomPiece = [THUtil randomWithMin:1 max:3];
        NSString *imageName;
        
        if (type == 1) {
            imageName = [NSString stringWithFormat:@"GreenDogGore%d", randomPiece];
        } else if (type == 2) {
            imageName = [NSString stringWithFormat:@"PinkDogGore%d", randomPiece];
        } else if (type == 3) {
            imageName = [NSString stringWithFormat:@"CatGore%d", randomPiece];
        }
        
        SKSpriteNode *gore = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        gore.position = position;
        [self addChild:gore];
        gore.name = @"Gore";
        gore.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gore.frame.size];
        
        // Subtly randomize gore size
        float scale = [THUtil randomWithMin:85 max:100] / 100.0f;
        gore.xScale = scale;
        gore.yScale = scale;
        
        gore.physicsBody.categoryBitMask = THCollisionCategoryDebris;
        gore.physicsBody.collisionBitMask = THCollisionCategoryGround | THCollisionCategoryDebris;
        
        
        gore.physicsBody.velocity = CGVectorMake([THUtil randomWithMin:-200 max:200],
                                                   [THUtil randomWithMin:250 max:450]);
        if (type == 3) {
        } else {
            [gore runAction:[SKAction waitForDuration:2.0] completion:^{
                [gore runAction:[SKAction fadeAlphaTo:0 duration:0.1] completion:^{
                    [gore removeFromParent];
                }];
            }];
        }
    }
}

@end





















