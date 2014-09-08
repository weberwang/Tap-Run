//
//  MKBlock.h
//  Tap Run
//
//  Created by Minko on 14-9-7.
//  Copyright (c) 2014年 com.minko.taprun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MKBlock : SKSpriteNode
@property(nonatomic, readonly)NSUInteger widthNum;
@property(nonatomic, readonly)NSUInteger heigthNum;
+(MKBlock *) blockWithColor:(UIColor *)color widthNum:(NSInteger)width heigthNum:(NSInteger)heigth;

@end
