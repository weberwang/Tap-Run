//
//  MKPlatform.m
//  Tap Run
//
//  Created by Minko on 14-9-7.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import "MKPlatform.h"
#import "MKBlock.h"
@interface MKPlatform()
@property(nonatomic, strong) UIColor *platformColor;
@property(nonatomic, assign) NSUInteger minHeight;
@property(nonatomic, assign) NSUInteger maxHeight;
/**
 *  检测最后一个block并返回下一个生成的block的高和宽
 *
 *  @return 包含宽高的数组
 */
-(NSArray*) checkBlock;
/**
 *  在指定的范围内根据最后一个block随机生成一个高度的block
 *
 *  @param block 最后一个block
 *  @param max   指定范围
 *
 *  @return 返回需要生成的高度
 */
-(NSUInteger) randomHeigthWithLast:(MKBlock*)block maxHeigth:(NSUInteger)max;
@end

@implementation MKPlatform

+(MKPlatform *)sharePlatform
{
    __strong static MKPlatform* platform = nil;
    static dispatch_once_t pre = 0;
    dispatch_once(&pre, ^{
        platform = [[super alloc] init];
        srandom(time(0));
    });
    return platform;
}

-(void)setMinHeight:(NSUInteger)min max:(NSUInteger)max
{
    NSAssert(min<max, @"设置高度范围不正确");
    _minHeight = min;
    _maxHeight = max;
}
-(void)reset
{
    //设置平台颜色
    CGFloat red = random()/(RAND_MAX*1.0f);
    CGFloat green = random()/(RAND_MAX*1.0f);
    CGFloat blue = random()/(RAND_MAX*1.0f);
    _platformColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //初始化块容器
    if (self.blocks == nil) {
        self.blocks = [NSMutableArray arrayWithCapacity:(NSInteger)self.scene.size.width/50];
    }
    else
    {
        [self removeAllChildren];
        [self.blocks removeAllObjects];
    }
    int count = self.scene.size.width/50;
    for (int i = 0; i < count; i ++) {
        [self createBlcok];
    }
    self.speed = 5;
}

-(MKBlock *)createBlcok
{
    NSArray* pos = [self checkBlock];

    MKBlock *block = [MKBlock blockWithColor:_platformColor widthNum:((NSNumber*)pos.firstObject).integerValue heigthNum:((NSNumber*)pos.lastObject).integerValue];
    MKBlock *lastBlock = (MKBlock*) self.blocks.lastObject;
    if(lastBlock != nil)
    {
        float px = lastBlock.position.x + lastBlock.size.width;
        block.position = CGPointMake(px, 0);
    }
    block.physicsBody.categoryBitMask= self.categoryBitMask;
    block.physicsBody.contactTestBitMask = self.contactTestBitMask;
    [self addChild:block];
    [self.blocks addObject:block];
    return block;
}

-(NSArray*)checkBlock
{
    NSUInteger width = 0;
    NSUInteger heigth = 0;
    MKBlock *lastBlock = (MKBlock*) self.blocks.lastObject;
   
    if(lastBlock != nil)
    {
        heigth = [self randomHeigthWithLast:lastBlock maxHeigth:4];
        if(heigth == 0)
        {
            width = 1;
        }
        else
        {
            width = arc4random()%2 + 1;
        }
    }
    else
    {
        width = 2;
        heigth = 7;
    }
    return [NSArray arrayWithObjects:[NSNumber numberWithInteger:width], [NSNumber numberWithInteger:heigth], nil];
}

-(NSUInteger)randomHeigthWithLast:(MKBlock *)block maxHeigth:(NSUInteger)max
{
    NSUInteger randomHegith = 0;
    if(block.heightNum == 0)
    {
        if(self.blocks && self.blocks.count > 1)
        {
            MKBlock *lastSecond = (MKBlock *)[self.blocks objectAtIndex:self.blocks.count - 2];
            if(lastSecond != nil)
            {
               randomHegith = [self randomHeigthWithLast:lastSecond maxHeigth:3]; 
            }
            
        }
    }
    else
    {
        NSUInteger rAdd = arc4random()%max;
        switch (rAdd) {
                //增加
            case 0:
                randomHegith = block.heightNum + 1;
                randomHegith = randomHegith > _maxHeight ?_maxHeight:randomHegith;
                break;
                //下降
            case 1:
                if(block.heightNum > 1)
                {
                    NSUInteger mHeigth = arc4random()%3;
                    randomHegith = block.heightNum - mHeigth;
                    randomHegith = randomHegith < _minHeight ?_minHeight:randomHegith;
                }
                break;
            case 2:
                randomHegith = block.heightNum;
                break;
            default:
                if(block.heightNum != 0)
                {
                    randomHegith = 0;
                }
                break;
        }

    }
    return randomHegith;
}

-(void) setTestMask:(uint32_t)contactTestBitMask category:(uint32_t)categoryBitMask
{
    _contactTestBitMask = contactTestBitMask;
    _categoryBitMask = categoryBitMask;
    for (MKBlock* block in self.blocks) {
        block.physicsBody.contactTestBitMask = contactTestBitMask;
        block.physicsBody.categoryBitMask = categoryBitMask;
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    CGPoint pos = self.position;
    pos.x -= self.speed;
    self.position = pos;
}

@end
