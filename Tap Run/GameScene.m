//
//  GameScene.m
//  Tap Run
//
//  Created by Minko on 14-8-27.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import "GameScene.h"
#import "MKPlatform.h"
#import "MKPlayer.h"
#import "MKBlock.h"

typedef enum : NSUInteger {
    GAME_START = 0,
    GAME_OVER,
    GAME_STOP,
} GameState;
@interface GameScene()
@property(nonatomic) MKPlatform *platform;
@property(nonatomic) NSUInteger gameState;
@property(nonatomic) MKPlayer *player;
-(void) initWorld;
@end
@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blueColor];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.6];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.6];
    SKAction *link = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
    SKLabelNode *tipLbl = [SKLabelNode labelNodeWithText:@"Tap to start"];
    tipLbl.name = @"tip";
    tipLbl.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:tipLbl];
    [tipLbl runAction:link];
    self.gameState = GAME_OVER;
}

-(void)initWorld
{
    self.physicsWorld.gravity = CGVectorMake(0, -10);
    [self.physicsWorld removeAllJoints];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (self.gameState) {
        case GAME_OVER:
            [self startGame];
            break;
        case GAME_START:
            [self runGame];
            break;
        default:
            break;
    }
}

-(void) startGame
{
    SKNode *node = [self childNodeWithName:@"tip"];
    [node removeFromParent];
    if(self.platform == nil)
    {
        self.backgroundColor = [SKColor whiteColor];
        [self initWorld];
        self.platform = [MKPlatform sharePlatform];
        [self addChild:self.platform];
        [self.platform reset];
        
        self.player = [MKPlayer createPlayer];
        MKBlock *frist = (MKBlock*)self.platform.blocks.firstObject;
        self.player.position = CGPointMake(self.player.size.width/2, frist.size.height + self.player.size.height/2);
        [self addChild:self.player];
        
        self.gameState = GAME_START;
    }
}

-(void) runGame
{
    if(self.player.physicsBody.velocity.dy == 0)
    {
      [self.player.physicsBody applyImpulse:CGVectorMake(0, 500*self.player.physicsBody.mass)];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    
}

@end
