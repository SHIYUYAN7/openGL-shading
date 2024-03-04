#version 330

in vec3 fN;
in vec3 fL;
in vec3 fE;
in vec2 texCoord;

out vec4 fColor;

uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec4 LightPosition;
uniform float Shininess;
uniform mat4 mVM;

uniform sampler2D diffuse_mat;
uniform samplerCube env_map;

void main()
{
   vec3 N = normalize (fN);
   vec3 E = normalize (fE);
   vec3 L = normalize (fL);

   vec3 H = normalize(L + E);
   vec3 R = (inverse(mVM)*vec4(reflect(-E,N),0.)).xyz;

	// Compute terms in the illumination equation
    vec4 ambient = AmbientProduct;
    float Kd = max(dot(L, N), 0.0);
    vec4  diffuse = Kd*DiffuseProduct* texture(env_map, R);
    float Ks = pow(max(dot(N, H), 0.0), Shininess);
    vec4  specular = Ks * SpecularProduct;
    if(dot(L, N) < 0.0) 
        specular = vec4(0.0, 0.0, 0.0, 1.0);

    fColor = ambient + diffuse + specular ;
    fColor.a = DiffuseProduct.a;

    
}