//
//  MKBlock.h
//  Tap Run
//
//  Created by Minko on 14-9-7.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MKBlock : SKSpriteNode
@property(nonatomic, readonly, assign)NSUInteger widthNum;
@property(nonatomic, readonly, assign)NSUInteger heightNum;
+(MKBlock *) blockWithColor:(UIColor *)color widthNum:(NSInteger)width heigthNum:(NSInteger)heigth;

@end
