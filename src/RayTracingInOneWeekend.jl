
module RayTracingInOneWeekend
using Images
using ProgressMeter
include("vectors.jl")
include("rays.jl")
include("hittable.jl")
include("sphere.jl")
include("camera.jl")

"""    ray_color(r::Ray)

Return the color of the void.
"""
function ray_color(r::Ray)
    unit_dir = unit_vector(r.direction)
    t = 0.5 * (unit_dir[2] + 1)
    primary = Color3(1, 1, 1)
    secondary = Color3(0.5, 0.7, 1.0)
    return t*primary + (1-t)*secondary
end

function ray_color(r::Ray, world, depth)
    rec = HitRecord()
    if depth < 0
        return Color3(0,0,0)
    end
    for obj in world
        t = hit!(r, obj, 0.001, Inf, rec)
        if t
            #N = rec.normal
            #return 0.5 * Color3(N[:] .+ 1)
            dir = rec.p + rec.normal + random_in_unit_sphere()
            return 0.5 * ray_color(Ray(rec.p, dir - rec.p), world, depth-1)
        end
    end
    return ray_color(r)
end

function write_color!(arr_r, arr_g, arr_b, i, j, color, nsamples)
    r, g, b = color[:] ./ nsamples
    arr_r[i,j] = r
    arr_g[i,j] = g
    arr_b[i,j] = b
end

function main()
    # Image
    aspect_ratio = 16/9
    img_width = 400
    img_height = trunc(Int, img_width/aspect_ratio)
    img_r = zeros(img_height, img_width)
    img_g = zero.(img_r)
    img_b = zero.(img_r)
    nsamples = 100
    max_depth = 50

    # Camera
    cam = Camera()

    # World
    scene = [Sphere(Point3(0,0,-1), 0.5), Sphere(Point3(0, -100.5,-1), 100)]

    # Rendering
    @showprogress "Rendering..." for i in 1:img_height
        for j in 1:img_width
            pixel_color = Color3(0, 0, 0)
            for n in 1:nsamples
                u = (j + rand())/img_width
                v = (img_height-i+rand())/img_height
                r = get_ray(cam, u, v)
                pixel_color += ray_color(r, scene, max_depth)
            end
            write_color!(img_r, img_g, img_b, i, j, pixel_color, nsamples)
        end
        save("render.png", colorview(RGB, img_r, img_g, img_b))
    end
end

end # module RayTracingInOneWeekend
