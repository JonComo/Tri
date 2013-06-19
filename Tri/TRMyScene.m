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
#import "MZMaze.h"

@interface TRMyScene () <JCControlPadDelegate>
{
    SKNode *sceneNode;
    
    MZMaze *maze;
    
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
        
        sceneNode = [SKNode new];
        [self addChild:sceneNode];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsWorld.gravity = CGPointZero;
        
        movePad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(80, 80, 100, 100) delegate:self];
        [self addChild:movePad];
        
        strikePad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(320 - 20 - 60 - 20 - 40, 80, 60, 100) delegate:self];
        [self addChild:strikePad];
        
        //jumpPad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(320 - 60, 80, 60, 100) delegate:self];
        //[self addChild:jumpPad];
        
        player = [[TRPlayer alloc] initWithPosition:CGPointMake(300, 300)];
        [sceneNode addChild:player];
        
        maze = [[MZMaze alloc] initWithSize:CGSizeMake(100, 5)];
        
        CGSize roomSize = CGSizeMake(300, 300);
        float wallThickness = 10;
        
        [maze iterateRooms:^(MZRoom *room, int x, int y) {
            
            if (!room.N)
                [sceneNode addChild:[[TRBox alloc] initWithRect:CGRectMake(x * roomSize.width, y * roomSize.height + roomSize.height/2, roomSize.width, wallThickness) texture:nil color:[UIColor orangeColor]]];
            
            if (!room.S)
                [sceneNode addChild:[[TRBox alloc] initWithRect:CGRectMake(x * roomSize.width, y * roomSize.height - roomSize.height/2, roomSize.width, wallThickness) texture:nil color:[UIColor orangeColor]]];
            
            if (!room.E)
                [sceneNode addChild:[[TRBox alloc] initWithRect:CGRectMake(x * roomSize.width + roomSize.width/2, y * roomSize.height, wallThickness, roomSize.height) texture:nil color:[UIColor orangeColor]]];
            
            if (!room.W)
                [sceneNode addChild:[[TRBox alloc] initWithRect:CGRectMake(x * roomSize.width - roomSize.width/2, y * roomSize.height, wallThickness, roomSize.height) texture:nil color:[UIColor orangeColor]]];
            
        }];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:sceneNode];
        
        TRBox *box = [[TRBox alloc] initWithRect:CGRectMake(location.x, location.y, 20, 20) texture:nil color:[UIColor orangeColor]];
        box.physicsBody.mass = 0.001;
        [sceneNode addChild:box];
        
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    
    [player update:currentTime];
    [movePad update:currentTime];
}

-(void)didSimulatePhysics
{
    sceneNode.position = CGPointMake(-player.position.x + 160, -player.position.y + 300);
}

-(void)controlPad:(JCControlPad *)pad changedInputWithDirection:(float)direction intensity:(float)intensity
{
    if (pad == movePad){
        [player runInDirection:direction intensity:intensity];
    }
}

-(void)controlPad:(JCControlPad *)pad beganTouch:(UITouch *)touch
{
    if (pad == strikePad){
        [player strike:YES];
    }
}

-(void)controlPad:(JCControlPad *)pad endedTouch:(UITouch *)touch
{
    if (pad == strikePad){
        [player strike:NO];
    }
}

@end
