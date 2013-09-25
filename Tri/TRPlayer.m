//
//  TRPlayer.m
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "TRPlayer.h"
#import "JCMath.h"

@implementation TRPlayer
{
    SKAction *actionRun;
    SKAction *actionStanding;
    
    BOOL isRunning;
    
    SKSpriteNode *wielding;
    SKPhysicsJointPin *wieldingJoint;
}

-(id)initWithPosition:(CGPoint)position
{
    if (self = [super init]) {
        //init
        self.color = [UIColor redColor];
        
        self.size = CGSizeMake(80, 80);
        self.position = position;
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self trianglePath].CGPath];
        self.physicsBody.allowsRotation = YES;
        
        self.physicsBody.mass = 1.0;
        [self.physicsBody setAllowsRotation:NO];
        
        actionRun = [self animationFromAtlas:@"running"];
        actionStanding = [self animationFromAtlas:@"standing"];
        
        [self runAction:[SKAction repeatActionForever:actionStanding]];
    }
    
    return self;
}

-(UIBezierPath *)trianglePath
{
    UIBezierPath *triangle = [UIBezierPath new];
    
    [triangle moveToPoint:      CGPointMake(-self.size.width/4, -self.size.height/2)];
    [triangle addLineToPoint:   CGPointMake(self.size.width/4, -self.size.height/2)];
    [triangle addLineToPoint:   CGPointMake(0, self.size.height/2 - 15)];
    [triangle closePath];
    
    return triangle;
}

-(SKAction *)animationFromAtlas:(NSString *)atlasName
{    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    
    NSMutableArray *frameNames = [atlas.textureNames mutableCopy];
    NSMutableArray *frames = [NSMutableArray array];
    
    [frameNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSString *name in frameNames)
        [frames addObject:[atlas textureNamed:name]];
    
    return [SKAction animateWithTextures:frames timePerFrame:0.1];
}

-(void)runInDirection:(float)direction intensity:(float)intensity
{
    intensity *= 400;
    
    float degrees = direction * 180/M_PI;
    
    float sectioned = round(degrees / 45) * 45;
    
    direction = sectioned * M_PI/180;
    
    CGVector force = CGVectorMake(cosf(direction) * intensity, sinf(direction) * intensity);
    [self.physicsBody applyForce:force];
    
    self.xScale = force.dx > 0 ? 1 : -1;
}

-(void)update:(CFTimeInterval)currentTime
{
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx * 0.8, self.physicsBody.velocity.dy * 0.8);
}

-(void)strike:(BOOL)strike direction:(float)direction intensity:(float)intensity
{
    if (strike)
    {
        if (!wielding)
        {
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"items"];
            SKTexture *swordTex = [atlas textureNamed:@"sword"];
            wielding = [[SKSpriteNode alloc] initWithTexture:swordTex color:nil size:CGSizeMake(swordTex.size.width/2, swordTex.size.height/2)];
            
            wielding.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wielding.size];
            wielding.physicsBody.mass = 0.02;
        }
        
        if (!wielding.parent)
        {
            //wielding.position = [JCMath pointFromPoint:self.position pushedBy:70 inDirection:M_PI];
            //[wielding runAction:[SKAction rotateToAngle:runDirection - M_PI_2 duration:0]];
            
            [self.parent addChild:wielding];
            
            wielding.position = CGPointMake(self.position.x + (self.xScale > 0 ? 50 : -50), self.position.y + 30);
            
            wieldingJoint = [SKPhysicsJointPin jointWithBodyA:self.physicsBody bodyB:wielding.physicsBody anchor:CGPointMake(100, 100)];
            
            wieldingJoint.frictionTorque = 0.1;
            
            [self.physicsWorld addJoint:wieldingJoint];
        }
        
        CGPoint strikePoint = [JCMath pointFromPoint:CGPointZero pushedBy:300 inDirection:direction];
        [wielding.physicsBody applyForce:CGVectorMake(strikePoint.x, strikePoint.y)];
        
        NSLog(@"Position: %f %f", wielding.position.x, wielding.position.y);
        
    }else{
        [self.physicsWorld removeJoint:wieldingJoint];
        [wielding removeFromParent];
    }
}

@end
