struct Ray
    origin::Point3
    direction::Vec3
end

function at(r::Ray, t)
    return r.origin + t * r.direction
end