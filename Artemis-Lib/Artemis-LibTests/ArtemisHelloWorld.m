//
//  ArtemisHelloWorld.m
//  Artemis-Lib
//
//  Created by adam on 15/12/2013.
//  Copyright (c) 2013 n/a. All rights reserved.
//

#import "ArtemisHelloWorld.h"

#import "ArtemisWorld.h"
#import "ArtemisWorld_Debug.h"

#import "MovementSystem.h"

@implementation ArtemisHelloWorld

-(void) testCreateEmptyWorld
{
	ArtemisWorld* world = [[[ArtemisWorld alloc] init] autorelease];
	
	XCTAssertNotNil( world, @"Creating world");
}

/**
 public class MyGame {
 
 public void MyGame() {
 world = new World();
 
 world.setSystem(new MovementSystem());
 world.setSystem(new RotationSystem());
 world.setSystem(new RenderingSystem());
 
 world.initialize();
 
 while(true) {
 world.setDelta(MyGameTimer.getDelta());
 world.process();
 }
 }
 }
 */
-(void) testWorldCanTick
{
	ArtemisWorld* world = [[[ArtemisWorld alloc] init] autorelease];
	world.objcDebugEachTick = TRUE;
	
	[world setSystem:[MovementSystem movementSystem]];
	
	[world initialize];
	
	NSTimeInterval tickRate = 0.1;
	[NSTimer scheduledTimerWithTimeInterval:tickRate target:world selector:@selector(process) userInfo:nil repeats:TRUE];
	
	[self prepare];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		int desiredTicks = 10;
		sleep( desiredTicks * tickRate );
		
		if( world.objDebugNumTicksSinceStarted > (desiredTicks-2 /** some leeway for asynch slowness */))
			[self notify:kXCTUnitWaitStatusSuccess];
		else
			[self notify:kXCTUnitWaitStatusFailure];
	});
	
	[self waitForStatus:kXCTUnitWaitStatusSuccess timeout:4.0];
}

/**
 Try a simple Movement System
 */
-(void) testSimpleMovementSystem
{
	ArtemisWorld* world = [[[ArtemisWorld alloc] init] autorelease];
	world.objcDebugEachTick = TRUE;
	
	[world setSystem:[MovementSystem movementSystem]];
	
	[world initialize];
	
	ArtemisEntity* e1 = [world createEntity];
	[e1 addComponent:[Position positionWithX:0 y:0]];
	[e1 addComponent:[Velocity velocityWithDeltaX:1 deltaY:0]];
	[world addEntity:e1];
	
	NSTimeInterval tickRate = 1.0;
	[NSTimer scheduledTimerWithTimeInterval:tickRate target:world selector:@selector(process) userInfo:nil repeats:TRUE];
	
	[self prepare];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		int desiredTicks = 10;
		sleep( desiredTicks * tickRate );
		
		Position* finalPosition = (Position*) [e1 componentOfType:[ArtemisComponentType getTypeFor:[Position class]]];
		
		XCTAssertTrue( finalPosition.y == 0, @"y shouldnt move");
		XCTAssertTrue( finalPosition.x > 0, @"x should move");
		
		[self notify:kXCTUnitWaitStatusSuccess];
	});
	
	[self waitForStatus:kXCTUnitWaitStatusSuccess timeout:600.0];
}
@end
