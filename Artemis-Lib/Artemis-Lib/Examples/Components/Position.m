#import "Position.h"

@implementation Position

+(Position *)positionWithX:(float)x y:(float)y
{
	Position* p = [[Position new] autorelease];
	
	p.x = x;
	p.y = y;
	
	return p;
}

@end
