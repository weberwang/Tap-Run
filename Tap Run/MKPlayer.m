//
//  MKPlayer.m
//  Tap Run
//
//  Created by Minko on 14-9-8.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import "MKPlayer.h"

@implementation MKPlayer
+(MKPlayer *)createPlayer
{
    MKPlayer *player = [MKPlayer spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(player.size.width - 1, player.size.height - 1)];
    player.physicsBody.dynamic = YES;
    player.physicsBody.friction = 0;
    player.physicsBody.restitution = 0;
    player.physicsBody.mass = 1000;
    player.physicsBody.allowsRotation = NO;
    return player;
}

@end
