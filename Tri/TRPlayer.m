//
//  TRPlayer.m
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "TRPlayer.h"

@implementation TRPlayer
{
    SKAction *actionRun;
    SKAction *actionStanding;
    BOOL isRunning;
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
    intensity *= 100;
    
    CGPoint force = CGPointMake(cosf(direction) * intensity, sinf(direction) * intensity);
    
    [self.physicsBody applyForce:force];
    
    self.xScale = force.x > 0 ? 1 : -1;
}

-(void)update:(CFTimeInterval)currentTime
{
    self.physicsBody.velocity = CGPointMake(self.physicsBody.velocity.x * 0.8, self.physicsBody.velocity.y * 0.8);
}

-(void)strike
{
    [self runAction:actionRun];
}

@end
