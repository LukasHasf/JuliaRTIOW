import Base.-
import Base.+

abstract type AbstractVec3 end

mutable struct Vec3 <: AbstractVec3
    x::Float64
    y::Float64
    z::Float64
end

function Vec3()
    return Vec3(0.0, 0.0, 0.0)
end

function random_vec()
    return random_vec(0, 1)
end

function random_vec(v_min, v_max)
    values = v_min .+ (v_max - v_min) .* rand(3)
    return Vec3(values...)
end

Base.:-(v::AbstractVec3) = typeof(v)(-v.x, -v.y, -v.z)

Base.:+(v::AbstractVec3, w::AbstractVec3) = typeof(v)(v.x + w.x, v.y + w.y, v.z + w.z)

Base.:-(v::AbstractVec3, w::AbstractVec3) = v + (-w)

Base.:*(v::AbstractVec3, t) = typeof(v)(v.x*t, v.y*t, v.z*t)

Base.:*(t, v::AbstractVec3) = v * t

Base.:*(v::AbstractVec3, w::AbstractVec3) = typeof(v)(v.x * w.x, v.y * w.y, v.z * w.z)

Base.:/(v::AbstractVec3, t) = v * inv(t)

dot(v::AbstractVec3, w::AbstractVec3) = sum((v * w)[:])

cross(v::AbstractVec3, w::AbstractVec3) = typeof(v)(v.y * w.z - v.z * w.y,
                               v.z * w.x - v.x * w.z,
                               v.x * w.y - v.y * w.x)

Base.getindex(v::AbstractVec3, i::Core.Integer) = [v.x, v.y, v.z][i]

Base.getindex(v::AbstractVec3, c::Colon) = [v.x, v.y, v.z]

function random_in_unit_sphere()
    while(true)
        p = random_vec(-1, 1)
        if norm_squared(p) >= 1
            continue
        else
            return p
        end
    end
end

function norm_squared(v::AbstractVec3)
    return v.x^2 + v.y^2 + v.z^2
end

function norm(v::AbstractVec3)
    return sqrt(norm_squared(v))
end

function unit_vector(v::AbstractVec3)
    return v / norm(v)
end

Base.show(io::IO, v::Vec3) = print(io, "[$(v.x), $(v.y), $(v.z)]")

mutable struct Point3 <: AbstractVec3
    x::Float64
    y::Float64
    z::Float64
end

function Point3()
    return Point3(0, 0, 0)
end

function Vec3(p)
    return Vec3(p.x, p.y, p.z)
end

function Vec3(p::RayTracingInOneWeekend.Point3)
    return Vec3(p.x, p.y, p.z)
end

Base.:-(v::Point3, w::Point3) = Vec3(v + (-w))

mutable struct Color3 <: AbstractVec3
    x::Float64
    y::Float64
    z::Float64
end

function Color3()
    return Color3(0, 0, 0)
end

function Color3(a::AbstractVector)
    return Color3(a[1:3]...)
end

Base.convert(::Point3, v::Vec3) = Point3(v.x, v.y, v.z)
Base.convert(::RayTracingInOneWeekend.Point3, v::RayTracingInOneWeekend.Vec3) = Point3(v.x, v.y, v.z)