//
//  TRObject.h
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TRObject : SKSpriteNode

@property (nonatomic, weak) SKPhysicsWorld *physicsWorld;
-(void)update:(CFTimeInterval)currentTime;

@end