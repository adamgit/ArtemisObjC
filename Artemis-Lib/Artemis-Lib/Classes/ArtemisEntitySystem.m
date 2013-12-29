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

- (id)init
{
    self = [super init];
    if (self) {
        self.actives = [ArtemisBag bag];		
    }
    return self;
}

- (id)initWithAspect:(ArtemisAspect*) aspect
{
    self = [self init];
    if (self) {
        self.aspect = aspect;
		self.allSet = aspect.allSet;
		self.exclusionSet = aspect.exclusionSet;
		self.oneSet = aspect.oneSet;
		self.systemIndex = [ArtemisSystemIndexManager getIndexFor:[self class]];
		self.isDummy = self.allSet.isEmpty && self.oneSet.isEmpty;
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
	
	if( /** ObjC: nil will break Artemis main here */ self.allSet != nil && ! self.allSet.isEmpty )
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
	
	if( /** ObjC: nil will break Artemis main here */ self.exclusionSet != nil && ! self.exclusionSet.isEmpty )
	{
		interested = ! [self.exclusionSet intersects: componentBits];
	}
	
	if( /** ObjC: nil will break Artemis main here */ self.oneSet != nil && ! self.oneSet.isEmpty )
	{
		interested = [self.oneSet intersects: componentBits];
	}
	
	if( interested && !(contains) )
	{
		[self insertToSystem:entity];
	}
	else if( !(interested) && contains)
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