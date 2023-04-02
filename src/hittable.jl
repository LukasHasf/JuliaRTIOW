abstract type Hittable end

mutable struct HitRecord
    p::Point3
    normal::Vec3
    t::Float64
    front_face::Bool
end

function HitRecord()
    return HitRecord(Point3(), Vec3(), 0, false)
end

function set_face_normal!(rec::HitRecord, r::Ray, outward_normal)
    front_face = dot(r.direction, outward_normal) < 0
    normal = front_face ? outward_normal : -outward_normal
    rec.front_face = front_face
    rec.normal = normal
end