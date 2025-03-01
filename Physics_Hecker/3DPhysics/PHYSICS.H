/*----------------------------------------------------------------------------

3D Physics Test Program - a cheesy test harness for 3D physics

by Chris Hecker for my Game Developer Magazine articles.  See my homepage
for more information.

NOTE: This is a hacked test program, not a nice example of Windows programming.
physics.cpp the only part of this you should look at!!!

This material is Copyright 1997 Chris Hecker, All Rights Reserved.
It's for you to read and learn from, not to put in your own articles
or books or on your website, etc.  Thank you.

Chris Hecker
checker@d6.com
http://www.d6.com/users/checker

*/

/*----------------------------------------------------------------------------

physics.h - The header for the physics demo.

5/24/96 - checker

*/

#if !defined(PHYSICS_H)
#define PHYSICS_H

// explicit dependencies
#include "math3d.h"



/*----------------------------------------------------------------------------

Declarations for physics code.

*/

struct rigid_body
{
    real OneOverMass;
    matrix_3x3 InverseBodyInertiaTensor;
    real CoefficientOfRestitution;

    int unsigned NumberOfBoundingVertices;
    enum { MaxNumberOfBoundingVertices = 20 };
    vector_3 aBodyBoundingVertices[MaxNumberOfBoundingVertices];

    enum { NumberOfConfigurations = 2 };

    struct configuration
    {
        // primary quantities
        vector_3 CMPosition;
        matrix_3x3 Orientation;

        vector_3 CMVelocity;
        vector_3 AngularMomentum;

        vector_3 CMForce;
        vector_3 Torque;

        // auxiliary quantities
        matrix_3x3 InverseWorldInertiaTensor;
        vector_3 AngularVelocity;
        
        vector_3 aBoundingVertices[MaxNumberOfBoundingVertices];

    } aConfigurations[NumberOfConfigurations];
};

class simulation_world
{
public:

    simulation_world( real WorldX, real WorldY, real WorldZ );

    void Simulate( real DeltaTime );
    void Render( void );
    
    ~simulation_world( void );

private:

    void InitializeBodies( void );
    void InitializeRendering( void );

    enum collision_state
    {
        Penetrating,
        Colliding,
        Clear
    } CollisionState;

    vector_3 CollisionNormal;
    int CollidingBodyIndex;
    int CollidingCornerIndex;

    int SourceConfigurationIndex;
    int TargetConfigurationIndex;

    void ComputeForces( int ConfigurationIndex );
    void Integrate( real DeltaTime );
    collision_state CheckForCollisions( int ConfigurationIndex );
    void ResolveCollisions( int ConfigurationIndex );
    void CalculateVertices( int ConfigurationIndex );

    enum { NumberOfWalls = 6 };
    struct wall
    {
        // define wall by plane equation
        vector_3 Normal;        // inward pointing
        real d;                 // ax + by + cz + d = 0
    } aWalls[NumberOfWalls];

    enum { NumberOfBodies = 6 };
    rigid_body aBodies[NumberOfBodies];
};

#endif
