//
//  JCControlPad.h
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class JCControlPad;

@protocol JCControlPadDelegate <NSObject>

@optional
-(void)controlPad:(JCControlPad *)pad changedInputWithDirection:(float)direction intensity:(float)intensity;
-(void)controlPad:(JCControlPad *)pad beganTouch:(UITouch *)touch;
-(void)controlPad:(JCControlPad *)pad endedTouch:(UITouch *)touch;

@end

@interface JCControlPad : SKSpriteNode

@property (nonatomic, weak) id <JCControlPadDelegate> delegate;

@property float angle;
@property float intensity;

-(id)initWithTouchRegion:(CGRect)frame delegate:(id <JCControlPadDelegate>)controlDelegate;
-(void)update:(CFTimeInterval)currentTime;

@end