/**
* c.f. http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/World.java
*/

#import "ArtemisEntityManager.h"
#import "ArtemisComponentManager.h"

@class ArtemisEntitySystem;

@interface ArtemisWorld : NSObject

@property (nonatomic) float delta;

@property(nonatomic,retain) ArtemisEntityManager* entityManager;
@property(nonatomic,retain) ArtemisComponentManager* componentManager;

-(void) initialize;

-(ArtemisEntity*) createEntity;
-(ArtemisEntity*) getEntity:(EntityID) entityId;

-(void) addEntity:(ArtemisEntity*) entity;
/**
 * Ensure all systems are notified of changes to this entity.
 * If you're adding a component to an entity after it's been
 * added to the world, then you need to invoke this method.
 *
 * @param e entity
 */
-(void) changedEntity:(ArtemisEntity*) entity;
-(void) deleteEntity:(ArtemisEntity*) entity;
-(void) enable:(ArtemisEntity*) entity;
-(void) disable:(ArtemisEntity*) entity;

-(ArtemisEntitySystem*) setSystem:(ArtemisEntitySystem*) system;
-(void) deleteSystem:(ArtemisEntitySystem*) system;
-(ArtemisEntitySystem*) getSystem:(Class) c;

/**
 * Process all non-passive systems.
 */
-(void) process;

@end
