struct Camera
    aspect_ratio::Float64
    viewport_height::Float64
    viewport_width::Float64
    focal_length::Float64
    origin::Point3
    horizontal::Vec3
    vertical::Vec3
    lower_left_corner::Point3
end

function Camera()
    aspect_ratio = 16/9
    viewport_height = 2
    viewport_width = aspect_ratio * viewport_height
    focal_length = 1
    origin = Point3(0,0,0)
    horizontal = Vec3(viewport_width, 0, 0)
    vertical = Vec3(0, viewport_height, 0)
    lower_left_corner = origin - horizontal/2 - vertical/2 - Vec3(0, 0, focal_length)
    return Camera(aspect_ratio, viewport_height, viewport_width, focal_length, origin, horizontal, vertical, lower_left_corner)
end

function get_ray(c::Camera, u, v)
    return Ray(c.origin, Vec3(c.lower_left_corner + u*c.horizontal + v*c.vertical - c.origin))
end