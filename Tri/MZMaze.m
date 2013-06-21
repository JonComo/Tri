//
//  MZMaze.m
//  Maze
//
//  Created by Jon Como on 6/14/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "MZMaze.h"

@implementation MZMaze

-(id)initWithSize:(CGSize)mazeSize
{
    if (self = [super init]) {
        //init
        [self generateMazeOfSize:mazeSize];
    }
    
    return self;
}

-(void)generateMazeOfSize:(CGSize)mazeSize
{
    int x;
    int y;
    
    NSMutableArray *stack;
    
    MZRoom *room;
    
    self.size = mazeSize;
    
    self.maze = [NSMutableArray array];
    
    int width = self.size.width;
    int height = self.size.height;
    
    for (int i = 0; i<width; i++) {
        
        self.maze[i] = [NSMutableArray array];
        
        for (int j = 0; j<height; j++) {
            
            MZRoom *newRoom = [MZRoom new];
            
            newRoom.x = i;
            newRoom.y = j;
            
            self.maze[i][j] = newRoom;
        }
    }
    
    x = 1;
    y = 1;
    
    stack = [NSMutableArray array];
    
    room = self.maze[x][y];
    
    BOOL iterate = YES;
    
    while (iterate) {
        [stack addObject:room];
        room.hasBeenVisited = YES;
        
        x = room.x;
        y = room.y;
        
        NSMutableArray *openRooms = [NSMutableArray array];
        
        MZRoom *n = [self roomAtX:x y:y+1 checkFound:YES];
        if (n) [openRooms addObject:n];
        
        MZRoom *s = [self roomAtX:x y:y-1 checkFound:YES];
        if (s) [openRooms addObject:s];
        
        MZRoom *e = [self roomAtX:x+1 y:y checkFound:YES];
        if (e) [openRooms addObject:e];
        
        MZRoom *w = [self roomAtX:x-1 y:y checkFound:YES];
        if (w) [openRooms addObject:w];
        
        if (openRooms.count > 0)
        {
            MZRoom *randomRoom = [openRooms objectAtIndex:arc4random()%openRooms.count];
            
            if (randomRoom == n){
                n.S = YES;
                room.N = YES;
            }
            
            if (randomRoom == s){
                s.N = YES;
                room.S = YES;
            }
            
            if (randomRoom == e){
                e.W = YES;
                room.E = YES;
            }
            
            if (randomRoom == w){
                w.E = YES;
                room.W = YES;
            }
            
            room = randomRoom;
        }else{
            [stack removeObject:room];
            
            if (stack.count > 0)
            {
                room = [stack lastObject];
            }else{
                iterate = NO;
            }
        }
    }
    
    self.currentRoom = CGPointMake(1, 1);
}

-(void)iterateRooms:(void(^)(MZRoom *room, int x, int y))block
{
    for (int i = 0; i<self.size.width; i++) {
        
        for (int j = 0; j<self.size.height; j++) {
            
            MZRoom *foundRoom = self.maze[i][j];
            
            if (block) block(foundRoom, i , j);
            
        }
    }
}

-(MZRoom *)roomAtX:(int)xPos y:(int)yPos checkFound:(BOOL)check
{
    if (xPos < 1)
        return nil;
    if (xPos > self.size.width - 2)
        return nil;
    
    if (yPos < 1)
        return nil;
    if (yPos > self.size.height - 2)
        return nil;
    
    MZRoom *foundRoom = self.maze[xPos][yPos];
    
    if (check && foundRoom.hasBeenVisited)
        return nil;
    
    if (foundRoom)
        self.currentRoom = CGPointMake(xPos, yPos);
    
    return foundRoom;
}

-(UIImage *)render
{
    CGSize mazeSize = self.size;
    
    CGSize cellSize = CGSizeMake(10, 10);
    
    UIGraphicsBeginImageContext(CGSizeMake(mazeSize.width * cellSize.width, mazeSize.height * cellSize.height));
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    NSArray *wideArray = self.maze;
    NSArray *heightArray = self.maze[0];
    
    for (int i = 0; i<wideArray.count; i++) {
        for (int j = 0; j<heightArray.count; j++) {
            
            MZRoom *room = self.maze[i][j];
            
            if (!room.hasBeenVisited)
                continue;
            
            [[UIColor orangeColor] setFill];
            
            CGPoint c = CGPointMake(i * cellSize.width, j * cellSize.height);
            
            if (self.currentRoom.x == i && self.currentRoom.y == j)
            {
                CGContextFillRect(ref, CGRectMake(c.x + cellSize.width/2 - 2, c.y + cellSize.height/2 - 2, 4, 4));
            }
            
            //outside walls
            
            if (!room.N){
                CGContextDrawImage(ref, CGRectMake(c.x, c.y, cellSize.width, cellSize.height), [UIImage imageNamed:@"nc"].CGImage);
            }
            
            if (!room.S){
                CGContextDrawImage(ref, CGRectMake(c.x, c.y, cellSize.width, cellSize.height), [UIImage imageNamed:@"sc"].CGImage);
            }
            
            if (!room.E){
                CGContextDrawImage(ref, CGRectMake(c.x, c.y, cellSize.width, cellSize.height), [UIImage imageNamed:@"ec"].CGImage);
            }
            
            if (!room.W){
                CGContextDrawImage(ref, CGRectMake(c.x, c.y, cellSize.width, cellSize.height), [UIImage imageNamed:@"wc"].CGImage);
            }
            
        }
    }
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

@end
