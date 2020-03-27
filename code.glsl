#version 410 core

uniform float fGlobalTime; // in seconds
uniform vec2 v2Resolution; // viewport resolution (in pixels)

uniform sampler1D texFFT; // towards 0.0 is bass / lower freq, towards 1.0 is higher / treble freq
uniform sampler1D texFFTSmoothed; // this one has longer falloff and less harsh transients
uniform sampler1D texFFTIntegrated; // this is continually increasing
uniform sampler2D texChecker;
uniform sampler2D texNoise;
uniform sampler2D texTex1;
uniform sampler2D texTex2;
uniform sampler2D texTex3;
uniform sampler2D texTex4;

layout(location = 0) out vec4 out_color; // out_color must be written in order to see anything
#define iTime fGlobalTime
mat2 r(float a){
  float c=cos(a),s=sin(a);
   return mat2(c,-s,s,c);
  }
void main(void)
{
  vec2 uv = (gl_FragCoord.xy-.5 * v2Resolution.xy)  / v2Resolution.y;
 for(float i=0.;i<=4.;i++){
        uv = abs(uv)-.1;
   }
 uv*=r(floor(cos(length(uv*2)*10)-iTime));
   vec3 col = vec3(0.);
  for(float y=-1.; y<=1.; y++) {
     float d =  .1;
  for(float x=-1.; x<=1.; x++){
      vec2 off = vec2(x,y);
     vec2 gv = off +uv;
    gv*=r(length(vec2(x,y))*10.+iTime);
     d += .05/length(gv+sin(iTime+10.*atan(uv.x,uv.y)));
  }
 col[int(mod(int(y)+2,2))] = d;
}
  col.br += sqrt(col.gr);
  out_color = vec4(col,1.);
}