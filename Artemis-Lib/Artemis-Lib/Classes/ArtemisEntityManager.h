/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/EntityManager.java
 */
#import <Foundation/Foundation.h>

#import "ArtemisBag.h"
#import "ArtemisManager.h"
#import "ArtemisEntity.h"

@interface ArtemisEntityManager : ArtemisManager

/** ObjC: safer to add + methods for constrcutors */
+(ArtemisEntityManager*) entityManager;

-(ArtemisEntity*) createEntityInstance;

-(BOOL) isActive:(EntityID) entityID;
-(BOOL) isEnabled:(EntityID) entityID;

-(ArtemisEntity*) getEntity:(EntityID) entityId;

@property(nonatomic,readonly) int activeEntityCount;

@property(nonatomic,readonly) uint64_t totalCreated, totalAdded, totalDeleted;

@end
