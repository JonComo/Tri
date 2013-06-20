//
//  JCControlPad.m
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "JCControlPad.h"
#import "JCMath.h"

@implementation JCControlPad
{
    CGPoint initialTouchPosition;
    SKSpriteNode *touchVisual;
    
    BOOL isReceivingTouch;
    
    float intensityMax;
}

-(id)initWithTouchRegion:(CGRect)frame delegate:(id<JCControlPadDelegate>)controlDelegate
{
    if (self = [super init]) {
        //init
        _delegate = controlDelegate;
        
        self.color = [UIColor redColor];
        self.alpha = 0.4;
        
        self.size = frame.size;
        self.position = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y - frame.size.height/2);
        
        touchVisual = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:CGSizeMake(20, 20)];
        
        intensityMax = (self.size.width + self.size.height) / 4;
        
        [self setUserInteractionEnabled:YES];
    }
    
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    if (isReceivingTouch && self.intensity > 5 && [self.delegate respondsToSelector:@selector(controlPad:changedInputWithDirection:intensity:)])
        [self.delegate controlPad:self changedInputWithDirection:self.angle intensity:self.intensity];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isReceivingTouch = YES;
    
    self.intensity = 0;
    self.angle = 0;
    
    if (!touchVisual.parent)
        [self addChild:touchVisual];
    
    UITouch *touch = [self closestTouchFromTouches:touches];
    
    initialTouchPosition = [touch locationInNode:self];
    touchVisual.position = initialTouchPosition;
    
    if ([self.delegate respondsToSelector:@selector(controlPad:beganTouch:)])
        [self.delegate controlPad:self beganTouch:touch];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [self closestTouchFromTouches:touches];
    
    CGPoint touchMovedPosition = [touch locationInNode:self];
        
    self.angle = [JCMath angleFromPoint:initialTouchPosition toPoint:touchMovedPosition];
    self.intensity = [JCMath distanceBetweenPoint:initialTouchPosition andPoint:touchMovedPosition sorting:NO];
    
    if (self.intensity > intensityMax)
        self.intensity = intensityMax;
    
    touchVisual.position = [JCMath pointFromPoint:initialTouchPosition pushedBy:self.intensity inDirection:self.angle];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isReceivingTouch = NO;
    
    UITouch *touch = [self closestTouchFromTouches:touches];
    
    if (touchVisual.parent)
        [touchVisual removeFromParent];
    
    if ([self.delegate respondsToSelector:@selector(controlPad:endedTouch:)])
        [self.delegate controlPad:self endedTouch:touch];
}

-(UITouch *)closestTouchFromTouches:(NSSet *)touches
{
    UITouch *closest;
    float dist = FLT_MAX;
    
    for (UITouch *touch in touches)
    {
        float testDistance = [JCMath distanceBetweenPoint:self.position andPoint:[touch locationInNode:self.parent] sorting:NO];
        
        if (testDistance < dist)
        {
            closest = touch;
            dist = testDistance;
        }
    }
    
    return closest;
}

@end
