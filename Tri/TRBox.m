//
//  TRBox.m
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "TRBox.h"

@implementation TRBox

-(id)initWithRect:(CGRect)frame texture:(SKTexture *)texture color:(UIColor *)color
{
    if (self = [super init]) {
        //init
        
        self.texture = texture;
        self.color = color;
        
        self.position = frame.origin;
        self.size = frame.size;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        [self.physicsBody setDynamic:NO];
    }
    
    return self;
}

@end
