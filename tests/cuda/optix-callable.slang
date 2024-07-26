struct CallableParameters
{
    float3 a;
    float c;
}

namespace test
{
[require(cuda, raytracing_raygen_closesthit_miss_callable)]
void CallShader<T>(uint pShaderIndex, inout T pParamaters)
{
    __target_switch
    {
    case cuda:
        __intrinsic_asm "optixDirectCall<void>($0, $1)";
    default:
        ::CallShader(pShaderIndex, pParamaters);
    }
}

[require(cuda, ser_raygen)]
void ReorderThread(uint pCoherenceHint, uint pNumCoherenceHintBitsFromLSB)
{
    __target_switch
    {
    case cuda:
        __intrinsic_asm "optixReorder($0, $1)";
    default:
        ::ReorderThread(pCoherenceHint, pNumCoherenceHintBitsFromLSB);
    }
}
}

void eval_edf(inout CallableParameters pParameters)
{
    pParameters.a = float3(1.f);
    pParameters.c = 2.f;
    pParameters.c += pParameters.a.x + pParameters.c;
}

[shader("callable")]
void eval_brdf(inout CallableParameters pParameters)
{
    pParameters.a = float3(1.f);
    pParameters.c = 2.f;
    pParameters.c += pParameters.a.x + pParameters.c;

    CallableParameters lParameters;
    eval_edf(lParameters);
    pParameters.c += lParameters.c;
}

[shader("raygeneration")]
void renderFrame()
{
    CallableParameters pParameters;
    CallShader(0, pParameters);
    test::CallShader(0, pParameters);
    test::ReorderThread(0, 0);
}