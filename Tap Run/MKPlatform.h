//
//  MKPlatform.h
//  Tap Run
//
//  Created by Minko on 14-9-7.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MKBlock;
@interface MKPlatform : SKNode
@property(nonatomic) NSMutableArray* blocks;
@property(nonatomic, assign) float speed;
@property(nonatomic, readonly, assign) uint32_t contactTestBitMask;
@property(nonatomic, readonly, assign) uint32_t categoryBitMask;
+(MKPlatform *) sharePlatform;
-(void) reset;
-(MKBlock *)createBlcok;
-(void) setTestMask:(uint32_t)contactTestBitMask category:(uint32_t)categoryBitMask;
-(void)update:(NSTimeInterval) currentTime;
@end
