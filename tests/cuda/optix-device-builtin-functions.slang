// TEST:SIMPLE(filecheck=CHECK): -target cuda
// CHECK: __global__ void __closesthit__fillHitpoint
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
[ForceInline]
[require(cuda_glsl_hlsl_spirv, raytracing_anyhit_closesthit_intersection)]
void transformFromObjectToWorld(inout float3 pPosition, inout float3 pGeometricNormal, inout float3 pShadingNormal)
{
    pPosition = float3(mul(ObjectToWorld(), float4(pPosition, 1.0)));

    // Transforms normals.
    {
        float3x3 lNormalMatrix = transpose(float3x3(WorldToObject()));
        pGeometricNormal = normalize(mul(lNormalMatrix, pGeometricNormal));
        pShadingNormal = normalize(mul(lNormalMatrix, pShadingNormal));
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct HitpointRayPayload
{
    float3 position;
    float3 ng;
    float3 ns;
};

[shader("closesthit")]
void fillHitpoint(in BuiltInTriangleIntersectionAttributes attr, inout HitpointRayPayload payload)
{
    transformFromObjectToWorld(payload.position, payload.ng, payload.ns);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

