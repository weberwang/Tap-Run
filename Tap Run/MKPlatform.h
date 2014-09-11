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
/**
 *  单列
 *
 *  @return 返回当前游戏实用的物体平台
 */
+(MKPlatform *) sharePlatform;
/**
 *  重置平台
 */
-(void) reset;
/**
 *  在游戏的最右端创建一个block
 *
 *  @return 返回创建的block
 */
-(MKBlock *)createBlcok;
/**
 *  设置类别掩码和接触掩码
 *
 *  @param contactTestBitMask <#contactTestBitMask description#>
 *  @param categoryBitMask    <#categoryBitMask description#>
 */
-(void) setTestMask:(uint32_t)contactTestBitMask category:(uint32_t)categoryBitMask;
/**
 *  平台自己滚动的处理
 *
 *  @param currentTime <#currentTime description#>
 */
-(void)update:(NSTimeInterval) currentTime;
/**
 *  设置平台的最高和最矮值，方便调试到最忧
 *
 *  @param min <#min description#>
 *  @param max <#max description#>
 */
-(void)setMinHeight:(NSUInteger)min max:(NSUInteger)max;
@end
