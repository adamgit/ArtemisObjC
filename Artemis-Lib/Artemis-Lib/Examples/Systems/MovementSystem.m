#import "MovementSystem.h"

#import "ArtemisComponentMapper.h"

@interface MovementSystem()
@property(nonatomic,retain) ArtemisComponentMapper* positionMapper, * velocityMapper;
@end

@implementation MovementSystem

+(MovementSystem *)movementSystem
{
	MovementSystem* m = [[MovementSystem new] autorelease];
	
	return m;
}

-(void)initialize
{
	self.positionMapper = [ArtemisComponentMapper componentMapperForType:[Position class] inWorld:self.world];
	self.velocityMapper = [ArtemisComponentMapper componentMapperForType:[Velocity class] inWorld:self.world];
}

-(void)process:(ArtemisEntity *)entity
{
	Position* pos = (Position*) [self.positionMapper get:entity];
	Velocity* vel = (Velocity*) [self.velocityMapper get:entity];
	
	pos.x += vel.dx;
	pos.y += vel.dy;
}

@end
