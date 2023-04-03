abstract type Hittable end

mutable struct HitRecord
    p::Point3
    normal::Vec3
    t::Float64
    front_face::Bool
    material::Material
end

function HitRecord()
    return HitRecord(Point3(), Vec3(), 0, false, Lambertian(Color3(0.5, 0.5, 0.5)))
end

function replicate!(rec::HitRecord, rec2::HitRecord)
    rec.p = rec2.p
    rec.normal = rec2.normal
    rec.t = rec2.t
    rec.front_face = rec2.front_face
    rec.material = rec2.material
end

function set_face_normal!(rec::HitRecord, r::Ray, outward_normal)
    front_face = dot(r.direction, outward_normal) < 0
    normal = front_face ? outward_normal : -outward_normal
    rec.front_face = front_face
    rec.normal = normal
end