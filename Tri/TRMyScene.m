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
    SKNode *wallsNode;
    
    MZMaze *maze;
    
    TRPlayer *player;
    JCControlPad *movePad;
    JCControlPad *jumpPad;
    JCControlPad *strikePad;
    
    SKSpriteNode *mini;
}

@end

@implementation TRMyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        sceneNode = [SKNode new];
        [self addChild:sceneNode];
        
        wallsNode = [SKNode new];
        [self addChild:wallsNode];
        
        self.physicsWorld.gravity = CGPointZero;
        
        int controlSize = 80;
        
        movePad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(self.size.width/4, self.size.height/2, self.size.width/2, self.size.height) delegate:self];
        movePad.alpha = 0;
        [self addChild:movePad];
        
        strikePad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(size.width - controlSize, controlSize, controlSize, controlSize) delegate:self];
        strikePad.alpha = 0.2;
        [self addChild:strikePad];
        
        //jumpPad = [[JCControlPad alloc] initWithTouchRegion:CGRectMake(320 - 60, 80, 60, 100) delegate:self];
        //[self addChild:jumpPad];
        
        player = [[TRPlayer alloc] initWithPosition:CGPointMake(size.width/2, size.height/2)];
        player.physicsWorld = self.physicsWorld;
        [sceneNode addChild:player];
        
        maze = [[MZMaze alloc] initWithSize:CGSizeMake(10, 10)];
        
        mini = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:[maze render]] color:nil size:CGSizeMake(100, 100)];
        mini.position = CGPointMake(50, self.size.height - 50);
        [sceneNode addChild:mini];
        
        [self drawRoomAtX:maze.currentRoom.x y:maze.currentRoom.y];
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
        [box.physicsBody setDynamic:YES];
        [sceneNode addChild:box];
    }
}

-(void)switchRooms
{
    CGPoint offsetRoom = maze.currentRoom;
    BOOL shouldChange = NO;
    
    if (player.position.x < 0){
        player.position = CGPointMake(player.position.x + self.size.width, player.position.y);
        offsetRoom = CGPointMake(offsetRoom.x - 1, offsetRoom.y);
        shouldChange = YES;
    }
    
    if (player.position.x > self.size.width){
        player.position = CGPointMake(player.position.x - self.size.width, player.position.y);
        offsetRoom = CGPointMake(offsetRoom.x + 1, offsetRoom.y);
        shouldChange = YES;
    }
    
    if (player.position.y < 0){
        player.position = CGPointMake(player.position.x, player.position.y + self.size.height);
        offsetRoom = CGPointMake(offsetRoom.x, offsetRoom.y + 1);
        shouldChange = YES;
    }
    
    if (player.position.y > self.size.height){
        player.position = CGPointMake(player.position.x, player.position.y - self.size.height);
        offsetRoom = CGPointMake(offsetRoom.x, offsetRoom.y - 1);
        shouldChange = YES;
    }
    
    if (shouldChange)
        [self drawRoomAtX:offsetRoom.x y:offsetRoom.y];
}

-(void)drawRoomAtX:(int)x y:(int)y
{
    MZRoom *newRoom = [maze roomAtX:x y:y checkFound:NO];
    
    if (!newRoom) return;
    
    [wallsNode removeAllChildren];
    
    int s = 20;
    UIColor *color = [UIColor orangeColor];
    
    NSLog(@"ROOM: N:%i S:%i E:%i W:%i", newRoom.N, newRoom.S, newRoom.E, newRoom.W);
    
    
    if (!newRoom.S){
        TRBox *wall = [[TRBox alloc] initWithRect:CGRectMake(self.size.width/2, self.size.height, self.size.width, s) texture:nil color:color];
        [wallsNode addChild:wall];
    }
    
    if (!newRoom.N){
        TRBox *wall = [[TRBox alloc] initWithRect:CGRectMake(self.size.width/2, 0, self.size.width, s) texture:nil color:color];
        [wallsNode addChild:wall];
    }
    
    if (!newRoom.E){
        TRBox *wall = [[TRBox alloc] initWithRect:CGRectMake(self.size.width, self.size.height/2, s, self.size.height) texture:nil color:color];
        [wallsNode addChild:wall];
    }
    
    if (!newRoom.W){
        TRBox *wall = [[TRBox alloc] initWithRect:CGRectMake(0, self.size.height/2, s, self.size.height) texture:nil color:color];
        [wallsNode addChild:wall];
    }
    
    mini.texture = [SKTexture textureWithImage:[maze render]];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    
    [player update:currentTime];
    [movePad update:currentTime];
    [strikePad update:currentTime];
    
    [self switchRooms];
}

-(void)controlPad:(JCControlPad *)pad changedInputWithDirection:(float)direction intensity:(float)intensity
{
    if (pad == movePad){
        [player runInDirection:direction intensity:intensity];
    }
    
    if (pad == strikePad)
    {
        [player strike:YES direction:direction intensity:intensity];
    }
}

-(void)controlPad:(JCControlPad *)pad endedTouch:(UITouch *)touch
{
    if (pad == strikePad){
        [player strike:NO direction:0 intensity:0];
    }
}

@end
