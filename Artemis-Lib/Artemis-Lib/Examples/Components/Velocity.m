#import "Velocity.h"

@implementation Velocity

+(Velocity *)velocityWithDeltaX:(float)x deltaY:(float)y
{
	Velocity* v = [[Velocity new] autorelease];
	
	v.dx = x;
	v.dy = y;
	
	return v;
}

@end
