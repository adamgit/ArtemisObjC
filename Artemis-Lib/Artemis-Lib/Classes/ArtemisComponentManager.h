/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/ComponentManager.java
 */
#import <Foundation/Foundation.h>

#import "ArtemisBag.h"
#import "ArtemisBitSet.h"
#import "ArtemisEntity.h"
#import "ArtemisManager.h"

@interface ArtemisComponentManager : ArtemisManager

/** ObjC: for safety, use this instead of relying on default undefined constrcutors */
+(ArtemisComponentManager*) componentManager;

-(void) addComponent:(ArtemisComponent*) component ofType:(ArtemisComponentType*) componentType toEntity:(ArtemisEntity*) entity;
-(void) removeComponent:(ArtemisComponentType*) componentType fromEntity:(ArtemisEntity*) entity;

-(ArtemisBag*) getComponentsByType:(ArtemisComponentType*) componentType;
-(ArtemisComponent*) getComponentOfType:(ArtemisComponentType*) componentType fromEntity:(ArtemisEntity*) entity;
-(ArtemisBag*) getComponentsFor:(ArtemisEntity*) entity intoBag:(ArtemisBag*) fillBag;

-(void) clean;

@end
