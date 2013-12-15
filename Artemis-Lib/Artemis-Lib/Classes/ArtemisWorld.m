#import "ArtemisWorld.h"

#import "ArtemisBag.h"
#import "ArtemisImmutableBag.h"
#import "ArtemisEntitySystem.h"
#import "ArtemisEntityObserver.h"

#import "ArtemisWorld_Debug.h"

typedef void (^Performer)(NSObject<ArtemisEntityObserver>* observer, ArtemisEntity* entity);

@interface ArtemisComponentMapperInitHelper : NSObject
+(void) configTarget:(NSObject*) target inWorld:(ArtemisWorld*) world;
@end
@implementation ArtemisComponentMapperInitHelper
+(void)configTarget:(NSObject *)target inWorld:(ArtemisWorld *)world
{
	NSLog(@"IMPOSSIBLE IN OBJECTIVE C: Annotations are a Java-language exclusive feature");
}
@end

@interface ArtemisWorld()
@property(nonatomic,retain) ArtemisBag* added, * changed, * deleted, * enable, * disable;

@property(nonatomic,retain) NSMutableDictionary* managers;
@property(nonatomic,retain) ArtemisBag* managersBag;

@property(nonatomic,retain) NSMutableDictionary* systems;
@property(nonatomic,retain) ArtemisBag* systemsBag;

#pragma mark - ObjectiveC customizations


@end

@implementation ArtemisWorld

-(id) init
{
    if (self = [super init])
    {
		self.managers = [NSMutableDictionary dictionary];
		self.managersBag = [ArtemisBag bag];
		
		self.systems = [NSMutableDictionary dictionary];
		self.systemsBag = [ArtemisBag bag];
		
		self.added = [ArtemisBag bag];
		self.changed = [ArtemisBag bag];
		self.deleted = [ArtemisBag bag];
		self.enable = [ArtemisBag bag];
		self.disable = [ArtemisBag bag];
		
		self.componentManager = [ArtemisComponentManager componentManager];
		[self setManager:self.componentManager];
		
		self.entityManager = [ArtemisEntityManager entityManager];
		[self setManager:self.entityManager];
    }
    return self;
}

-(void) initialize
{
	for( int i=0; i < self.managersBag.size; i++ )
	{
		[(ArtemisManager*)[self.managersBag get:i] initialize];
	}
	
	for( int i=0; i < self.systemsBag.size; i++ )
	{
		[ArtemisComponentMapperInitHelper configTarget:[self.systemsBag get:i] inWorld:self];
		[(ArtemisEntitySystem*)[self.systemsBag get:i] initialize];
	}
}

-(ArtemisManager*) setManager:(ArtemisManager*) manager
{
	[self.managers setObject:manager forKey:(id)[manager class]];
	[self.managersBag add:manager];
	manager.world = self;
	return manager;
}

-(ArtemisManager *) getManager:(Class)managerClass
{
	return [self.managers objectForKey:managerClass];
}

-(void) deleteManager:(ArtemisEntityManager*) manager
{
	[self.managers removeObjectForKey:[manager class]];
	[self.managersBag removeFirst:manager];
}

-(void) addEntity:(ArtemisEntity*) entity
{
	[self.added add:entity];
}

-(void) changedEntity:(ArtemisEntity*) entity
{
	[self.changed add:entity];
}

-(void) deleteEntity:(ArtemisEntity*) entity
{
	if( ! [self.deleted contains:entity])
		[self.deleted add:entity];
}

-(void) enable:(ArtemisEntity*) entity
{
	[self.enable add:entity];
}

-(void) disable:(ArtemisEntity*) entity
{
	[self.disable add:entity];
}

-(ArtemisEntity*) createEntity
{
	return [self.entityManager createEntityInstance];
}

-(ArtemisEntity*) getEntity:(int) entityId
{
	return [self.entityManager getEntity:entityId];
}

-(NSObject<ArtemisImmutableBag>*) getSystems
{
	return self.systemsBag;
}

-(ArtemisEntitySystem*) setSystem:(ArtemisEntitySystem*) system
{
	return [self setSystem:system passive:FALSE];
}

-(ArtemisEntitySystem*) setSystem:(ArtemisEntitySystem*) system passive:(BOOL) passive
{
	system.world = self;
	system.isPassive = passive;
	
	[self.systems setObject:system forKey:(id<NSCopying>)[system class]]; // Looks wrong, but Apple OFFICIALLY approves
	[self.systemsBag add:system];
	
	return system;
}

-(void) deleteSystem:(ArtemisEntitySystem*) system
{
	[self.systems removeObjectForKey:[system class]];
	[self.systemsBag removeFirst:system];
}

-(void) notifySystems:(ArtemisEntity*) entity withBlock:(Performer) performer
{
	for( NSInteger i=0, s = self.systemsBag.size; s > i; i++ )
	{
		performer( (NSObject<ArtemisEntityObserver>*)[self.systemsBag get:i], entity );
	}
}

-(void) notifyManagers:(ArtemisEntity*) entity withBlock:(Performer) performer
{
	for( NSInteger i=0, s = self.managersBag.size; s > i; i++ )
	{
		performer( (NSObject<ArtemisEntityObserver>*)[self.systemsBag get:i], entity );
	}
}

-(ArtemisEntitySystem*) getSystem:(Class) c
{
	return [self.systems objectForKey:c];
}

-(void) check:(ArtemisBag*) entities withBlock:(Performer) performer
{
	if( ! entities.isEmpty )
	{
		for( int i = 0; entities.size > i; i++ )
		{
			ArtemisEntity* entity = (ArtemisEntity*)[entities get:i];
			[self notifyManagers:entity withBlock:performer];
			[self notifySystems:entity withBlock:performer];
		}
		[entities clear];
	}
}

-(void) process
{
	if( self.objcDebugEachTick )
		NSLog(@"Ticking World...");
	self.objDebugNumTicksSinceStarted++;
	
	[self check:self.added withBlock:^(NSObject<ArtemisEntityObserver> *observer, ArtemisEntity *entity) {
		[observer added:entity];
	}];
	
	[self check:self.changed withBlock:^(NSObject<ArtemisEntityObserver> *observer, ArtemisEntity *entity) {
		[observer changed:entity];
	}];
	
	[self check:self.disable withBlock:^(NSObject<ArtemisEntityObserver> *observer, ArtemisEntity *entity) {
		[observer disabled:entity];
	}];
	
	[self check:self.enable withBlock:^(NSObject<ArtemisEntityObserver> *observer, ArtemisEntity *entity) {
		[observer enabled:entity];
	}];
	
	[self check:self.deleted withBlock:^(NSObject<ArtemisEntityObserver> *observer, ArtemisEntity *entity) {
		[observer deleted:entity];
	}];
	
	[self.componentManager clean];
	
	for( int i = 0; self.systemsBag.size > i; i++ )
	{
		ArtemisEntitySystem* system = (ArtemisEntitySystem*) [self.systemsBag get:i];
		if( ! system.isPassive )
		{
			[system process];
		}
	}
}

#pragma mark - ObjectiveC customizations

@end
