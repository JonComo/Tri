//
//  TRMyScene.m
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "TRMyScene.h"
#import "JCControlPad.h"
#import "TRBox.h"
#import "TRPlayer.h"

@interface TRMyScene () <JCControlPadDelegate>
{
    TRPlayer *player;
    JCControlPad *movePad;
    JCControlPad *jumpPad;
    JCControlPad *strikePad;
}

@end

@implementation TRMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        SKSpriteNode *ground = [[SKSpriteNode alloc] initWithTexture:nil color:[UIColor orangeColor] size:CGSizeMake(640, 20)];
        ground.position = CGPointMake(0, 200);
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        [ground.physicsBody setDynamic:NO];
        [self addChild:ground];
        
        movePad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(80, 80, 100, 100) delegate:self];
        [self addChild:movePad];
        
        strikePad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(320 - 20 - 60 - 20 - 40, 80, 60, 100) delegate:self];
        [self addChild:strikePad];
        
        jumpPad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(320 - 60, 80, 60, 100) delegate:self];
        [self addChild:jumpPad];
        
        player = [[TRPlayer alloc] initWithPosition:CGPointMake(150, 450)];
        [self addChild:player];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        TRBox *box = [[TRBox alloc] initWithRect:CGRectMake(location.x, location.y, 20, 20) texture:nil color:[UIColor orangeColor]];
        box.physicsBody.mass = 0.001;
        [self addChild:box];
        
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    
    [player update:currentTime];
    [movePad update:currentTime];
}

-(void)controlPad:(JCControlPad *)pad changedInputWithDirection:(float)direction intensity:(float)intensity
{
    if (pad == movePad)
    {
        [player runInDirection:direction intensity:intensity];
    }
}

-(void)controlPad:(JCControlPad *)pad beganTouch:(UITouch *)touch
{
    if (pad == jumpPad)
        [player.physicsBody applyImpulse:CGPointMake(0, 20)];
    
    if (pad == strikePad)
        [player strike];
}

@end
