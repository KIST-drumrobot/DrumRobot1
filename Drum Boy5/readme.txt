%%%%%%%%% beatDrum %%%%%%%%% 
wrist snap ver.1
spherical coordinates applied for stick orientation

%%%%%%%%% beatDrum2 %%%%%%%%% 
wrist snap ver.2
similar to ver.1, but the orientations of phi and theta is created for the wrist.
instead, the phi of stick orientation is removed.
The reason of this change is to remove the joint movement considered unneccesary which might cause undesired vibration

%%%%%%%%% beatDrum3 %%%%%%%%% 
quaternion application to overcome the problem of theta going to negative
Jacobian ill-conditioned and records rank 15 < 18

%%%%%%%%% beatDrum4 %%%%%%%%% 
stick orientation expressed in Cartesian coordinates
its desired value expressed as sequence of rotation matrices since the orientation position is constrained by the stick length 

%%%%%%%%% beatDrum5 %%%%%%%%% 
acceleration additionally considered in trajectory generation

%%%%%%%%% beatDrum6 %%%%%%%%% 
stick orientation expressed as euler angle which remove the need of euler angle-to-cartesian conversion
some unknown problem occurs...

%%%%%%%%% beatDrum7 %%%%%%%%% 
Based on beatDrum5.
To constrain joint angles, the weight matrix W was introduced.
When a joint angle reached its limit, W stopped it.
However, since theoretically it affects particular solution as well as homogeneous one, this causes inaccuracy and joint angle jitter

W matrix redefined with pre-defined function. It works well. (beatDrum5)

%%%%%%%%% beatDrum8 %%%%%%%%% 
Found and applied the method to use rotation matrix itself as stick orientation.
The orientation worked well, but the rest part but stick became a mess.

%%%%%%%%% beatDrum9 %%%%%%%%%
Based on beatDrum5. Pxz replaced with Pyz.
rT separated into the left and right.

%%%%%%%%% beatDrum10 %%%%%%%%%
Orientation using quarternion.
For head motion, Rzx and Rxz related to (phi,theta) explored... 
Rzx makes phi still. Instead the body moves by phi.
Rxz makes the body almost still with the neck all phi-moving. Fuck. No harmony..
Rzx would be the worse choice from the worst Rxz.

%%%%%%%%% beatDrum11 %%%%%%%%%
Based on beatDrum10.
But, the number of desired orientation for head reduced: (phi,theta) -> (theta)

%%%%%%%%% beatDrum12 %%%%%%%%%
Based on beatDrum10.
For head motion, projection method(Pyz) adopted such that the head moves harmoneously with the body.
The problem at "beatDrum10" caused by no redundant dofs in head(Rzxz), I guess.

%%%%%%%%% beatDrum13 %%%%%%%%%
Based on beatDrum12.
6th-order Bezier curve adopted for strike trajectory to prevent the exaggerated stick motion.

%%%%%%%%% beatDrum14 %%%%%%%%%
Based on beatDrum9 and 13.
Without quaternion orientation but with projection method to make the arm more flexible (higher redundancy)

%%%%%%%%% beatDrum15 %%%%%%%%%
Based on beatDrum13.
7th-order Bezier curve adopted instead of 6th-order one to control the jerk at the last moment, too.

%%%%%%%%% beatDrum16 %%%%%%%%%
Based on beatDrum13.
Returned to 5th-order Bezier curve.
Instead, a shape function introduced to adjust the curve height for z- and theta-directions.

%%%%%%%%% beatDrum17 %%%%%%%%%
Based on beatDrum13.
Returned to 5th-order Bezier curve.
Wrist's z-position trajectory modified:
after the second half of contact phase, d2xd = 0;dxd = 0;d2xT = 0;dxT = 0;xd;xT;xT+0.2*td*a
6-th Bezier curve adopted;

%%%%%%%%% beatDrum18 %%%%%%%%%
Based on beatDrum17.
Wrist's z-position trajectory modified:
at the second half of contact phase, d2xd = 0;dxd = 0;xd;dxT = 0.02*a;
cubic Bezier curve adopted;

%%%%%%%%% beatDrum20 %%%%%%%%%
closed-loop resolved rate/accelertion control and QP-based acceleration control
Different optimization method were explored:
In case of clrc, rom constraints can be realized by W matrix.
However, in case of clac, they are hard to be.
Therefore, quadratic programming(QP) is applied.

In clac, rom constraints can never be guaranteed.
However, damping force can be applied for particular joints whose motion is prone to be violated.
In simulation, clac is found to bring more smooth velocity curve than clrc due to it being working on acceleration level

%%%%%%%%% beatDrum21 %%%%%%%%%
based on beatDrum20.
Sequential quadratic programming is explored to find more general solution rather than instant one.

However, the optimization didn't progress for the reason that I still don't know...

%%%%%%%%% beatDrum22 %%%%%%%%%
based on beatDrum20. 
Task-space desired trajectory with more degrees of freedom. Flexible and tunable.
#1. "contact" trajectory : Always pure elastic collision
#2. "strike" trajectory :
    - Divided into two sections : i) lift-up, ii) pull-down
    - For "lift-up", maximum lift-up time computed lest a "hump" appear
    - i) Fifth-Bezier curve and "hold" utilized, or ii) cubic spline that guarantees acceleration continuity explored
#3. "stay" trajectory :
    - Fifth-Bezier curve and "hold" utilized

%%%%%%%%% beatDrum23 %%%%%%%%%
based on beatDrum22.
#2. "strike" trajectory : cubic spline with acceleration continuity adopted
#3. "stay" trajectory : damping and recursive method

%%%%%%%%% beatDrum24 %%%%%%%%%
based on beatDrum23.
#2. "strike" trajectory : damping and recursive method the same as "stay"
    - Relationship between initial velocity, reach(max. height), and damping found
    - Through many simulations, found a lookup table and used interpolations.

---------------------------------------------------------------------------
%%%%%%%%% beatDrum25 %%%%%%%%%
based on beatDrum24.
Jacobian seperated into body and head to remove head dependence on null space optimization
Consequently, head affects little on optimization

%%%%%%%%% beatDrum26 %%%%%%%%%
based on beatDrum24.
body rotation(q1) is independent of arm configuration.
q1 is determined by mean value of azimuths of left and right's target drums
---------------------------------------------------------------------------

%%%%%%%%% beatDrum26 %%%%%%%%%
back to 5th-order Bezier curve for swing trajectory. 
But, there is a problem of too much lift-up 
when swing time is equal to strike time and at the same time, is longer than or equal to beat time. 

%%%%%%%%% beatDrum27 %%%%%%%%%
adopted 6th-order Bezier curve to control the amount of lift-up by introducing initial jerk.

%%%%%%%%% beatDrum28 %%%%%%%%%
back to beatDrum24 with minor changes in beatDrum27... Fuck

%%%%%%%%% beatDrum29 %%%%%%%%%
based on beatDrum28
3-D wrist target velocity + target dphi

%%%%%%%%% beatDrum33 %%%%%%%%%
shoulder accelerations as well as body considered in qprc(quadratic programming for rate-resolved control)

%%%%%%%%% beatDrum34 %%%%%%%%%
based on beatDrum33
make stay-to-swing smooth by adding "boost-up"
due to this, swing function becomes compact
add and correct some play patterns for rimshot and HH
remove scale factor, sf
add an angle at which the body faces for target drum to q(1)
(in the old version, used only the body angle, q(1).
but this q(1) has a limit in being set based on the previous target)

%%%%%%%%% beatDrum35 %%%%%%%%%
based on beatDrum34
refine beatDrum34
add wrist delay factor for snap

%%%%%%%%% beatDrum36 %%%%%%%%%
based on beatDrum34
without wrist delay.. back to beatDrum34
the function "ratioLift2Hit" finds the appropriate "alpha", a scaling factor for lift velocity
to make wrist "always" reach the apex before the stick. 
however, the alpha sometimes doesn't exist when the difference between the initial and the target position is big..

%%%%%%%%% beatDrum37 %%%%%%%%%
based on beatDrum34
So remove the notion of the scaling, instead compute the lift velocity directly such that the wrist preceeds the stick

%%%%%%%%% beatDrum38 %%%%%%%%%
based on beatDrum34
organized beatDrum38. the lift velocity as well as the target velocity is predefined in the "targetPos" function.
and made the function execute once at a swing. 
But, the weakness is that when the lift tick is estimated, the swing velocity is approximated...

%%%%%%%%% beatDrum39 %%%%%%%%%
based on beatDrum38.
improved beatDrum38. the swing velocity is accurately estimated.

%%%%%%%%% beatDrum40 %%%%%%%%%
organized the swing rule, "codeRegen".
left hand penestrates the body in the middle of playing "codeWarVic.txt"... Fuck. 
back to beatDrum34 leaving refinements.. 
based on musical note

%%%%%%%%% beatDrum41 %%%%%%%%%
based on beatDrum40
based on not musical note but playing hand

%%%%%%%%% beatDrum42 %%%%%%%%%
(x,y,phi) regenerated every tick considering current and target values.
z-trajectory generated and theta-one scaled.

%%%%%%%%% beatDrum43 %%%%%%%%%
based on beatDrum42
Making acceleration curve convex onward dosen't work well
The method is to use 5-th order Bezier curve in hit phase, leaving the lift phase at it.
To prevent acceleration at the apex from moving the opposite to the way intended,
the initial lift velocity is determined by the condition that the acceleration should move the way intended.
However, the problem is when the next drum is placed lower than the previous one caused the undesired decceleration. 

%%%%%%%%% beatDrum44 %%%%%%%%%
based on beatDrum41
The lift velocity of z is calculated to make the apex-timing 15% faster than that of theta
using a simple acceleration level controller.
The algorithm is developed such that depending on the difference between the target and the current heights,
the "move" trajectory is superpositioned based on the apex-timing.

%%%%%%%%% beatDrum45 %%%%%%%%%
based on beatDrum42
The "move" trajectory generation method introduced in beatDrum44 is applied to z-trajectory

%%%%%%%%% beatDrum46 %%%%%%%%%
based on beatDrum44
The base trajectory is changed from theta to z.

%%%%%%%%% beatDrum47 %%%%%%%%%
based on beatDrum46
The hit and lift velocities are normalized and changed to vector forms.
human acceleration data referenced and applied to the algorithm.

%%%%%%%%% beatDrum48 %%%%%%%%%
based on beatDrum47
1) the special function "offset-swing" added to avoid collision with sticks.
2) at the calculation of phiT, the vector from center of body to shoulder is scaled by .95
to prevent a stick from penestrating the body
3) in the function of "codeRegen", a note over tQ is covered for simultaneous HH-SN
and the dissipation function of "dsspfl" is added for "float"
4) at the pattern "R-R-R", the cases of HH-HH-HH or RD-RD-RD is added 
and the dissipation for the middle one is scaled for dynamic motion
5) at the pattern "R-R-L", the case of simultaneous HH-SN is considered to correct the left swing time

%%%%%%%%% beatDrum49 %%%%%%%%%
based on beatDrum48
dual-step acceleration planning applied
their values pre-defined and tuned through a few simulations

%%%%%%%%% beatDrum50 %%%%%%%%%
based on beatDrum49
dual-step acceleration principle still but only applied
no more superposition method used
initial lift velocity modulated depending on the difference (xT-xi)

%%%%%%%%% beatDrum51 %%%%%%%%%
based on beatDrum50
no more about defining the initial lift velocity
instead, more intuitively focused on apex-height
planar lift velocity is too fast and suddenly stop at the point il.. no good.

%%%%%%%%% beatDrum52 %%%%%%%%%
based on beatDrum51
planar lift velocity is defined as mean velocity

%%%%%%%%% beatDrum53 %%%%%%%%%
based on beatDrum52
In the hit phase, 5th order bezier curve applied for z and theta thereby making the acceleration curve convex/concave.
The target hit velocity is automatically computed to satisfy that acceleration curve.
In the contact phase, 5th order bezier curve applied for z and theta to make them return to the initial position.

%%%%%%%%% beatDrum54 %%%%%%%%%
based on beatDrum53
The undesired vibration is assumed to come from "sudden zero velocity" of (x,y,phi) in the contact phase.
The damping constants dependent on the initial velocity, as in beatDrum48, applied with the contact phase intact.
This went somewhat bad...

%%%%%%%%% beatDrum55 %%%%%%%%%
based on beatDrum53
phiT is optimized to minimize the distance to move from (x,y)i to (x,y)T
for "codeRegen", the algorithm tha helps natural movement generation 
added about when right moves alone and when both take a break 

%%%%%%%%% beatDrum56 %%%%%%%%%
based on beatDrum55
for the planar movement related to (x,y,phi), 
the algorithm that helps connecting current and next movements naturally
designed by adding "n1" of the next target drum instead of their moving at a constant speed
plus, wrist displacement minimization is applied and executed under a certain condition

%%%%%%%%% beatDrum57 %%%%%%%%%
based on beatDrum56
"codeRegen" is systematically modified

%%%%%%%%% beatDrum58 %%%%%%%%%
based on beatDrum57
"codeRegen" is organized and improved