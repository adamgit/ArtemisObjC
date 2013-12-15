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

-(BOOL) isActive:(int) entityID;
-(BOOL) isEnabled:(int) entityID;

-(ArtemisEntity*) getEntity:(int) entityId;

@property(nonatomic,readonly) int activeEntityCount;

@property(nonatomic,readonly) uint64_t totalCreated, totalAdded, totalDeleted;

@end
