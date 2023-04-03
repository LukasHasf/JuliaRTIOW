abstract type Material end

struct Lambertian <: Material
    color::Color3
end

function Lambertian(r, g, b)
    return Lambertian(Color3(r,g,b))
end

struct Metal <: Material
    color::Color3
    f::Float64
end

function Metal(r,g,b,f)
    return Metal(Color3(r,g,b), clamp(f, 0, 1))
end

function Metal(r, g, b)
    return Metal(Color3(r,g,b), 0)
end

struct Dielectric <: Material
    ir::Float64
end

include("hittable.jl")

function scatter!(r::Ray, rec::HitRecord, m::Lambertian)
    scatter_direction = rec.normal + random_unit_vector()
    # Catch degenerate scatter direction
    if near_zero(scatter_direction)
        scatter_direction = rec.normal
    end
    scattered = Ray(rec.p, scatter_direction)
    attenuation = m.color
    return true, scattered, attenuation
end

function scatter!(r::Ray, rec::HitRecord, m::Metal)
    scatter_direction = reflect(unit_vector(r.direction), rec.normal)
    scattered = Ray(rec.p, scatter_direction + m.f * random_in_unit_sphere()) 
    attenuation = m.color
    return dot(scatter_direction, rec.normal) > 0, scattered, attenuation
end

function reflectance(cosine, ref_idx)
    #Use Schlick's approximation for reflectance.
    r0 = (1-ref_idx) / (1+ref_idx)
    r0 = r0^2
    return r0 + (1-r0)*(1-cosine)^5
end

function scatter!(r::Ray, rec::HitRecord, m::Dielectric)
    attenuation = Color3(1, 1, 1)
    refraction_ratio = rec.front_face ? inv(m.ir) : m.ir
    unit_dir = unit_vector(r.direction)
    cos_θ = min(dot(-unit_dir, rec.normal), 1)
    sin_θ = sqrt(1 - cos_θ^2)
    cannot_refract = refraction_ratio * sin_θ > 1
    direction = Vec3()
    if cannot_refract || reflectance(cos_θ, refraction_ratio) > rand()
        direction = reflect(unit_dir, rec.normal)
    else
        direction = refract(unit_dir, rec.normal, refraction_ratio)
    end
    
    scattered = Ray(rec.p, direction)
    return true, scattered, attenuation
end