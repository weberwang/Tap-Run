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
+(MKPlatform *) sharePlatform;
-(void) reset;
-(MKBlock *)createBlcok;

@end
