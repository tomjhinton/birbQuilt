uniform vec2 u_resolution;
uniform float uTime;
  varying vec2 vUv;

  uniform float uValueA;
  uniform float uValueB;
  uniform float uValueC;
  uniform float uValueD;

varying float vTime;

const float PI = 3.1415926535897932384626433832795;
const float TAU = PI * 2.;
const float HALF_PI = PI * .5;

vec2 rotate2D (vec2 _st, float _angle) {
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}


vec2 rotateTilePattern(vec2 _st){

    //  Scale the coordinate system by 2x2
    _st *= 2.0;

    //  Give each cell an index number
    //  according to its position
    float index = 0.0;
    index += step(1., mod(_st.x,2.0));
    index += step(1., mod(_st.y,2.0))*2.0;

    //      |
    //  2   |   3
    //      |
    //--------------
    //      |
    //  0   |   1
    //      |

    // Make each cell between 0.0 - 1.0
    _st = fract(_st);

    // Rotate each cell according to the index
    if(index == 1.0){
        //  Rotate cell 1 by 90 degrees
        _st = rotate2D(_st,PI*0.5);
    } else if(index == 2.0){
        //  Rotate cell 2 by -90 degrees
        _st = rotate2D(_st,PI*-0.5);
    } else if(index == 3.0){
        //  Rotate cell 3 by 180 degrees
        _st = rotate2D(_st,PI);
    }

    return _st;
}


void coswarp(inout vec3 trip, float warpsScale ){

  trip.xyz += warpsScale * .1 * cos(3. * trip.yzx + (uValueB * .25));
  trip.xyz += warpsScale * .05 * cos(11. * trip.yzx + (uValueB * .25));
  trip.xyz += warpsScale * .025 * cos(17. * trip.yzx + (uValueB * .25));

}


void uvRipple(inout vec2 uv, float intensity){

	vec2 p = uv -.5;


    float cLength=length(p);

     uv= uv +(p/cLength)*cos(cLength*15.0-uValueC*.5)*intensity;

}

void coswarp2(inout vec2 trip, float warpsScale ){

  float vTime = uTime;
  trip.xy += warpsScale * .1 * cos(3. * trip.yx + (uValueA * .25));
  trip.xy += warpsScale * .05 * cos(11. * trip.yx + (uValueA * .25));
  trip.xy += warpsScale * .025 * cos(17. * trip.yx + (uValueA * .25));

}

  float stroke(float x, float s, float w){
  float d = step(s, x+ w * .5) - step(s, x - w * .5);
  return clamp(d, 0., 1.);
}

float smoothMod(float x, float y, float e){
    float top = cos(PI * (x/y)) * sin(PI * (x/y));
    float bot = pow(sin(PI * (x/y)),2.);
    float at = atan(top/bot);
    return y * (1./2.) - (1./PI) * at ;
}

vec2 modPolar(vec2 p, float repetitions) {
    float angle = 2.*3.14/repetitions;
    float a = atan(p.y, p.x) + angle/2.;
    float r = length(p);
    //float c = floor(a/angle);
    a = smoothMod(a,angle,033323231231561.9) - angle/2.;
    //a = mix(a,)
    vec2 p2 = vec2(cos(a), sin(a))*r;

    //p = mix(p,p2, pow(angle - abs(angle-(angle/2.) ) /angle , 2.) );

    return p2;
}


void main() {
 // position of the pixel divided by resolution, to get normalized positions on the canvas
	vec2 st = vUv;

	vec2 uv = fract(st * uValueD);
	//uvRipple(uv, .2);
	uv = rotateTilePattern(uv);
	//coswarp2(uv, 2.);


	vec2 uv2 = fract(uv * 2.);
	uv2 = rotateTilePattern(uv2);
	coswarp2(uv2, 2.);

  vec2 uv3 = modPolar(uv, uValueD);
	uv3 = rotateTilePattern(uv3);
//	uvRipple(uv3, .5);



float strength = step(0.002, abs(distance(uv, vec2(0.5)) - 0.25));

float strength2 = step(.2, max(abs(uv2.x - 0.5), abs(uv2.y - 0.5)));
strength2 *= 1.0 - step(0.25, max(abs(uv2.x - 0.5), abs(uv2.y - 0.5)));


	vec3 color = vec3(mix(strength, strength2, uv.x), mix(strength, strength2, uv2.y), mix(strength, strength2, uv3.x ));



  coswarp(color, 3.);

  if(st.x <.75 && st.y <.75){
    uv3 = modPolar(uv, uValueD * uValueA);
    color = vec3(mix( strength2, uv3.x, 1.), mix(strength * st.x, strength2, uv3.x), mix(strength, strength2, uv3.x ));
    uvRipple(color.rb, 2.);
    coswarp2(color.rg, 2.);
  }


  if(st.x <.75){
    strength = step(0.8, mod(vUv.x * uValueD, 1.0));
    color = vec3(mix(strength, strength2, uv.x), mix(strength, strength2, uv2.y), mix(strength, strength2, uv2.y ));
    coswarp2(color.rg, 2.);
  }

  if(st.y <.75){
      uv2 = modPolar(uv2, uValueD);
   color = vec3(uv.x, uv2.y, strength * uv3.x);
    coswarp2(color.bg, 2.);
  }
  //
  if(st.x <.5){
      uv2 = modPolar(uv2, uValueD * .5);
      strength = floor(vUv.x * 10.0) / 10.0 * floor(vUv.y * 10.0) / 10.0;
    color = vec3(mix(strength, strength2, uv.x), mix(strength, strength2, uv2.y), mix(strength2, strength, uv2.y ));
    uvRipple(color.rg, 2.);
  }

  if(st.y <.5){
    float barX = step(0.4, mod(vUv.x * uValueD - 0.2, 1.0)) * step(0.8, mod(vUv.y * uValueD, 1.0));
    float barY = step(0.8, mod(vUv.x * uValueD, 1.0)) * step(0.4, mod(vUv.y * uValueD - 0.2, 1.0));
 strength = barX + barY;
    color = vec3(mix(uv2.y, strength2, strength), mix(strength2, strength, uv2.y), mix(strength, strength2, uv.x ));
    uvRipple(color.bg, 2.);
  }


  if(st.y <.25){
   color = vec3(uv2.x, uv3.y, 1. * uv.x);
    coswarp2(color.rb, 2.);

  }
  if(st.x <.25){
    strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
    color = vec3(mix(strength, strength2, uv.x), mix(strength, strength2, uv2.y), mix(strength, strength2, uv3.x ));
    color.r += fract(uv * 10.).x;
    uvRipple(color.gb, 2.);
  }

  if(st.x <.25 && st.y <.25){
      uv2 = modPolar(uv2, uValueD * .2);
    color = vec3(mix(1., strength2, uv3.x), mix(strength, strength2, uv2.y), mix(strength, strength2, st.x ));
    uvRipple(color.rb, 2.);
  }

  //color.r += fract(uv * 10.).x;


	// color *= smoothstep(distance(st, vec2(.5)), .5, .8);
  //
  // color *= smoothstep(distance(uv2, vec2(.5)), .5, .8);
  //
  //  color *= smoothstep(distance(uv3, vec2(.5)), .5, .8);


  gl_FragColor = vec4(color,1.0);


}
