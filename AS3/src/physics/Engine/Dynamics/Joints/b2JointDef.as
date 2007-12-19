﻿/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package Engine.Dynamics.Joints{


import Engine.Common.Math.*
import Engine.Dynamics.*


public class b2JointDef
{
	
	public function b2JointDef()
	{
		type = b2Joint.e_unknownJoint;
		userData = null;
		body1 = null;
		body2 = null;
		collideConnected = false;
	}

	public var type:int;
	public var userData:*;
	public var body1:b2Body;
	public var body2:b2Body;
	public var collideConnected:Boolean;
	
}

}