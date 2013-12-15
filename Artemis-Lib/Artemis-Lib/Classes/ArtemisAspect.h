/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/Aspect.java
 
 BUG IN Artemis main: it names the parameters "types" when they are NOT types, but "component class-objects"
 */
#import <Foundation/Foundation.h>

#import "ArtemisBitSet.h"

@interface ArtemisAspect : NSObject

@property(nonatomic,retain) ArtemisBitSet* allSet, * exclusionSet, * oneSet;

+(ArtemisAspect*) aspectEmpty;

-(ArtemisAspect*) all:(NSArray*) componentClasses;
-(ArtemisAspect*) exclude:(NSArray*) componentClasses;
-(ArtemisAspect*) one:(NSArray*) componentClasses;

+(ArtemisAspect*) aspectFor:(NSArray*) componentClasses;
+(ArtemisAspect*) aspectForAll:(NSArray*) componentClasses;

+(ArtemisAspect*) aspectForOne:(NSArray*) componentClasses;

@end
