//
//  MKBlock.m
//  Tap Run
//
//  Created by Minko on 14-9-7.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import "MKBlock.h"


const NSInteger widthUint = 100;
const NSInteger heightUint = 60;
@interface MKBlock()

@end

@implementation MKBlock

+(MKBlock *)blockWithColor:(UIColor *)color widthNum:(NSInteger)width heigthNum:(NSInteger)heigth
{
    MKBlock *block = [[MKBlock alloc] initWithColor:color size:CGSizeMake(width * widthUint, heigth * heightUint)];
    return block;
}

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    if(self = [super initWithColor:color size:size])
    {
        _widthNum = size.width/widthUint;
        _heightNum = size.height/heightUint;
        self.anchorPoint = CGPointMake(0, 0);
        SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        body.restitution = 0;
        body.friction = 0;
        body.dynamic = NO;
        self.physicsBody = body;
    }
    return self;
}

@end
