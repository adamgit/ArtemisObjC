#import "ArtemisComponentMapper.h"

#import "ArtemisBag.h"
#import "ArtemisComponentType.h"
#import "ArtemisWorld.h"

@interface ArtemisComponentMapper()
@property(nonatomic,retain) ArtemisComponentType* type;
@property(nonatomic,retain) Class classType;
@property(nonatomic,retain) ArtemisBag* components;

@end
@implementation ArtemisComponentMapper


+(ArtemisComponentMapper*) componentMapperForType:(Class) componentClass inWorld:(ArtemisWorld*) world
{
	ArtemisComponentMapper* cm = [[ArtemisComponentMapper new] autorelease];
	
	cm.type = [ArtemisComponentType getTypeFor:componentClass];
	cm.components = [world.componentManager getComponentsByType:cm.type];
	cm.classType = componentClass;
	
	return cm;
}

-(NSObject*) get:(ArtemisEntity*) entity
{
	return [self.components get: entity.Id];
}

-(NSObject*) getSafe:(ArtemisEntity*) entity
{
	if( [self.components isIndexWithinBounds: entity.Id] )
	{
		return [self.components get:entity.Id];
	}
	
	return nil;
}

-(BOOL) has:(ArtemisEntity*) entity
{
	return [self getSafe:entity] != nil;
}

@end
