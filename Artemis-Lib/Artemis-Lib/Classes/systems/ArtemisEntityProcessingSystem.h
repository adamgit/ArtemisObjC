/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/systems/EntityProcessingSystem.java
 */
#import <Foundation/Foundation.h>

#import "ArtemisAspect.h"
#import "ArtemisEntitySystem.h"

@interface ArtemisEntityProcessingSystem : ArtemisEntitySystem

+(ArtemisEntityProcessingSystem*) entityProcessingSystemWithAspect:(ArtemisAspect*) aspect;

-(void) process:(ArtemisEntity*) entity;

@end
