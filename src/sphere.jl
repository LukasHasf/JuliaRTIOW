
struct Sphere <: Hittable
    center::Point3
    r::Float64
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
    if root < t_min || t_max < t_min
        root = (-half_b + sqrtd) / a
        return t_min < root < t_max
    end

    rec.t = root
    rec.p = at(r, rec.t)
    outward_normal = (rec.p - s.center)/ s.r
    set_face_normal!(rec, r, outward_normal)
    return true
end