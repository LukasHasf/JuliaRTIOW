struct Camera
    aspect_ratio::Float64
    viewport_height::Float64
    viewport_width::Float64
    focal_length::Float64
    origin::Point3
    horizontal::Vec3
    vertical::Vec3
    lower_left_corner::Point3
    offset::Vec3
    lens_radius::Float64
    u::Vec3
    v::Vec3
end

function Camera(lookfrom, lookat, vup, vfov, aspect_ratio, aperture, focus_dist)
    θ = deg2rad(vfov)
    h = tan(θ/2)
    viewport_height = 2*h
    viewport_width = aspect_ratio * viewport_height

    w = unit_vector(lookfrom - lookat)
    u = unit_vector(cross(vup, w))
    v = cross(w, u)

    focal_length = 1
    origin = lookfrom
    horizontal = focus_dist * viewport_width * u
    vertical = focus_dist * viewport_height * v
    lower_left_corner = origin - horizontal/2 - vertical/2 - w * focus_dist
    offset = lower_left_corner - origin
    lens_radius = aperture/2

    return Camera(aspect_ratio, viewport_height, viewport_width, focal_length, origin, horizontal, vertical, lower_left_corner, offset, lens_radius, u, v)
end

function Camera(lookfrom, lookat, vup, vfov, aspect_ratio)
    return Camera(lookfrom, lookat, vup, vfov, aspect_ratio, 0, 1)
end

function Camera(vfov, aspect_ratio)
    return Camera(Point3(0, 0, 0), Point3(0, 0, -1), Vec3(0, 1, 0),vfov, aspect_ratio)
end

function Camera()
    aspect_ratio = 16/9
    return Camera(90, aspect_ratio)
end

function get_ray(c::Camera, u, v)
    rd = c.lens_radius * random_in_unit_disk()
    blur_offset = c.u * rd[1] + c.v * rd[2]
    return Ray(c.origin + blur_offset, Vec3(c.offset + u*c.horizontal + v*c.vertical - blur_offset))
end