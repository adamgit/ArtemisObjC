#import "ArtemisEntitySystem.h"

#import "ArtemisWorld.h"

@interface ArtemisSystemIndexManager : NSObject
+(int) getIndexFor:(Class) esClass;
@end

@implementation ArtemisSystemIndexManager

static int INDEX;
static NSMutableDictionary* indices;

+(int) getIndexFor:(Class) esClass
{
	if( indices == nil )
	{
		INDEX = 0;
		indices = [[NSMutableDictionary dictionary] retain];
	}
	
	id indexObject = [indices objectForKey:esClass];
	int index;
	if( indexObject == nil || indexObject == [NSNull null])
	{
		index = INDEX++;
		[indices setObject:@(index) forKey:(id<NSCopying>)esClass]; // looks wrong but Apple approves officially
	}
	else
		index = [indexObject intValue];
	
	return index;
}

@end

@interface ArtemisEntitySystem ()
@property(nonatomic) int systemIndex;
@property(nonatomic,retain) ArtemisAspect* aspect;
@property(nonatomic,retain) ArtemisBitSet* allSet, * exclusionSet, * oneSet;
@end

@implementation ArtemisEntitySystem

+(ArtemisEntitySystem *)entitySystemWithAspect:(ArtemisAspect *)aspect
{
	ArtemisEntitySystem* newValue = [[ArtemisEntitySystem new] autorelease];
	
	newValue.aspect = aspect;
	newValue.allSet = aspect.allSet;
	newValue.exclusionSet = aspect.exclusionSet;
	newValue.oneSet = aspect.oneSet;
	newValue.systemIndex = [ArtemisSystemIndexManager getIndexFor:[self class]];
	newValue.isDummy = newValue.allSet.isEmpty && newValue.oneSet.isEmpty;
	
	return newValue;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.actives = [ArtemisBag bag];		
    }
    return self;
}

-(void)process
{
	if( [self checkProcessing] )
	{
		[self begin];
		[self processEntities: self.actives];
		[self end];
	}
}

-(void)begin { }
-(void)end { }
-(BOOL)checkProcessing { return FALSE; }
-(void)processEntities:(NSObject<ArtemisImmutableBag> *)entities { }

-(void) initialize { }
-(void) inserted:(ArtemisEntity*) entity { }
-(void) removed:(ArtemisEntity*) entity { }

-(void) check:(ArtemisEntity*) entity
{
	if( self.isDummy )
		return;
	
	BOOL contains = [entity.systemBits get:self.systemIndex];
	BOOL interested = TRUE;
	
	ArtemisBitSet* componentBits = entity.componentBits;
	
	if( ! self.allSet.isEmpty )
	{
		for( long i = [self.allSet nextSetBit:0]; i >= 0; i = [self.allSet nextSetBit:i+1] )
		{
			if( ! [componentBits get:i] )
			{
				interested = FALSE;
				break;
			}
		}
	}
	
	if( ! self.exclusionSet.isEmpty )
	{
		interested = ! [self.exclusionSet intersects: componentBits];
	}
	
	if( ! self.oneSet.isEmpty )
	{
		interested = [self.oneSet intersects: componentBits];
	}
	
	if( interested && !(contains) )
	{
		[self insertToSystem:entity];
	}
	else
	{
		[self removeFromSystem:entity];
	}
}

-(void) removeFromSystem:(ArtemisEntity*) entity
{
	[self.actives removeFirst:entity];
	[entity.systemBits clear:self.systemIndex];
	[self removed:entity];
}

-(void) insertToSystem:(ArtemisEntity*) entity
{
	[self.actives add:entity];
	[entity.systemBits set:self.systemIndex];
	[self inserted:entity];
}

-(void) added:(ArtemisEntity*) entity
{
	[self check:entity];
}
-(void) changed:(ArtemisEntity*) entity
{
	[self check:entity];
}

-(void) deleted:(ArtemisEntity*) entity
{
	if( [entity.systemBits get:self.systemIndex])
		[self removeFromSystem:entity];
}

-(void) disabled:(ArtemisEntity*) entity
{
	if( [entity.systemBits get:self.systemIndex])
		[self removeFromSystem:entity];
}
-(void) enabled:(ArtemisEntity*) entity
{
	[self check:entity];
}


@end