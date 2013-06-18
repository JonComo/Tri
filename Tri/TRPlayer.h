//
//  TRPlayer.h
//  Tri
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "TRObject.h"

@interface TRPlayer : TRObject

-(id)initWithPosition:(CGPoint)position;

-(void)runInDirection:(float)direction intensity:(float)intensity;
-(void)strike;

@end
