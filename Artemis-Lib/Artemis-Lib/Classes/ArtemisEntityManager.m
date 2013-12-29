#import "ArtemisEntityManager.h"

@interface ArtemisIdentifierPool : NSObject
@property(nonatomic,retain) ArtemisBag* ids;
@property(nonatomic) NSUInteger nextAvailableId;

@end

@implementation ArtemisIdentifierPool

- (id)init
{
    self = [super init];
    if (self) {
        self.ids = [ArtemisBag bag];
    }
    return self;
}

-(EntityID) checkOut
{
	if( self.ids.size > 0 )
	{
		return [(NSNumber*)[self.ids removeLast] unsignedIntegerValue];
	}
	else
	{
		return self.nextAvailableId++;
	}
}

-(void) checkIn:(EntityID) newId
{
	[self.ids add:@(newId)];
}

@end


@interface ArtemisEntityManager()
@property(nonatomic,retain) ArtemisBag* entities;
@property(nonatomic,retain) ArtemisBitSet* disabled;

@property(nonatomic,readwrite) int activeEntityCount;
@property(nonatomic,readwrite) uint64_t totalCreated, totalAdded, totalDeleted;

@property(nonatomic,retain) ArtemisIdentifierPool* identifierPool;
@end

@implementation ArtemisEntityManager

+(ArtemisEntityManager *)entityManager
{
	ArtemisEntityManager* newValue = [[ArtemisEntityManager new] autorelease];
	
	return newValue;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.entities = [ArtemisBag bag];
		self.disabled = [[ArtemisBitSet new] autorelease];
		self.identifierPool = [[ArtemisIdentifierPool new] autorelease];
    }
    return self;
}

-(ArtemisEntity*) createEntityInstance
{
	ArtemisEntity* e = [ArtemisEntity entityInWorld:self.world withId:[self.identifierPool checkOut]];
	self.totalCreated++;
	return e;
}

-(void)added:(ArtemisEntity *)entity
{
	self.activeEntityCount++;
	self.totalAdded++;
	[self.entities setItem:entity atIndex:entity.Id];
}

-(void)enabled:(ArtemisEntity *)entity
{
	[self.disabled clear:(NSInteger)entity.Id];
}

-(void)disabled:(ArtemisEntity *)entity
{
	[self.disabled set:(NSInteger)entity.Id];
}

-(void)deleted:(ArtemisEntity *)entity
{
	[self.entities setItem:[NSNull null] atIndex:entity.Id];
	
	[self.disabled clear:(NSInteger)entity.Id];
	
	[self.identifierPool checkIn:entity.Id];
	
	self.activeEntityCount--;
	self.totalDeleted++;
}

-(BOOL) isActive:(EntityID) entityID
{
	return [self.entities get:entityID] != [NSNull null];
}

-(BOOL) isEnabled:(EntityID) entityID
{
	return ! [self.disabled get:(NSInteger)entityID];
}

-(ArtemisEntity*) getEntity:(EntityID) entityId
{
	return (ArtemisEntity*) [self.entities get:entityId];
}

@end
