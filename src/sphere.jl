
struct Sphere <: Hittable
    center::Point3
    r::Float64
    material::Material
end

function Sphere(center::Point3, r)
    return Sphere(center, r, Lambertian(Color3(0.5,0.5,0.5)))
end

function Sphere()
    return Sphere(Point3(), 1.0)
end


function hit!(r::Ray, s::Sphere, t_min, t_max, rec::HitRecord)
    oc = r.origin - s.center
    dir = r.direction
    a = norm_squared(dir)
    half_b = dot(oc, dir)
    c = norm_squared(oc) - s.r^2
    discr = half_b^2 - a*c
    if discr < 0
        return false
    end
    sqrtd = sqrt(discr)
    root = (-half_b - sqrtd) / a
    if root < t_min || t_max < root
        root = (-half_b + sqrtd) / a
        if root < t_min || t_max < root
            return false
        end
    end

    rec.t = root
    rec.p = at(r, rec.t)
    outward_normal = (rec.p - s.center)/ s.r
    set_face_normal!(rec, r, outward_normal)
    rec.material = s.material
    return true
end