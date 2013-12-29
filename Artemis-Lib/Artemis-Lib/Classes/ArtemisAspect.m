#import "ArtemisAspect.h"

#import "ArtemisComponentType.h"

@interface ArtemisAspect()
@end

@implementation ArtemisAspect

- (id)init
{
    self = [super init];
    if (self) {
        self.allSet = [ArtemisBitSet bitSet];
		self.exclusionSet = [ArtemisBitSet bitSet];
		self.oneSet = [ArtemisBitSet bitSet];
    }
    return self;
}

+(ArtemisAspect*) aspectEmpty
{
	ArtemisAspect* newValue = [[ArtemisAspect new] autorelease];
	
	return newValue;
}

-(ArtemisAspect*) all:(NSArray*) componentClasses
{
	for( Class cClass in componentClasses )
	{
		[self.allSet set: (NSInteger)[ArtemisComponentType getIndexFor:cClass]];
	}
	
	return self;
}

-(ArtemisAspect*) exclude:(NSArray*) componentClasses
{
	for( Class cClass in componentClasses )
	{
		[self.exclusionSet set: (NSInteger)[ArtemisComponentType getIndexFor:cClass]];
	}
	
	return self;
}

-(ArtemisAspect*) one:(NSArray*) componentClasses
{
	for( Class cClass in componentClasses )
	{
		[self.oneSet set: (NSInteger)[ArtemisComponentType getIndexFor:cClass]];
	}
	
	return self;
}

+(ArtemisAspect*) aspectFor:(NSArray*) componentClasses
{
	return [self aspectForAll:componentClasses];
}

+(ArtemisAspect*) aspectForAll:(NSArray*) componentClasses
{
	ArtemisAspect* aspect = [ArtemisAspect aspectEmpty];
	
	[aspect all:componentClasses];
	
	return aspect;
}

+(ArtemisAspect*) aspectForOne:(NSArray*) componentClasses
{
	ArtemisAspect* aspect = [ArtemisAspect aspectEmpty];
	
	[aspect one:componentClasses];
	
	return aspect;
}

@end
