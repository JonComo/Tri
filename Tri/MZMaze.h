//
//  MZMaze.h
//  Maze
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZRoom.h"

@interface MZMaze : NSObject

@property (nonatomic, strong) NSMutableArray *maze;
@property CGPoint currentRoom;
@property CGSize size;

-(id)initWithSize:(CGSize)mazeSize;
-(void)iterateRooms:(void(^)(MZRoom *room, int x, int y))block;
-(MZRoom *)roomAtX:(int)xPos y:(int)yPos checkFound:(BOOL)check;
-(UIImage *)render;

@end