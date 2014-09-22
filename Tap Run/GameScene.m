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
    GAME_READY,
    GAME_OVER,
    GAME_STOP,
} GameState;

typedef enum : NSUInteger {
    PlayerMask = 1<<0,
    PlatFormMask = 1<<1
} BodyMask;

@interface GameScene()
@property(nonatomic, strong) MKPlatform *platform;
@property(nonatomic, assign) NSUInteger gameState;
@property(nonatomic, strong) MKPlayer *player;
@property(nonatomic) BOOL allowJump;
@property(nonatomic) CGPoint startPoint;
-(void) initWorld;
-(void) reset;
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
    self.gameState = GAME_READY;
    self.allowJump = YES;
    
}

-(void)initWorld
{
    self.physicsWorld.gravity = CGVectorMake(0, -10);
    [self.physicsWorld removeAllJoints];
    self.physicsWorld.contactDelegate = self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (self.gameState) {
        case GAME_READY:
            [self startGame];
            break;
        case GAME_START:
            [self runGame];
            break;
        case GAME_OVER:
            [self reset];
            break;
        default:
            break;
    }
}

-(void) startGame
{
    self.view.paused  = NO;
    SKNode *node = [self childNodeWithName:@"tip"];
    [node removeFromParent];
    if(self.platform == nil)
    {
        self.backgroundColor = [SKColor whiteColor];
        [self initWorld];
        self.platform = [MKPlatform sharePlatform];
        //这里原来没有调用这个函数，会导致一个死循环
        [self.platform setMinHeight:2 max:6];
        [self.platform setTestMask:PlayerMask category:PlatFormMask];

        [self addChild:self.platform];
        [self.platform reset];
        
        self.player = [MKPlayer createPlayer];
        self.player.physicsBody.contactTestBitMask = PlatFormMask;
        self.player.physicsBody.categoryBitMask = PlayerMask;
        MKBlock *frist = (MKBlock*)self.platform.blocks.firstObject;
        self.startPoint = CGPointMake(frist.size.width/2 - self.player.size.width/2, frist.size.height + self.player.size.height/2);
        self.player.position = self.startPoint;
        [self addChild:self.player];
        
        self.gameState = GAME_START;
    }
}

-(void)reset
{
    self.view.paused = NO;
    if(self.platform)
    {
        [self.platform reset];
    }
    self.player.position = self.startPoint;
    
    self.gameState = GAME_START;
}

-(void) runGame
{
    if(self.allowJump != NO)
    {
      [self.player.physicsBody applyImpulse:CGVectorMake(0, 500*self.player.physicsBody.mass)];
        self.allowJump = NO;
    }
    else
    {
        if([self childNodeWithName:@"fixedNode"] == nil)
        {
            //            SKPhysicsJointFixed* fixed = [SKPhysicsJointFixed jointWithBodyA:self.player.physicsBody bodyB:fixedNode.physicsBody anchor:CGPointMake(fixedNode.position.x/2 + self.player.position.x/2, fixedNode.position.y/2 + self.player.position.y/2)];
//            [self.physicsWorld addJoint:fixed];
            SKNode *pinNode = [self createAnchor];
            [self createJointWithNodeA:pinNode nodeB:self.player];
        }
    }
}
-(void) createJointWithNodeA:(SKNode*) nodeA nodeB:(SKNode*) nodeB
{
//    SKNode* rope = [self createNopeWithpointA:nodeA.position pointB:nodeB.position];
    
//    SKPhysicsJointPin *pinA = [SKPhysicsJointPin jointWithBodyA:nodeA.physicsBody bodyB:rope.physicsBody anchor:nodeA.position];
//    SKPhysicsJointPin *pinB = [SKPhysicsJointPin jointWithBodyA:nodeB.physicsBody bodyB:rope.physicsBody anchor:nodeB.position];
    SKPhysicsJointLimit *limit = [SKPhysicsJointLimit jointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchorA:nodeA.position anchorB:nodeB.position];
//    [self.physicsWorld addJoint:pinA];
//    [self.physicsWorld addJoint:pinB];
    [self.physicsWorld addJoint:limit];
    __weak GameScene *mSelf = self;
    SKAction *remove = [SKAction sequence:@[[SKAction waitForDuration:0.5], [SKAction runBlock:^{
        __strong GameScene *bSelf = mSelf;
        [bSelf.physicsWorld removeAllJoints];
        bSelf.player.physicsBody.dynamic = NO;
        bSelf.player.physicsBody.dynamic = YES;
    }]]];
    [self runAction:remove];
//    ln.frame.size = CGSizeMake(;, <#CGFloat height#>)
}

-(SKNode*) createAnchor
{
    SKNode* pinNode = [SKNode node];
    pinNode.name = @"fixedNode";
    pinNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
    pinNode.physicsBody.dynamic = NO;
    pinNode.physicsBody.affectedByGravity = NO;
    pinNode.position = CGPointMake(self.player.position.x + 100, self.player.position.y);
    [self addChild:pinNode];
    return pinNode;
}
-(SKNode*) createNopeWithpointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
    double roation = atan((pointB.y - pointA.y)/(pointB.x - pointA.x))*180/M_PI;
    SKShapeNode *ln = [SKShapeNode shapeNodeWithEllipseOfSize:CGSizeMake([self lenghtWithPointA:pointA pointB:pointB], 1)];
    ln.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ln.frame.size];
    ln.physicsBody.affectedByGravity = NO;
//    ln.physicsBody.dynamic = NO;
    ln.physicsBody.categoryBitMask = 1 << 3;
    ln.zRotation = roation;
    ln.position = CGPointMake(pointB.x + ln.frame.size.width/2, pointB.y);
    [self addChild:ln];
    return  ln;
}
-(CGFloat) lenghtWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB
{
    float disY = pointB.y - pointA.y;
    float disX = pointB.x - pointA.x;
    float lenght = sqrtf((disX*disX)+(disY*disY));
    return lenght;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //和平台发生碰撞
    if((contact.bodyA.categoryBitMask == PlayerMask && contact.bodyB.categoryBitMask == PlatFormMask)
       || (contact.bodyA.categoryBitMask == PlatFormMask && contact.bodyB.categoryBitMask == PlayerMask))
    {
        SKNode* node = [self childNodeWithName:@"fixedNode"];
        node.physicsBody = nil;
        [node removeFromParent];
        [self.physicsWorld removeAllJoints];
        self.allowJump = YES;
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    [self.platform update:currentTime];
}

-(void)didSimulatePhysics
{
    MKBlock* firstBlock = (MKBlock*)self.platform.blocks.firstObject;
    if(firstBlock == nil) return;
    CGPoint firstPoint = [self convertPoint:firstBlock.position fromNode:self.platform];
    if(firstPoint.x < -firstBlock.size.width)
    {
        [self.platform.blocks removeObject:firstBlock];
        [firstBlock removeFromParent];
    }
    MKBlock* lastBlock = (MKBlock*) self.platform.blocks.lastObject;
    if(lastBlock)
    {
        CGPoint lastPoint = [self convertPoint:lastBlock.position fromNode:self.platform];
        if(lastPoint.x < self.size.width)
        {
            [self.platform createBlcok];
        }
    }
    //游戏失败的判断条件
    if(self.player.position.x < 0 || self.player.position.y < - self.player.size.height/2)
    {
        //暂停游戏并且给一个提示
        self.view.paused = YES;
        self.gameState = GAME_OVER;
        NSLog(@"游戏结束");
    }

}
@end
