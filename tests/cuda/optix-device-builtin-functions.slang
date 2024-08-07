
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef UVR_DOUBLE_PRECISION
public typedef double Float;
#else
public typedef float Float;
#endif

public typedef vector<Float, 2> Float2;
public typedef vector<Float, 3> Float3;
public typedef vector<Float, 4> Float4;

public typedef matrix<Float, 2, 2> Float2x2;
public typedef matrix<Float, 3, 3> Float3x3;
public typedef matrix<Float, 4, 4> Float4x4;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
[ForceInline]
[require(cuda_glsl_hlsl_spirv, raytracing_anyhit_closesthit_intersection)]
void transformFromObjectToWorld(inout Float3 pPosition, inout Float3 pGeometricNormal, inout Float3 pShadingNormal)
{
    pPosition = Float3(mul(ObjectToWorld(), Float4(pPosition, 1.0)));

    // Transforms normals.
    {
        Float3x3 lNormalMatrix = transpose(Float3x3(WorldToObject()));
        pGeometricNormal = normalize(mul(lNormalMatrix, pGeometricNormal));
        pShadingNormal = normalize(mul(lNormalMatrix, pShadingNormal));
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct HitpointCreateParams
{
    float2 uv;
    uint32_t instanceIdx;
    uint32_t primitiveIdx;
    float time;
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public struct TextureCoordinates
{
    public Float3 dndu;
    public Float3 dndv;
    public Float3 dpdu;
    public Float3 dpdv;
    public Float2 uv;

    [ForceInline]
    public __init()
    {
        dndu = {};
        dndv = {};
        dpdu = {};
        dpdv = {};
        uv = {};
    }
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public struct Hitpoint<let N : int = 2>
{
    public TextureCoordinates texCoords[N];
    public Float3 position;
    public uint32_t instanceIdx;
    public Float3 ng;
    public uint32_t primitiveIdx;
    public Float3 ns;
    public uint32_t subGeometryIdx;
    public Float distance;
    public bool backFaceHit;

    [ForceInline]
    public __init()
    {
        // texCoords = {};
        position = {};
        instanceIdx = 0;
        ng = {};
        primitiveIdx = 0;
        ns = {};
        subGeometryIdx = 0;
        distance = 0.0f;
        backFaceHit = false;
    }

    [ForceInline]
    public bool isValid()
    {
        return distance > 0.0f;
    }
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// [shader("callable")]
// void createHitpoint(in HitpointCreateParams pCreateParameters, out Hitpoint<2> pHitpoint)
// {
//     transformFromObjectToWorld(pHitpoint.position, pHitpoint.ng, pHitpoint.ns);
//     // pParameters.a = float3(1.f);
//     // pParameters.c = 2.f;
//     // pParameters.c += pParameters.a.x + pParameters.c;

//     // CallableParameters lParameters;
//     // eval_edf(lParameters);
//     // pParameters.c += lParameters.c;
// }

[shader("closesthit")]
void createHitpoint(in HitpointCreateParams pCreateParameters, out Hitpoint<2> pHitpoint)
{
    Hitpoint<2> pHitpoint;
    transformFromObjectToWorld(pHitpoint.position, pHitpoint.ng, pHitpoint.ns);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

